import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../database/tables/customers_table.dart';
import '../database/tables/products_table.dart';
import '../database/tables/system_tables.dart';
import '../database/tables/users_table.dart';

/// Resultado de una sincronización pull (descarga) desde Supabase.
class SyncPullResult {
  const SyncPullResult({
    required this.categories,
    required this.brands,
    required this.suppliers,
    required this.products,
    required this.variants,
    required this.customers,
    required this.users,
    required this.receiptConfigs,
    required this.paymentMethods,
    required this.tpvInventory,
    required this.failedTables,
  });

  final int categories;
  final int brands;
  final int suppliers;
  final int products;
  final int variants;
  final int customers;
  final int users;
  final int receiptConfigs;
  final int paymentMethods;
  final int tpvInventory;
  final List<String> failedTables;

  bool get hasErrors => failedTables.isNotEmpty;

  int get total =>
      categories +
      brands +
      suppliers +
      products +
      variants +
      customers +
      users +
      receiptConfigs +
      paymentMethods +
      tpvInventory;
}

/// Repositorio de sincronización: descarga el catálogo, clientes y vendedores
/// desde Supabase (rol anon = TPV activo) y los upserta en Drift.
///
/// Los IDs de Supabase (UUID) se conservan tal cual, por lo que las ventas
/// locales referencian los mismos ids que el backend y el sync es 1:1.
class SyncRepository {
  SyncRepository({
    required SupabaseClient client,
    required AppDatabase db,
  })  : _client = client,
        _db = db;

  final SupabaseClient _client;
  final AppDatabase _db;

  Future<SyncPullResult> pullAll() async {
    final failedTables = <String>[];

    Future<int> safePull(String table, Future<int> Function() pull) async {
      try {
        return await pull();
      } catch (e) {
        failedTables.add('$table: $e');
        debugPrint('[SyncRepository] Pull error ($table): $e');
        return 0;
      }
    }

    // Descargar inventario del TPV PRIMERO para tener el stock correcto
    // antes de escribir productos. Esto evita el parpadeo.
    final tpvStockMap = <String, double>{};
    final tpvVariantStockMap = <String, double>{};
    int tpvCount = 0;
    try {
      final rows = await _client.rpc('get_tpv_inventory');
      final list = (rows as List? ?? []);
      tpvCount = list.length;
      await _db.delete(_db.tpvInventory).go();
      await _db.batch((batch) {
        for (final r in list) {
          final row = r as Map<String, dynamic>;
          final productId = _str(row['product_id']);
          final variantId = _strOrNull(row['variant_id']);
          final stock = _num(row['stock']) ?? 0;
          batch.insert(
            _db.tpvInventory,
            TpvInventoryCompanion.insert(
              productId: productId,
              variantId: Value(variantId),
              stock: Value(stock),
            ),
            mode: InsertMode.insertOrReplace,
          );
          if (variantId != null) {
            tpvVariantStockMap[variantId] = stock;
          } else {
            tpvStockMap[productId] = stock;
          }
        }
      });
    } catch (e) {
      failedTables.add('tpv_inventory: $e');
      debugPrint('[SyncRepository] Pull error (tpv_inventory): $e');
    }

    // Descargar catálogos y productos en paralelo, pasando stock del TPV
    // para que se aplique DENTRO de la misma transacción (sin parpadeo).
    final catalogResults = await Future.wait([
      safePull('categories', _pullCategories),
      safePull('brands', _pullBrands),
      safePull('suppliers', _pullSuppliers),
      safePull('products', () => _pullProducts(
        tpvStock: tpvStockMap.isNotEmpty ? tpvStockMap : null,
        tpvVariantStock: tpvVariantStockMap.isNotEmpty ? tpvVariantStockMap : null,
      )),
      safePull('product_variants', _pullVariants),
      safePull('customers', _pullCustomers),
      safePull('profiles', _pullProfiles),
      safePull('receipt_configs', _pullReceiptConfig),
      safePull('payment_methods', _pullPaymentMethods),
    ]);

    return SyncPullResult(
      categories: catalogResults[0],
      brands: catalogResults[1],
      suppliers: catalogResults[2],
      products: catalogResults[3],
      variants: catalogResults[4],
      customers: catalogResults[5],
      users: catalogResults[6],
      receiptConfigs: catalogResults[7],
      paymentMethods: catalogResults[8],
      tpvInventory: tpvCount,
      failedTables: List.unmodifiable(failedTables),
    );
  }

