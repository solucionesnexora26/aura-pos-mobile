import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/customers_table.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/sync/sync_queue_service.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../domain/entities/customer_entity.dart';

// ─── Mapper ───────────────────────────────────────────────────────────────────

extension CustomerMapper on CustomerRow {
  CustomerEntity toEntity() => CustomerEntity(
        id: id,
        fullName: fullName,
        documentId: documentId,
        phone: phone,
        email: email,
        address: address,
        type: CustomerTypeEntity.values[type.index],
        creditLimit: creditLimit,
        creditBalance: creditBalance,
        isActive: isActive,
        createdAt: createdAt,
      );
}

// ─── Repositorio ──────────────────────────────────────────────────────────────

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._db);
  final AppDatabase _db;

  SimpleSelectStatement<$CustomersTable, CustomerRow> _baseQuery({
    String? searchQuery,
    bool onlyActive = true,
  }) {
    final query = _db.select(_db.customers);
    query.where((tbl) {
      Expression<bool> cond = const Constant(true);
      if (onlyActive) cond = cond & tbl.isActive.equals(true);
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = '%${searchQuery.toLowerCase()}%';
        cond = cond &
            (tbl.fullName.lower().like(q) |
                tbl.documentId.lower().like(q) |
                tbl.phone.like(q));
      }
      return cond;
    });
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]);
    return query;
  }

  @override
  Future<Either<Failure, List<CustomerEntity>>> getCustomers({
    String? searchQuery,
    bool onlyActive = true,
  }) async {
    try {
      final rows = await _baseQuery(searchQuery: searchQuery, onlyActive: onlyActive).get();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> getCustomerById(String id) async {
    try {
      final row = await (_db.select(_db.customers)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();
      if (row == null) return const Left(NotFoundFailure('Cliente no encontrado.'));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> createCustomer(CustomerEntity c) async {
    try {
      if (c.documentId != null && c.documentId!.isNotEmpty) {
        final existing = await (_db.select(_db.customers)
              ..where((tbl) => tbl.documentId.equals(c.documentId!)))
            .get();
        if (existing.isNotEmpty) {
          return const Left(UnexpectedFailure('Ya existe un cliente con ese numero de documento.'));
        }
      }
      final id = const Uuid().v4();
      await _db.into(_db.customers).insert(
            CustomersCompanion.insert(
              id: Value(id),
              fullName: c.fullName.trim(),
              documentId: Value(c.documentId),
              phone: Value(c.phone),
              email: Value(c.email),
              address: Value(c.address),
              type: Value(CustomerType.values[c.type.index]),
              creditLimit: Value(c.creditLimit),
              creditBalance: Value(c.creditBalance),
              isActive: Value(true),
            ),
          );
      final row = await (_db.select(_db.customers)..where((tbl) => tbl.id.equals(id))).getSingle();
      await SyncQueueService(_db)
          .enqueueCustomer(SyncSerializers.customer(row));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> updateCustomer(CustomerEntity c) async {
    try {
      if (c.documentId != null && c.documentId!.isNotEmpty) {
        final existing = await (_db.select(_db.customers)
              ..where((tbl) => tbl.documentId.equals(c.documentId!) & tbl.id.equals(c.id).not()))
            .get();
        if (existing.isNotEmpty) {
          return const Left(UnexpectedFailure('Ya existe otro cliente con ese numero de documento.'));
        }
      }
      await (_db.update(_db.customers)..where((tbl) => tbl.id.equals(c.id))).write(
        CustomersCompanion(
          fullName: Value(c.fullName.trim()),
          documentId: Value(c.documentId),
          phone: Value(c.phone),
          email: Value(c.email),
          address: Value(c.address),
          type: Value(CustomerType.values[c.type.index]),
          creditLimit: Value(c.creditLimit),
          isActive: Value(c.isActive),
          updatedAt: Value(DateTime.now()),
        ),
      );
      final updated = await getCustomerById(c.id);
      if (updated.isRight()) {
        final row = await (_db.select(_db.customers)
              ..where((tbl) => tbl.id.equals(c.id)))
            .getSingle();
        await SyncQueueService(_db)
            .enqueueCustomer(SyncSerializers.customer(row));
      }
      return updated;
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCustomer(String id) async {
    try {
      final now = DateTime.now();
      await (_db.update(_db.customers)..where((tbl) => tbl.id.equals(id))).write(
        CustomersCompanion(
          isActive: const Value(false),
          deletedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      final row = await (_db.select(_db.customers)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingle();
      await SyncQueueService(_db)
          .enqueueCustomer(SyncSerializers.customer(row));
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<List<CustomerEntity>> watchCustomers({String? searchQuery}) {
    return _baseQuery(searchQuery: searchQuery)
        .watch()
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }
}
