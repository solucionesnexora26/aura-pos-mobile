import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'customers_table.dart';
import 'products_table.dart';
import 'users_table.dart';

/// Estado del ciclo de vida de una venta.
/// [open] representa una "venta abierta" / ticket en espera, guardada sin
/// cobrar y recuperable posteriormente para editar o cobrar.
enum SaleStatus { open, paid, cancelled, refunded }

enum PaymentMethod { cash, card, transfer, nequi, daviplata, mixed, credit }

/// Etiqueta legible en español para cada método de pago.
extension PaymentMethodLabel on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.cash => 'Efectivo',
        PaymentMethod.card => 'Tarjeta',
        PaymentMethod.transfer => 'Transferencia',
        PaymentMethod.nequi => 'Nequi',
        PaymentMethod.daviplata => 'Daviplata',
        PaymentMethod.mixed => 'Mixto',
        PaymentMethod.credit => 'Crédito',
      };
}

@DataClassName('SaleRow')
class Sales extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get ticketNumber => text()(); // correlativo visible en recibo
  TextColumn get ticketLabel => text().nullable()(); // nombre libre para ventas abiertas, ej. "Mesa 4"
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get cashRegisterId => text().nullable()();
  IntColumn get status => intEnum<SaleStatus>().withDefault(const Constant(0))();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get discountTotal => real().withDefault(const Constant(0))();
  RealColumn get taxTotal => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  RealColumn get changeGiven => real().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get paidAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SaleItemRow')
class SaleItems extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get variantId => text().nullable().references(ProductVariants, #id)();
  TextColumn get productNameSnapshot => text()(); // se conserva el nombre aunque el producto cambie luego
  RealColumn get unitPrice => real()();
  RealColumn get quantity => real()(); // negativo para líneas de devolución
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get taxRate => real().withDefault(const Constant(0))();
  RealColumn get lineTotal => real()(); // firmado: negativo en devoluciones
  TextColumn get note => text().nullable()();
  // Devolución: marca la línea como devolución y guarda el motivo y el ticket
  // original (opcional) del que se devuelve.
  BoolColumn get isReturn => boolean().withDefault(const Constant(false))();
  TextColumn get returnReason => text().nullable()(); // deterioro | vencimiento | no_aceptacion | otro
  TextColumn get returnedFromTicket => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PaymentRow')
class Payments extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get saleId => text().references(Sales, #id)();
  IntColumn get method => intEnum<PaymentMethod>()();
  RealColumn get amount => real()();
  TextColumn get reference => text().nullable()(); // nº de aprobación, referencia de transferencia, etc.
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
