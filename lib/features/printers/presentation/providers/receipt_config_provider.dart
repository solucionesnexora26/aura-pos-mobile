import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/di/providers.dart';

// ─── Entidad ──────────────────────────────────────────────────────────────────

class ReceiptConfigEntity {
  const ReceiptConfigEntity({
    required this.id,
    this.branchId,
    this.businessName,
    this.taxId,
    this.address,
    this.phone,
    this.header,
    this.footer,
    this.thankYouMessage,
    this.logoUrl,
    this.logoPrintUrl,
    required this.showLogo,
    required this.showTaxId,
    required this.showAddress,
    required this.showPhone,
    required this.printCopies,
  });

  final String id;
  final String? branchId;
  final String? businessName;
  final String? taxId;
  final String? address;
  final String? phone;
  final String? header;
  final String? footer;
  final String? thankYouMessage;
  final String? logoUrl;
  final String? logoPrintUrl;
  final bool showLogo;
  final bool showTaxId;
  final bool showAddress;
  final bool showPhone;
  final int printCopies;

  /// Mensaje de agradecimiento con valor por defecto.
  String get thankYou => (thankYouMessage?.trim().isNotEmpty ?? false)
      ? thankYouMessage!
      : 'Gracias por su compra!';
}

// ─── Repositorio ──────────────────────────────────────────────────────────────

class ReceiptConfigRepositoryImpl {
  const ReceiptConfigRepositoryImpl(this._db);
  final AppDatabase _db;

  ReceiptConfigEntity _toEntity(ReceiptConfigRow r) => ReceiptConfigEntity(
        id: r.id,
        branchId: r.branchId,
        businessName: r.businessName,
        taxId: r.taxId,
        address: r.address,
        phone: r.phone,
        header: r.header,
        footer: r.footer,
        thankYouMessage: r.thankYouMessage,
        logoUrl: r.logoUrl,
        logoPrintUrl: r.logoPrintUrl,
        showLogo: r.showLogo,
        showTaxId: r.showTaxId,
        showAddress: r.showAddress,
        showPhone: r.showPhone,
        printCopies: r.printCopies,
      );

  Stream<ReceiptConfigEntity?> watchConfig() {
    return (_db.select(_db.receiptConfigs)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .watch()
        .map((rows) => rows.isEmpty ? null : _toEntity(rows.first));
  }

  Future<ReceiptConfigEntity?> getConfig() async {
    final rows = await (_db.select(_db.receiptConfigs)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
    return rows.isEmpty ? null : _toEntity(rows.first);
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final Provider<ReceiptConfigRepositoryImpl> receiptConfigRepositoryProvider =
    Provider<ReceiptConfigRepositoryImpl>(
        (ref) => ReceiptConfigRepositoryImpl(ref.watch(appDatabaseProvider)));

final StreamProvider<ReceiptConfigEntity?> receiptConfigStreamProvider =
    StreamProvider<ReceiptConfigEntity?>((ref) {
  return ref.watch(receiptConfigRepositoryProvider).watchConfig();
});

final FutureProvider<ReceiptConfigEntity?> receiptConfigFutureProvider =
    FutureProvider<ReceiptConfigEntity?>((ref) async {
  return ref.watch(receiptConfigRepositoryProvider).getConfig();
});