  Future<int> _pullPaymentMethods() async {
    final rows = await _client.from('payment_methods').select('*').order('sort_order');
    await _db.batch((batch) {
      for (final r in rows) {
        batch.insert(
          _db.paymentMethods,
          PaymentMethodsCompanion.insert(
            id: Value(_str(r['id'])),
            code: _int(r['code']) ?? 0,
            label: _stringOr(r['label'], ''),
            icon: Value(_strOrNull(r['icon']) ?? 'credit-card'),
            isActive: Value(_bool(r['is_active']) ?? true),
            isCredit: Value(_bool(r['is_credit']) ?? false),
            sortOrder: Value(_int(r['sort_order']) ?? 0),
            createdAt: Value(_date(r['created_at']) ?? DateTime.now()),
            updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    return rows.length;
  }

  Future<int> _pullCategories() async {
    final rows = await _client
        .from('categories')
        .select('*')
        .isFilter('deleted_at', null)
        .eq('is_active', true);
    await _db.batch((batch) {
      for (final r in rows) {
        batch.insert(
          _db.categories,
          CategoriesCompanion.insert(
            id: Value(_str(r['id'])),
            name: _str(r['name']),
            colorHex: Value(_stringOr(r['color_hex'], '#5B5FEF')),
            iconName: Value(_strOrNull(r['icon_name'])),
            sortOrder: Value(_int(r['sort_order']) ?? 0),
            isActive: Value(_bool(r['is_active']) ?? true),
            createdAt: Value(_date(r['created_at']) ?? DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    return rows.length;
  }

  Future<int> _pullBrands() async {
    final rows = await _client.from('brands').select('*');
    await _db.batch((batch) {
      for (final r in rows) {
        batch.insert(
          _db.brands,
          BrandsCompanion.insert(
            id: Value(_str(r['id'])),
            name: _str(r['name']),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    return rows.length;
  }

  Future<int> _pullSuppliers() async {
    final rows = await _client
        .from('suppliers')
        .select('*')
        .isFilter('deleted_at', null)
        .eq('is_active', true);
    await _db.batch((batch) {
      for (final r in rows) {
        batch.insert(
          _db.suppliers,
          SuppliersCompanion.insert(
            id: Value(_str(r['id'])),
            name: _str(r['name']),
            contactName: Value(_strOrNull(r['contact_name'])),
            phone: Value(_strOrNull(r['phone'])),
            email: Value(_strOrNull(r['email'])),
            address: Value(_strOrNull(r['address'])),
            isActive: Value(_bool(r['is_active']) ?? true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    return rows.length;
  }

  /// Descarga productos del backend y los escribe en local.
  /// Si se provee [tpvStock], aplica el stock del TPV en la misma transacción
  /// para evitar parpadeo en la UI (stream se dispara solo una vez).
  Future<int> _pullProducts({Map<String, double>? tpvStock, Map<String, double>? tpvVariantStock}) async {
    final rows = await _client.from('products').select('*');

    final pending = await (_db.select(_db.syncQueueItems)
          ..where((t) =>
              t.entityTable.equals('products') &
              t.status.isInValues([
                SyncStatus.pending,
                SyncStatus.failed,
              ])))
        .get();
    final pendingIds = pending.map((p) => p.entityId).toSet();
    final remoteIds = rows.map((r) => _str(r['id'])).toSet();

    int upserted = 0;
    await _db.transaction(() async {
      for (final r in rows) {
        final id = _str(r['id']);
        if (pendingIds.contains(id)) continue;

        // Si tpvStock no es null, usar el stock del TPV (0 si el producto no está).
        // Si tpvStock es null (sin inventario), usar el stock del servidor.
        final stockFromTpv = tpvStock != null ? (tpvStock[id] ?? 0) : null;
        final stockValue = stockFromTpv ?? (_num(r['stock_quantity']) ?? 0);

        await _db.into(_db.products).insert(
              ProductsCompanion.insert(
                id: Value(id),
                name: _str(r['name']),
                description: Value(_strOrNull(r['description'])),
                sku: Value(_strOrNull(r['sku'])),
                barcode: Value(_strOrNull(r['barcode'])),
                categoryId: Value(_strOrNull(r['category_id'])),
                brandId: Value(_strOrNull(r['brand_id'])),
                supplierId: Value(_strOrNull(r['supplier_id'])),
                price: _num(r['price']) ?? 0,
                cost: Value(_num(r['cost']) ?? 0),
                taxRate: Value(_num(r['tax_rate']) ?? 0),
                unitType:
                    Value(_enumIndex(ProductUnitType.values, r['unit_type'])),
                trackStock: Value(_bool(r['track_stock']) ?? true),
                stockQuantity: Value(stockValue),
                lowStockThreshold: Value(_num(r['low_stock_threshold']) ?? 5),
                hasVariants: Value(_bool(r['has_variants']) ?? false),
                isFavorite: Value(_bool(r['is_favorite']) ?? false),
                isActive: Value(_bool(r['is_active']) ?? true),
                imagePath: Value(_strOrNull(r['image_url'])),
                createdAt: Value(_date(r['created_at']) ?? DateTime.now()),
                updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
              ),
              mode: InsertMode.insertOrReplace,
            );
        upserted++;
      }

      // Ocultar productos hard-eliminados.
      final localRows = await _db.select(_db.products).get();
      for (final local in localRows) {
        if (remoteIds.contains(local.id)) continue;
        if (pendingIds.contains(local.id)) continue;
        await (_db.update(_db.productVariants)
              ..where((tbl) => tbl.productId.equals(local.id)))
            .write(const ProductVariantsCompanion(isActive: Value(false)));
        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(local.id)))
            .write(ProductsCompanion(
          isActive: const Value(false),
          updatedAt: Value(DateTime.now()),
        ));
      }

      // Aplicar stock de variantes del TPV.
      if (tpvVariantStock != null && tpvVariantStock.isNotEmpty) {
        await (_db.update(_db.productVariants))
            .write(const ProductVariantsCompanion(stockQuantity: Value(0)));
        for (final entry in tpvVariantStock.entries) {
          await (_db.update(_db.productVariants)..where((t) => t.id.equals(entry.key)))
              .write(ProductVariantsCompanion(stockQuantity: Value(entry.value)));
        }
      }
    });
    return upserted;
  }

  Future<int> _pullVariants() async {
    final rows = await _client.from('product_variants').select('*');
    await _db.batch((batch) {
      for (final r in rows) {
        batch.insert(
          _db.productVariants,
          ProductVariantsCompanion.insert(
            id: Value(_str(r['id'])),
            productId: _str(r['product_id']),
            name: _str(r['name']),
            sku: Value(_strOrNull(r['sku'])),
            barcode: Value(_strOrNull(r['barcode'])),
            priceDelta: Value(_num(r['price_delta']) ?? 0),
            stockQuantity: Value(_num(r['stock_quantity']) ?? 0),
            isActive: Value(_bool(r['is_active']) ?? true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    return rows.length;
  }

  Future<int> _pullCustomers() async {
    final rows = await _client
        .from('customers')
        .select('*')
        .isFilter('deleted_at', null)
        .eq('is_active', true);
    debugPrint('[SyncRepository] _pullCustomers fetched ${rows.length} rows');

    final queued = await (_db.select(_db.syncQueueItems)
          ..where((t) =>
              t.entityTable.equals('customers') &
              t.status.isInValues([SyncStatus.pending, SyncStatus.failed])))
        .get();
    final queuedIds = queued.map((p) => p.entityId).toSet();
    if (queuedIds.isNotEmpty) {
      debugPrint('[SyncRepository] _pullCustomers queuedIds=$queuedIds (local wins until push succeeds)');
    }

    final remoteIds = rows.map((r) => _str(r['id'])).toSet();

    await _db.batch((batch) {
      for (final r in rows) {
        final id = _str(r['id']);
        // A local pending/failed operation is authoritative until its push
        // succeeds. Otherwise an active server row can resurrect a local
        // deletion before the queue gets a chance to upload it.
        if (queuedIds.contains(id)) {
          debugPrint('[SyncRepository] _pullCustomers preserving queued row id=$id');
          continue;
        }
        batch.insert(
          _db.customers,
          CustomersCompanion.insert(
            id: Value(id),
            fullName: _str(r['full_name']),
            documentId: Value(_strOrNull(r['document_id'])),
            phone: Value(_strOrNull(r['phone'])),
            email: Value(_strOrNull(r['email'])),
            address: Value(_strOrNull(r['address'])),
            type: Value(_enumIndex(CustomerType.values, r['type'])),
            creditLimit: Value(_num(r['credit_limit']) ?? 0),
            creditBalance: Value(_num(r['credit_balance']) ?? 0),
            isActive: Value(_bool(r['is_active']) ?? true),
            createdAt: Value(_date(r['created_at']) ?? DateTime.now()),
            updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
            deletedAt: Value(_date(r['deleted_at'])),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });

    final localRows = await _db.select(_db.customers).get();
    int deactivated = 0;
    for (final local in localRows) {
      if (remoteIds.contains(local.id)) continue;
      if (!local.isActive && local.deletedAt != null) continue;
      final isQueued = queuedIds.contains(local.id);
      if (isQueued) {
        // A pending/failed local operation is authoritative until push
        // succeeds. Never delete its queue entry during a pull: doing so
        // loses local deletes and causes the active server row to reappear.
        debugPrint('[SyncRepository] _pullCustomers preserving queued local customer id=${local.id}');
        continue;
      }
      await (_db.update(_db.customers)..where((tbl) => tbl.id.equals(local.id)))
          .write(CustomersCompanion(
        isActive: const Value(false),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
      deactivated++;
    }
    if (deactivated > 0) {
      debugPrint('[SyncRepository] _pullCustomers deactivated $deactivated local customers not in remote (soft-deleted on web)');
    }

    return rows.length;
  }

  Future<int> _pullProfiles() async {
    final rows = await _client.from('profiles').select('*');
    await _db.batch((batch) {
      for (final r in rows) {
        batch.insert(
          _db.users,
          UsersCompanion.insert(
            id: Value(_str(r['id'])),
            authUserId: Value(_strOrNull(r['auth_user_id'])),
            fullName: _str(r['full_name']),
            username: _str(r['username']),
            email: Value(_strOrNull(r['email'])),
            pinHash: _stringOr(r['pin_hash'], ''),
            pinSalt: _stringOr(r['pin_salt'], ''),
            role: _enumIndex(UserRole.values, r['role']),
            biometricEnabled: Value(_bool(r['biometric_enabled']) ?? false),
            isActive: Value(_bool(r['is_active']) ?? true),
            avatarPath: Value(_strOrNull(r['avatar_url'])),
            createdAt: Value(_date(r['created_at']) ?? DateTime.now()),
            updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    return rows.length;
  }

  Future<int> _pullReceiptConfig() async {
    final rows = await _client.from('receipt_configs').select('*').limit(1);
    if (rows.isEmpty) {
      debugPrint('[SyncRepository] No receipt config found in Supabase');
      return 0;
    }
    final r = rows.first;
    debugPrint('[SyncRepository] Receipt config synced: ${r['business_name']}');
    await _db.into(_db.receiptConfigs).insert(
          ReceiptConfigsCompanion.insert(
            id: _str(r['id']),
            branchId: Value(_strOrNull(r['branch_id'])),
            businessName: Value(_strOrNull(r['business_name'])),
            taxId: Value(_strOrNull(r['tax_id'])),
            address: Value(_strOrNull(r['address'])),
            phone: Value(_strOrNull(r['phone'])),
            header: Value(_strOrNull(r['header'])),
            footer: Value(_strOrNull(r['footer'])),
            thankYouMessage: Value(_strOrNull(r['thank_you_message'])),
            logoUrl: Value(_strOrNull(r['logo_url'])),
            logoPrintUrl: Value(_strOrNull(r['logo_print_url'])),
            showLogo: Value(_bool(r['show_logo']) ?? false),
            showTaxId: Value(_bool(r['show_tax_id']) ?? true),
            showAddress: Value(_bool(r['show_address']) ?? true),
            showPhone: Value(_bool(r['show_phone']) ?? true),
            printCopies: Value(_int(r['print_copies']) ?? 1),
            updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
    return 1;
  }

  // ── Helpers de conversión ──────────────────────────────────────────────────

  static String _str(Object? v) => v?.toString() ?? '';

  /// Devuelve el valor como String, o `null` si es nulo o vacío. Úsese para
  /// columnas nullable y sobre todo para claves foráneas (`references`), que
  /// no aceptan cadenas vacías.
  static String? _strOrNull(Object? v) {
    final String s = v?.toString() ?? '';
    return s.isEmpty ? null : s;
  }

  static String _stringOr(Object? v, String fallback) =>
      v == null ? fallback : v.toString();
  static double? _num(Object? v) =>
      v == null ? null : double.tryParse(v.toString());
  static int? _int(Object? v) => v == null ? null : int.tryParse(v.toString());
  static bool? _bool(Object? v) => v == null ? null : v == true;

  static DateTime? _date(Object? v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString())?.toLocal();
  }

  static T _enumIndex<T>(List<T> values, Object? v) {
    final int idx = _int(v) ?? 0;
    return idx >= 0 && idx < values.length ? values[idx] : values.first;
  }
}
