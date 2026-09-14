import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables/cash_register_tables.dart';
import 'tables/catalog_tables.dart';
import 'tables/customers_table.dart';
import 'tables/inventory_tables.dart';
import 'tables/payment_methods_table.dart';
import 'tables/products_table.dart';
import 'tables/sales_tables.dart';
import 'tables/system_tables.dart';
import 'tables/tpv_inventory_table.dart';
import 'tables/users_table.dart';

part 'app_database.g.dart';

/// Base de datos local SQLite (Drift) de Aura POS.
///
/// Toda la aplicación funciona Offline First: ninguna operación depende de
/// Internet y toda transacción queda registrada aquí primero. La
/// sincronización remota (tabla [SyncQueueItems]) solo prepara el terreno
/// para un futuro backend FastAPI; no se implementa aún.
@DriftDatabase(
  tables: [
    Users,
    Categories,
    Brands,
    Suppliers,
    Products,
    ProductVariants,
    Customers,
    Sales,
    SaleItems,
    Payments,
    CashRegisters,
    CashMovements,
    InventoryMovements,
    PrinterConfigs,
    ReceiptConfigs,
    PaymentMethods,
    TpvInventory,
    SyncQueueItems,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor para tests: permite inyectar un [QueryExecutor] en memoria.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // SQLite no permite agregar columnas UNIQUE mediante ALTER TABLE, por
          // lo que recreamos la tabla local [users] con las nuevas columnas.
          await customStatement('''
            CREATE TABLE IF NOT EXISTS users_new (
              id TEXT NOT NULL PRIMARY KEY,
              auth_user_id TEXT UNIQUE,
              full_name TEXT NOT NULL,
              username TEXT NOT NULL UNIQUE,
              email TEXT UNIQUE,
              pin_hash TEXT NOT NULL,
              pin_salt TEXT NOT NULL,
              role INTEGER NOT NULL,
              biometric_enabled INTEGER NOT NULL DEFAULT 0,
              is_active INTEGER NOT NULL DEFAULT 1,
              avatar_path TEXT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NOT NULL
            )
          ''');
          await customStatement('''
            INSERT INTO users_new (
              id, full_name, username, pin_hash, pin_salt, role,
              biometric_enabled, is_active, avatar_path, created_at, updated_at
            )
            SELECT
              id, full_name, username, pin_hash, pin_salt, role,
              biometric_enabled, is_active, avatar_path, created_at, updated_at
            FROM users
          ''');
          await customStatement('DROP TABLE users');
          await customStatement('ALTER TABLE users_new RENAME TO users');
        }
        if (from < 3) {
          // Nueva tabla para configuración de recibo descargada desde la web admin.
          await m.createTable(receiptConfigs);
        }
        if (from < 4) {
          try {
            await m.addColumn(customers, customers.updatedAt);
          } catch (_) {}
          try {
            await m.addColumn(customers, customers.deletedAt);
          } catch (_) {}
        }
        if (from < 5) {
          try {
            await m.addColumn(cashMovements, cashMovements.method);
          } catch (_) {}
        }
        if (from < 6) {
          try {
            await m.createTable(paymentMethods);
          } catch (_) {}
        }
        if (from < 7) {
          try {
            await m.createTable(tpvInventory);
          } catch (_) {}
        }
        if (from < 8) {
          try {
            await m.addColumn(receiptConfigs, receiptConfigs.logoPrintUrl);
          } catch (_) {}
        }
        if (from < 9) {
          // Devoluciones: líneas negativas con motivo y ticket de origen.
          try {
            await m.addColumn(saleItems, saleItems.isReturn);
          } catch (_) {}
          try {
            await m.addColumn(saleItems, saleItems.returnReason);
          } catch (_) {}
          try {
            await m.addColumn(saleItems, saleItems.returnedFromTicket);
          } catch (_) {}
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dbFolder = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dbFolder.path, 'aura_pos.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
