import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:aura_pos/core/database/tables/sales_tables.dart';
import 'package:aura_pos/core/error/failures.dart';
import 'package:aura_pos/core/widgets/main_shell.dart';
import 'package:aura_pos/features/auth/presentation/providers/auth_providers.dart';
import 'package:aura_pos/features/pos/data/repositories/sale_repository_impl.dart';
import 'package:aura_pos/features/pos/domain/entities/cart_entity.dart';
import 'package:aura_pos/features/pos/presentation/providers/pos_providers.dart';
import 'package:aura_pos/features/pos/presentation/widgets/cart_panel.dart';
import 'package:aura_pos/features/products/domain/entities/product_entity.dart';

/// Regresión: los diálogos dentro de un ShellRoute de go_router se montan en
/// el root navigator (useRootNavigator: true), pero `Navigator.pop` con el
/// contexto EXTERNO popea la ruta del shell (la pantalla) en lugar del
/// diálogo. Los botones del diálogo deben usar el contexto del propio diálogo.
void main() {
  testWidgets('Guardar venta abierta cierra el diálogo, conserva la pantalla y limpia el carrito',
      (WidgetTester tester) async {
    final repo = _FakeSaleRepository();

    await tester.pumpWidget(_buildApp(repo, openSaleId: null));
    await tester.pumpAndSettle();

    expect(find.text('Producto de prueba'), findsOneWidget);

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Mesa 5');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Producto de prueba'), findsNothing);
    expect(find.text('Tu venta está vacía'), findsOneWidget);
    expect(repo.createCalls, 1);
    expect(repo.updateCalls, 0);
    expect(find.text('Venta guardada.'), findsOneWidget);
  });

  testWidgets('Actualizar venta abierta cierra el diálogo, conserva la pantalla y limpia el carrito',
      (WidgetTester tester) async {
    final repo = _FakeSaleRepository();

    await tester.pumpWidget(_buildApp(repo, openSaleId: 'sale-1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Producto de prueba'), findsNothing);
    expect(find.text('Tu venta está vacía'), findsOneWidget);
    expect(repo.updateCalls, 1);
    expect(repo.createCalls, 0);
    expect(find.text('Venta guardada.'), findsOneWidget);
  });
}

Widget _buildApp(_FakeSaleRepository repo, {String? openSaleId}) {
  final router = GoRouter(
    initialLocation: '/pos',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/pos',
            builder: (context, state) => const _CartProbePage(),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      saleRepositoryProvider.overrideWithValue(repo),
      authSessionProvider.overrideWith(_FakeSessionNotifier.new),
      cartProvider.overrideWith(() => _SeededCartNotifier(openSaleId)),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

class _CartProbePage extends ConsumerWidget {
  const _CartProbePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: SafeArea(child: CartPanel()));
  }
}

class _FakeSessionNotifier extends AuthSessionNotifier {
  @override
  AuthSessionState build() => const AuthSessionState(isAuthenticated: true);
}

class _SeededCartNotifier extends CartNotifier {
  _SeededCartNotifier(this.openSaleId);
  final String? openSaleId;

  @override
  CartState build() => CartState(
        cartId: 'cart-1',
        openSaleId: openSaleId,
        openSaleLabel: openSaleId != null ? 'Mesa 1' : null,
        items: [
          CartItemEntity(
            id: 'item-1',
            product: _product,
            quantity: 1,
            unitPrice: 100,
            discount: 0,
            taxRate: 0,
          ),
        ],
        globalDiscount: 0,
      );
}

final _product = ProductEntity(
  id: 'p1',
  name: 'Producto de prueba',
  price: 100,
  cost: 50,
  taxRate: 0,
  unitType: ProductUnitTypeEntity.unit,
  trackStock: false,
  stockQuantity: 0,
  lowStockThreshold: 0,
  hasVariants: false,
  isFavorite: false,
  isActive: true,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

class _FakeSaleRepository implements SaleRepository {
  int createCalls = 0;
  int updateCalls = 0;

  SaleEntity _sale(String id, CartState cart) => SaleEntity(
        id: id,
        ticketNumber: '000001',
        userId: '',
        status: SaleStatus.open,
        subtotal: cart.subtotal,
        discountTotal: cart.discountTotal,
        taxTotal: cart.taxTotal,
        total: cart.total,
        changeGiven: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        items: const [],
        payments: const [],
      );

  @override
  Future<Either<Failure, SaleEntity>> createOpenSale(
      CartState cart, String userId, String? cashRegisterId,) async {
    createCalls++;
    return Right(_sale('new-sale', cart));
  }

  @override
  Future<Either<Failure, SaleEntity>> updateOpenSale(
      String saleId, CartState cart,) async {
    updateCalls++;
    return Right(_sale(saleId, cart));
  }

  @override
  Future<Either<Failure, SaleEntity>> completeSale({
    required String saleId,
    required CartState cart,
    required List<({PaymentMethod method, double amount, String? reference})> payments,
    required double changeGiven,
    required String userId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, SaleEntity>> getSaleById(String id) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<SaleEntity>>> getOpenSales() async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<SaleEntity>>> getSalesByDate({
    required DateTime from,
    required DateTime to,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<SaleEntity>>> getReceiptsByDate({
    required DateTime from,
    required DateTime to,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> cancelSale(String saleId) async =>
      throw UnimplementedError();

  @override
  Stream<List<SaleEntity>> watchOpenSales() => const Stream.empty();

  @override
  Future<Either<Failure, String>> generateTicketNumber() async =>
      throw UnimplementedError();

  @override
  Future<int> migrateLegacyDevUserSales(String validUserId) async => 0;
}
