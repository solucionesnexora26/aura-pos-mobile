import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aura_pos/features/pos/presentation/providers/cart_provider.dart';
import 'package:aura_pos/features/products/domain/entities/product_entity.dart';

void main() {
  final product = ProductEntity(
    id: 'p1',
    name: 'Producto de prueba',
    price: 100,
    cost: 50,
    taxRate: 0,
    unitType: ProductUnitTypeEntity.unit,
    trackStock: true,
    stockQuantity: 100,
    lowStockThreshold: 0,
    hasVariants: false,
    isFavorite: false,
    isActive: true,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  ProviderContainer container() => ProviderContainer(
        overrides: [cartProvider.overrideWith(CartNotifier.new)],
      );

  test('agregar devolución crea línea negativa y resta del total', () {
    final c = container();
    final notifier = c.read(cartProvider.notifier);

    notifier.addProduct(product, quantity: 3);
    notifier.addReturnProduct(product, quantity: 1, reason: 'deterioro');

    final cart = c.read(cartProvider);
    expect(cart.items.length, 2);
    expect(cart.hasReturns, isTrue);
    expect(cart.salesTotal, 300);
    expect(cart.returnsTotal, -100);
    expect(cart.total, 200);
    expect(cart.items[1].isReturn, isTrue);
    expect(cart.items[1].quantity, -1);
    expect(cart.items[1].returnReason, 'deterioro');
    expect(cart.itemCount, 4);
  });

  test('venta y devolución del mismo producto conviven en líneas separadas',
      () {
    final c = container();
    final notifier = c.read(cartProvider.notifier);

    notifier.addProduct(product, quantity: 2);
    notifier.addReturnProduct(product, quantity: 1, reason: 'otro');
    notifier.addProduct(product, quantity: 1);

    final cart = c.read(cartProvider);
    expect(cart.items.length, 2);
    expect(cart.saleItems.single.quantity, 3);
    expect(cart.returnItems.single.quantity, -1);
    expect(cart.total, 200);
  });

  test('las devoluciones del mismo producto se acumulan en una sola línea', () {
    final c = container();
    final notifier = c.read(cartProvider.notifier);

    notifier.addReturnProduct(product, quantity: 2, reason: 'vencimiento');
    notifier.addReturnProduct(product, quantity: 2, reason: 'vencimiento');

    final cart = c.read(cartProvider);
    expect(cart.items.length, 1);
    expect(cart.returnItems.single.quantity, -4);
    expect(cart.total, -400);
  });

  test('total negativo: la venta queda a favor del cliente', () {
    final c = container();
    final notifier = c.read(cartProvider.notifier);

    notifier.addReturnProduct(product, quantity: 3, reason: 'no_aceptacion');

    final cart = c.read(cartProvider);
    expect(cart.salesTotal, 0);
    expect(cart.returnsTotal.abs(), 300);
    expect(cart.total, -300);
    expect(cart.itemCount, 3);
  });

  test('no respeta tope de stock al registrar devoluciones', () {
    final c = container();
    final notifier = c.read(cartProvider.notifier);

    notifier.addReturnProduct(product, quantity: 200, reason: 'otro');

    expect(c.read(cartProvider).returnItems.single.quantity, -200);
  });

  test('updateQuantity en devolución no clampa por stock y elimina en cero', () {
    final c = container();
    final notifier = c.read(cartProvider.notifier);

    notifier.addReturnProduct(product, quantity: 3, reason: 'otro');
    final returnId = c.read(cartProvider).returnItems.single.id;

    notifier.updateQuantity(returnId, -5);
    expect(c.read(cartProvider).returnItems.single.quantity, -5);

    notifier.updateQuantity(returnId, 0);
    expect(c.read(cartProvider).isEmpty, isTrue);
  });
}