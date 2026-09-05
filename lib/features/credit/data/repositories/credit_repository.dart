import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/credit_entities.dart';

/// Resultado de registrar un abono con comprobante.
class AbonoReceiptResult {
  const AbonoReceiptResult({
    required this.receiptNumber,
    required this.totalAmount,
    required this.saleIds,
  });

  final String receiptNumber;
  final double totalAmount;
  final List<String> saleIds;
}

/// Repositorio de crédito / cartera.
///
/// Opera directamente contra Supabase usando las RPC ya existentes:
///   - get_credit_overview()
///   - get_customer_credit_summary(p_customer_id)
///   - register_abono_sale_with_receipt(...)
///   - register_abono_fifo_with_receipt(...)
///
/// El cálculo de balances se ejecuta en el servidor (SECURITY DEFINER),
/// por lo que esta capa es una fachada simple sobre esas funciones.
class CreditRepository {
  const CreditRepository(this._client);
  final SupabaseClient _client;

  /// Resumen de cartera: todos los clientes con saldo pendiente.
  Future<List<CreditOverviewItem>> getCreditOverview() async {
    final result = await _client.rpc('get_credit_overview');
    if (result == null) return [];
    final list = result as List;
    return list
        .map((e) => CreditOverviewItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Detalle de crédito de un cliente específico.
  Future<CreditSummary?> getCustomerCreditSummary(String customerId) async {
    final result = await _client.rpc(
      'get_customer_credit_summary',
      params: {'p_customer_id': customerId},
    );
    if (result == null) return null;
    final list = result as List;
    if (list.isEmpty) return null;
    return CreditSummary.fromJson(list.first as Map<String, dynamic>);
  }

  /// Historial de abonos de un cliente.
  Future<List<CreditPaymentRecord>> getCustomerPayments(String customerId) async {
    final result = await _client
        .from('credit_payments')
        .select()
        .eq('customer_id', customerId)
        .order('created_at', ascending: false);
    if (result == null) return [];
    final list = result as List;
    return list
        .map((e) => CreditPaymentRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Historial de comprobantes de abono de un cliente.
  Future<List<PaymentReceipt>> getCustomerReceipts(String customerId) async {
    final result = await _client
        .from('payment_receipts')
        .select()
        .eq('customer_id', customerId)
        .order('created_at', ascending: false);
    if (result == null) return [];
    final list = result as List;
    return list
        .map((e) => PaymentReceipt.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Todos los comprobantes de abono (vista global).
  Future<List<PaymentReceipt>> getAllReceipts() async {
    final result = await _client
        .from('payment_receipts')
        .select()
        .order('created_at', ascending: false)
        .limit(200);
    if (result == null) return [];
    final list = result as List;
    return list
        .map((e) => PaymentReceipt.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Registra un abono a factura específica con comprobante.
  Future<AbonoReceiptResult> registerAbono({
    required String saleId,
    required String customerId,
    required double amount,
    required int method,
    String? reference,
    String? deviceCode,
  }) async {
    final result = await _client.rpc('register_abono_sale_with_receipt', params: {
      'p_sale_id': saleId,
      'p_customer_id': customerId,
      'p_amount': amount,
      'p_method': method,
      'p_reference': reference,
      'p_device_code': deviceCode ?? 'MOB',
    });
    if (result == null) throw Exception('No se pudo registrar el abono');
    final row = (result as List).first as Map<String, dynamic>;
    return AbonoReceiptResult(
      receiptNumber: row['receipt_number'] as String? ?? '',
      totalAmount: (row['total_amount'] as num?)?.toDouble() ?? amount,
      saleIds: (row['sale_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [saleId],
    );
  }

  /// Registra un abono general (FIFO) con comprobante.
  Future<AbonoReceiptResult> registerAbonoGeneral({
    required String customerId,
    required double amount,
    required int method,
    String? reference,
    String? deviceCode,
  }) async {
    final result = await _client.rpc('register_abono_fifo_with_receipt', params: {
      'p_customer_id': customerId,
      'p_amount': amount,
      'p_method': method,
      'p_reference': reference,
      'p_device_code': deviceCode ?? 'MOB',
    });
    if (result == null) throw Exception('No se pudo registrar el abono');
    final row = (result as List).first as Map<String, dynamic>;
    return AbonoReceiptResult(
      receiptNumber: row['receipt_number'] as String? ?? '',
      totalAmount: (row['total_amount'] as num?)?.toDouble() ?? amount,
      saleIds: (row['sale_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
