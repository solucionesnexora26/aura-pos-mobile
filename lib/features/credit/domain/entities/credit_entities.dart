/// Entidades del dominio de crédito / cartera.
///
/// Mapean los resultados de las RPC de Supabase:
///   - get_credit_overview → [CreditOverviewItem]
///   - get_customer_credit_summary → [CreditSummary]
///   - credit_payments (tabla) → [CreditPaymentRecord]

class CreditSalePending {
  const CreditSalePending({
    required this.saleId,
    required this.ticketNumber,
    required this.total,
    required this.createdAt,
    required this.paid,
    required this.pending,
  });

  final String saleId;
  final String ticketNumber;
  final double total;
  final DateTime createdAt;
  final double paid;
  final double pending;

  factory CreditSalePending.fromJson(Map<String, dynamic> json) {
    return CreditSalePending(
      saleId: json['sale_id'] as String,
      ticketNumber: json['ticket_number'] as String? ?? '',
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      paid: (json['paid'] as num).toDouble(),
      pending: (json['pending'] as num).toDouble(),
    );
  }

  double get percentPaid => total > 0 ? (paid / total).clamp(0.0, 1.0) : 0;
}

class CreditOverviewItem {
  const CreditOverviewItem({
    required this.customerId,
    required this.customerName,
    required this.creditLimit,
    required this.creditLimitEffective,
    required this.creditBalance,
    required this.totalOwed,
    required this.pendingSales,
    this.oldestSaleDate,
    required this.daysSinceOldest,
  });

  final String customerId;
  final String customerName;
  final double creditLimit;
  final double creditLimitEffective;
  final double creditBalance;
  final double totalOwed;
  final List<CreditSalePending> pendingSales;
  final DateTime? oldestSaleDate;
  final int daysSinceOldest;

  factory CreditOverviewItem.fromJson(Map<String, dynamic> json) {
    final pendingRaw = json['pending_sales'] as List? ?? [];
    final creditBalance = (json['credit_balance'] as num).toDouble();
    final totalOwedRpc = (json['total_owed'] as num?)?.toDouble() ?? 0;
    final creditLimitRaw = (json['credit_limit'] as num).toDouble();
    final creditLimitEffectiveRaw = (json['credit_limit_effective'] as num?)?.toDouble() ?? 0;
    final pendingSales = pendingRaw
        .map((e) => CreditSalePending.fromJson(e as Map<String, dynamic>))
        .toList();
    // Si la RPC no devuelve total_owed (migración antigua), se calcula
    // sumando el campo pending de cada venta pendiente.
    final totalOwedComputed = pendingSales.fold<double>(0, (s, p) => s + p.pending);
    final totalOwed = totalOwedRpc > 0 ? totalOwedRpc : totalOwedComputed;
    return CreditOverviewItem(
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String,
      creditLimit: creditLimitRaw,
      creditLimitEffective: creditLimitEffectiveRaw > 0 ? creditLimitEffectiveRaw : creditLimitRaw,
      creditBalance: creditBalance,
      totalOwed: totalOwed,
      pendingSales: pendingSales,
      oldestSaleDate: json['oldest_sale_date'] != null
          ? DateTime.tryParse(json['oldest_sale_date'] as String)
          : null,
      daysSinceOldest: json['days_since_oldest'] as int? ?? 0,
    );
  }

  int get pendingCount => pendingSales.length;
}

class CreditSummary {
  const CreditSummary({
    required this.creditLimit,
    required this.creditLimitEffective,
    required this.creditBalance,
    required this.totalOwed,
    required this.totalSalesCredit,
    required this.totalPaid,
    required this.pendingSales,
  });

  final double creditLimit;
  final double creditLimitEffective;
  final double creditBalance;
  final double totalOwed;
  final int totalSalesCredit;
  final double totalPaid;
  final List<CreditSalePending> pendingSales;

