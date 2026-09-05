import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Tabla local que cachea la configuración de métodos de pago del servidor.
///
/// Se descarga desde Supabase durante el sync (tabla `payment_methods`) y
/// alimenta las pantallas de POS y Abono, reflejando exactamente qué métodos
/// están activos (is_active), cómo se llaman (label), su icono (icon) y si
/// son de crédito (is_credit).
@DataClassName('PaymentMethodRow')
class PaymentMethods extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  IntColumn get code => integer()();
  TextColumn get label => text()();
  TextColumn get icon => text().withDefault(const Constant('credit-card'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isCredit => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
