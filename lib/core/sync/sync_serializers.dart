import '../database/app_database.dart';
import '../utils/validators.dart';

/// Convierte filas locales (Drift) a payloads con nombres de columna
/// snake_case de Supabase para el push offline. Los enums se serializan como
/// su índice numérico (mismo contrato que el schema SQL).
class SyncSerializers {
  static String? _opt(String? v) => v == null || v.isEmpty ? null : v;

  static String _iso(DateTime dt) => dt.toUtc().toIso8601String();

  static String? _isoOrNull(DateTime? dt) => dt?.toUtc().toIso8601String();

  /// Entidades locales con respaldo remoto que además pueden editarse en la
  /// web. Se aplica last-write-wins: al subir se hace upsert por `id` (la
  /// fila remota más reciente de una escritura gana), y al bajar se conserva
  /// lo local reciente (ver SyncRepository._pullCustomers).
  static Map<String, dynamic> customer(CustomerRow row) => {
        'id': row.id,
        'full_name': row.fullName,
        'document_id': _opt(row.documentId),
        'phone': _opt(row.phone),
        'email': _opt(row.email),
        'address': _opt(row.address),
        'type': row.type.index,
        'credit_limit': row.creditLimit,
        'credit_balance': row.creditBalance,
        'is_active': row.isActive,
        'created_at': _iso(row.createdAt),
        'updated_at': _iso(row.updatedAt),
        'deleted_at': _isoOrNull(row.deletedAt),
      };

  // ── Catálogo ───────────────────────────────────────────────────────────────

  /// `imagePath` puede ser una URL remota (Storage) o una ruta de archivo
  /// local del TPV. Solo se sube si es URL remota; las rutas locales no tienen
  /// sentido en la nube.
  static String? _remoteImage(String? path) {
    if (path == null) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return null;
  }

  static Map<String, dynamic> product(ProductRow row) => {
        'id': row.id,
        'name': row.name,
        'description': row.description,
        'sku': row.sku,
        'barcode': row.barcode,
        'category_id': row.categoryId,
        'brand_id': row.brandId,
        'supplier_id': row.supplierId,
        'price': row.price,
        'cost': row.cost,
        'tax_rate': row.taxRate,
        'unit_type': row.unitType.index,
        'track_stock': row.trackStock,
        'stock_quantity': row.stockQuantity,
        'low_stock_threshold': row.lowStockThreshold,
        'has_variants': row.hasVariants,
        'is_favorite': row.isFavorite,
        'is_active': row.isActive,
        'image_url': _remoteImage(row.imagePath),
        'created_at': _iso(row.createdAt),
        'updated_at': _iso(row.updatedAt),
      };

  static Map<String, dynamic> productVariant(ProductVariantRow row) => {
        'id': row.id,
        'product_id': row.productId,
        'name': row.name,
        'sku': row.sku,
        'barcode': row.barcode,
        'price_delta': row.priceDelta,
        'stock_quantity': row.stockQuantity,
        'is_active': row.isActive,
      };

  static Map<String, dynamic> category(CategoryRow row) => {
        'id': row.id,
        'name': row.name,
        'color_hex': row.colorHex,
        'icon_name': _opt(row.iconName),
        'sort_order': row.sortOrder,
        'is_active': row.isActive,
        'created_at': _iso(row.createdAt),
      };

  static Map<String, dynamic> brand(BrandRow row) => {
        'id': row.id,
        'name': row.name,
      };

  static Map<String, dynamic> supplier(SupplierRow row) => {
        'id': row.id,
        'name': row.name,
        'contact_name': _opt(row.contactName),
        'phone': _opt(row.phone),
        'email': _opt(row.email),
        'address': _opt(row.address),
        'is_active': row.isActive,
      };

  // ── Sales ──────────────────────────────────────────────────────────────────

  static Map<String, dynamic> sale(SaleRow row) {
    final userId = row.userId;
    if (userId.isNotEmpty && !Validators.isValidUuid(userId)) {
      throw ArgumentError(
        'sales.user_id debe ser un UUID válido o null. Valor rechazado: "$userId"',
      );
    }
    return {
      'id': row.id,
      'ticket_number': row.ticketNumber,
      'ticket_label': row.ticketLabel,
      'customer_id': row.customerId,
      'user_id': userId,
      'cash_register_id': row.cashRegisterId,
      'status': row.status.index,
      'subtotal': row.subtotal,
      'discount_total': row.discountTotal,
      'tax_total': row.taxTotal,
      'total': row.total,
      'change_given': row.changeGiven,
      'note': row.note,
      'created_at': _iso(row.createdAt),
      'updated_at': _iso(row.updatedAt),
      'paid_at': _isoOrNull(row.paidAt),
    };
  }

  static Map<String, dynamic> saleItem(SaleItemRow row) => {
        'id': row.id,
        'sale_id': row.saleId,
        'product_id': row.productId,
        'variant_id': row.variantId,
        'product_name_snapshot': row.productNameSnapshot,
        'unit_price': row.unitPrice,
        'quantity': row.quantity,
        'discount': row.discount,
        'tax_rate': row.taxRate,
        'line_total': row.lineTotal,
        'note': row.note,
      };

  static Map<String, dynamic> payment(PaymentRow row) => {
        'id': row.id,
        'sale_id': row.saleId,
        'method': row.method.index,
        'amount': row.amount,
        'reference': row.reference,
        'created_at': _iso(row.createdAt),
      };

  // ── Caja ───────────────────────────────────────────────────────────────────

  static Map<String, dynamic> cashRegister(CashRegisterRow row) => {
        'id': row.id,
        'user_id': row.userId,
        'shift_label': _opt(row.shiftLabel),
        'opening_amount': row.openingAmount,
        'expected_closing_amount': row.expectedClosingAmount,
        'counted_closing_amount': row.countedClosingAmount,
        'difference': row.difference,
        'status': row.status.index,
        'opened_at': _iso(row.openedAt),
        'closed_at': _isoOrNull(row.closedAt),
        'note': _opt(row.note),
      };

  static Map<String, dynamic> cashMovement(CashMovementRow row) => {
        'id': row.id,
        'cash_register_id': row.cashRegisterId,
        'sale_id': row.saleId,
        'type': row.type.index,
        'amount': row.amount,
        'method': row.method,
        'description': _opt(row.description),
        'user_id': row.userId,
        'created_at': _iso(row.createdAt),
      };

  // ── Inventario ─────────────────────────────────────────────────────────────

  static Map<String, dynamic> inventoryMovement(InventoryMovementRow row) => {
        'id': row.id,
        'product_id': row.productId,
        'variant_id': row.variantId,
        'type': row.type.index,
        'quantity': row.quantity,
        'stock_before': row.stockBefore,
        'stock_after': row.stockAfter,
        'reason': _opt(row.reason),
        'reference_id': _opt(row.referenceId),
        'user_id': row.userId,
        'created_at': _iso(row.createdAt),
      };
}
