import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

enum PrinterConnectionType { bluetooth, usb, network }
enum PrinterPaperWidth { mm58, mm80 }
enum SyncOperation { create, update, delete }
enum SyncStatus { pending, syncing, synced, failed }

@DataClassName('PrinterConfigRow')
class PrinterConfigs extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get connectionType => intEnum<PrinterConnectionType>()();
  TextColumn get address => text()(); // MAC (bluetooth), IP (network) o deviceId (usb)
  IntColumn get port => integer().nullable()(); // solo network
  IntColumn get paperWidth => intEnum<PrinterPaperWidth>().withDefault(const Constant(1))();
  BoolColumn get autoCut => boolean().withDefault(const Constant(true))();
  TextColumn get logoPath => text().nullable()();
  TextColumn get headerText => text().nullable()();
  TextColumn get footerText => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cola de operaciones pendientes de sincronizar con el backend FastAPI.
/// El servidor aún no existe: esta tabla solo prepara la arquitectura
/// offline-first para cuando se habilite la sincronización remota.
@DataClassName('SyncQueueRow')
class SyncQueueItems extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get entityTable => text()(); // nombre de la tabla origen, ej. "sales"
  TextColumn get entityId => text()();
  IntColumn get operation => intEnum<SyncOperation>()();
  TextColumn get payloadJson => text()(); // snapshot serializado de la entidad
  IntColumn get status => intEnum<SyncStatus>().withDefault(const Constant(0))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName('ReceiptConfigRow')
class ReceiptConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text().nullable()();
  TextColumn get businessName => text().nullable()();
  TextColumn get taxId => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get header => text().nullable()();
  TextColumn get footer => text().nullable()();
  TextColumn get thankYouMessage => text().nullable()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get logoPrintUrl => text().nullable()();
  BoolColumn get showLogo => boolean().withDefault(const Constant(false))();
  BoolColumn get showTaxId => boolean().withDefault(const Constant(true))();
  BoolColumn get showAddress => boolean().withDefault(const Constant(true))();
  BoolColumn get showPhone => boolean().withDefault(const Constant(true))();
  IntColumn get printCopies => integer().withDefault(const Constant(1))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