  factory CreditSummary.fromJson(Map<String, dynamic> json) {
    final pendingRaw = json['pending_sales'] as List? ?? [];
    final creditBalance = (json['credit_balance'] as num).toDouble();
    final totalOwedRpc = (json['total_owed'] as num?)?.toDouble() ?? 0;
    final pendingSales = pendingRaw
        .map((e) => CreditSalePending.fromJson(e as Map<String, dynamic>))
        .toList();
    // Si la RPC no devuelve total_owed (migración antigua), se calcula
    // sumando el campo pending de cada venta pendiente.
    final totalOwedComputed = pendingSales.fold<double>(0, (s, p) => s + p.pending);
    final totalOwed = totalOwedRpc > 0 ? totalOwedRpc : totalOwedComputed;
    final creditLimitRaw = (json['credit_limit'] as num).toDouble();
    final creditLimitEffectiveRaw = (json['credit_limit_effective'] as num?)?.toDouble() ?? 0;
    return CreditSummary(
      creditLimit: creditLimitRaw,
      creditLimitEffective: creditLimitEffectiveRaw > 0 ? creditLimitEffectiveRaw : creditLimitRaw,
      creditBalance: creditBalance,
      totalOwed: totalOwed,
      totalSalesCredit: json['total_sales_credit'] as int? ?? 0,
      totalPaid: (json['total_paid'] as num).toDouble(),
      pendingSales: pendingSales,
    );
  }

  /// Cupo disponible = límite efectivo − total adeudado real. Si el límite
  /// efectivo es 0 (sin límite configurado), devuelve 0.
  double get availableCredit {
    if (creditLimitEffective <= 0) return 0;
    final available = creditLimitEffective - totalOwed;
    return available < 0 ? 0 : available;
  }
}

class CreditPaymentRecord {
  const CreditPaymentRecord({
    required this.id,
    required this.saleId,
    required this.customerId,
    required this.amount,
    required this.method,
    this.reference,
    this.userId,
    required this.createdAt,
  });

  final String id;
  final String saleId;
  final String customerId;
  final double amount;
  final int method;
  final String? reference;
  final String? userId;
  final DateTime createdAt;

  factory CreditPaymentRecord.fromJson(Map<String, dynamic> json) {
    return CreditPaymentRecord(
      id: json['id'] as String,
      saleId: json['sale_id'] as String,
      customerId: json['customer_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as int,
      reference: json['reference'] as String?,
      userId: json['user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static const _methodLabels = {
    0: 'Efectivo',
    1: 'Tarjeta',
    2: 'Transferencia',
    3: 'Nequi',
    4: 'Daviplata',
    5: 'Mixto',
  };

  String get methodLabel => _methodLabels[method] ?? 'Otro';
}

/// Comprobante de abono emitido.
class PaymentReceipt {
  const PaymentReceipt({
    required this.id,
    required this.receiptNumber,
    required this.customerId,
    this.customerName,
    required this.totalAmount,
    required this.method,
    this.reference,
    required this.saleIds,
    this.tpvId,
    this.userId,
    required this.createdAt,
  });

  final String id;
  final String receiptNumber;
  final String customerId;
  final String? customerName;
  final double totalAmount;
  final int method;
  final String? reference;
  final List<String> saleIds;
  final String? tpvId;
  final String? userId;
  final DateTime createdAt;

  factory PaymentReceipt.fromJson(Map<String, dynamic> json) {
    return PaymentReceipt(
      id: json['id'] as String,
      receiptNumber: json['receipt_number'] as String? ?? '',
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String?,
      totalAmount: (json['total_amount'] as num).toDouble(),
      method: json['method'] as int? ?? 0,
      reference: json['reference'] as String?,
      saleIds: (json['sale_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tpvId: json['tpv_id'] as String?,
      userId: json['user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static const _methodLabels = {
    0: 'Efectivo',
    1: 'Tarjeta',
    2: 'Transferencia',
    3: 'Nequi',
    4: 'Daviplata',
    5: 'Mixto',
  };

  String get methodLabel => _methodLabels[method] ?? 'Otro';
}
