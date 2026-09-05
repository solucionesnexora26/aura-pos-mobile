import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/system_tables.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/error/failures.dart';

// ─── Entidad ──────────────────────────────────────────────────────────────────

class PrinterConfigEntity {
  const PrinterConfigEntity({
    required this.id,
    required this.name,
    required this.connectionType,
    required this.address,
    this.port,
    required this.paperWidth,
    required this.autoCut,
    this.logoPath,
    this.headerText,
    this.footerText,
    required this.isFavorite,
  });

  final String id;
  final String name;
  final PrinterConnectionType connectionType;
  final String address;
  final int? port;
  final PrinterPaperWidth paperWidth;
  final bool autoCut;
  final String? logoPath;
  final String? headerText;
  final String? footerText;
  final bool isFavorite;

  String get connectionLabel => switch (connectionType) {
        PrinterConnectionType.bluetooth => 'Bluetooth',
        PrinterConnectionType.usb => 'USB',
        PrinterConnectionType.network => 'Red WiFi',
      };

  String get paperLabel => switch (paperWidth) {
        PrinterPaperWidth.mm58 => '58 mm',
        PrinterPaperWidth.mm80 => '80 mm',
      };
}

// ─── Repositorio ──────────────────────────────────────────────────────────────

class PrinterRepositoryImpl {
  const PrinterRepositoryImpl(this._db);
  final AppDatabase _db;

  PrinterConfigEntity _toEntity(PrinterConfigRow r) => PrinterConfigEntity(
        id: r.id,
        name: r.name,
        connectionType: r.connectionType,
        address: r.address,
        port: r.port,
        paperWidth: r.paperWidth,
        autoCut: r.autoCut,
        logoPath: r.logoPath,
        headerText: r.headerText,
        footerText: r.footerText,
        isFavorite: r.isFavorite,
      );

  Future<Either<Failure, List<PrinterConfigEntity>>> getPrinters() async {
    try {
      final rows = await (_db.select(_db.printerConfigs)
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.isFavorite), (tbl) => OrderingTerm.asc(tbl.name)]))
          .get();
      return Right(rows.map(_toEntity).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, PrinterConfigEntity>> savePrinter(PrinterConfigEntity printer) async {
    try {
      final isNew = printer.id.isEmpty;
      final id = isNew ? const Uuid().v4() : printer.id;
      final companion = PrinterConfigsCompanion(
        id: Value(id),
        name: Value(printer.name),
        connectionType: Value(printer.connectionType),
        address: Value(printer.address),
        port: Value(printer.port),
        paperWidth: Value(printer.paperWidth),
        autoCut: Value(printer.autoCut),
        logoPath: Value(printer.logoPath),
        headerText: Value(printer.headerText),
        footerText: Value(printer.footerText),
        isFavorite: Value(printer.isFavorite),
      );
      if (isNew) {
        await _db.into(_db.printerConfigs).insert(companion);
      } else {
        await (_db.update(_db.printerConfigs)..where((tbl) => tbl.id.equals(id))).write(companion);
      }
      final row = await (_db.select(_db.printerConfigs)..where((tbl) => tbl.id.equals(id))).getSingle();
      return Right(_toEntity(row));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> deletePrinter(String id) async {
    try {
      await (_db.delete(_db.printerConfigs)..where((tbl) => tbl.id.equals(id))).go();
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> setFavorite(String id) async {
    try {
      // Quita favorito de todos
      await (_db.update(_db.printerConfigs)).write(const PrinterConfigsCompanion(isFavorite: Value(false)));
      // Pone favorito en el seleccionado
      await (_db.update(_db.printerConfigs)..where((tbl) => tbl.id.equals(id)))
          .write(const PrinterConfigsCompanion(isFavorite: Value(true)));
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Stream<List<PrinterConfigEntity>> watchPrinters() {
    return (_db.select(_db.printerConfigs)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.isFavorite)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final Provider<PrinterRepositoryImpl> printerRepositoryProvider =
    Provider<PrinterRepositoryImpl>(
        (ref) => PrinterRepositoryImpl(ref.watch(appDatabaseProvider)));

final StreamProvider<List<PrinterConfigEntity>> printersStreamProvider =
    StreamProvider<List<PrinterConfigEntity>>((ref) {
  return ref.watch(printerRepositoryProvider).watchPrinters();
});
