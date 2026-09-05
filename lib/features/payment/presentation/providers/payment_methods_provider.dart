import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/tables/sales_tables.dart';
import '../../../../core/di/providers.dart';

/// Entidad de dominio para un método de pago configurado en el servidor.
class PaymentMethodConfig {
  const PaymentMethodConfig({
    required this.code,
    required this.label,
    required this.icon,
    required this.isCredit,
  });

  final int code;
  final String label;
  final String icon;
  final bool isCredit;

  IconData get iconData => _iconFor(icon);

  /// Mapea al enum interno [PaymentMethod] usado para registrar la venta.
  PaymentMethod get paymentMethod {
    final values = PaymentMethod.values;
    if (code >= 0 && code < values.length) return values[code];
    return PaymentMethod.cash;
  }

  static IconData _iconFor(String icon) => switch (icon) {
        'banknote' => Icons.payments_outlined,
        'credit-card' => Icons.credit_card,
        'arrow-left-right' => Icons.swap_horiz,
        'smartphone' => Icons.phone_android,
        _ => Icons.payments_outlined,
      };

  /// Icono por defecto para el código dado (fallback si el icono no se mapea).
  static IconData defaultIcon(int code) => switch (code) {
        0 => Icons.payments_outlined,
        1 => Icons.credit_card,
        2 => Icons.swap_horiz,
        3 => Icons.phone_android,
        4 => Icons.phone_android,
        5 => Icons.swap_horiz,
        6 => Icons.account_balance_wallet_outlined,
        _ => Icons.payments_outlined,
      };
}

/// Lista (ordenada) de métodos de pago activos configurados en el servidor.
final activePaymentMethodsProvider =
    StreamProvider<List<PaymentMethodConfig>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.paymentMethods)
        ..where((t) => t.isActive.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .watch()
      .map((rows) => rows
          .map((r) => PaymentMethodConfig(
                code: r.code,
                label: r.label,
                icon: r.icon,
                isCredit: r.isCredit,
              ))
          .toList());
});

/// Todos los métodos de pago configurados (activos e inactivos), ordenados.
final allPaymentMethodsProvider = StreamProvider<List<PaymentMethodConfig>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.paymentMethods)
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .watch()
      .map((rows) => rows
          .map((r) => PaymentMethodConfig(
                code: r.code,
                label: r.label,
                icon: r.icon,
                isCredit: r.isCredit,
              ))
          .toList());
});
