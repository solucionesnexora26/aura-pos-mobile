import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aura_pos/features/customers/domain/entities/customer_entity.dart';
import 'package:aura_pos/features/pos/data/repositories/sale_repository_impl.dart';
import 'package:aura_pos/features/pos/domain/entities/cart_entity.dart';
import 'package:aura_pos/features/pos/presentation/providers/cart_provider.dart';
import 'package:aura_pos/features/products/domain/entities/product_entity.dart';

ProductEntity _buildProduct({
  String id = 'prod-1',
  String name = 'Producto Test',
  double price = 10000,
  double taxRate = 19,
  bool trackStock = true,
  double stockQuantity = 5,
}) {
  final now = DateTime(2026, 1, 1);
  return ProductEntity(
    id: id,
    name: name,
    price: price,
    cost: 5000,
    taxRate: taxRate,
    unitType: ProductUnitTypeEntity.unit,
    trackStock: trackStock,
    stockQuantity: stockQuantity,
    lowStockThreshold: 2,
    hasVariants: false,
    isActive: true,
    isFavorite: false,
    variants: const [],
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('stockAfterSaleLine', () {
    test('descuenta las unidades vendidas', () {
      expect(stockAfterSaleLine(10, 3), 7);
    });

    test('reincorpora las devoluciones (cantidad negativa)', () {
      expect(stockAfterSaleLine(10, -2), 12);
    });

    test('no deja stock negativo', () {
      expect(stockAfterSaleLine(1, 5), 0);
    });
  });

  group('CartNotifier & CartState calculations', () {
    test('respeta tope de stock y calcula subtotal, descuento e impuestos', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(cartProvider.notifier);
      final prod = _buildProduct(price: 10000, taxRate: 10, stockQuantity: 3);

      expect(notifier.addProduct(prod, quantity: 2), isTrue);
      expect(container.read(cartProvider).subtotal, 20000);
      expect(container.read(cartProvider).taxTotal, 2000);
      expect(container.read(cartProvider).total, 22000);

      // Intentar agregar 5 unidades adicionales se limita al stock disponible (3)
      expect(notifier.addProduct(prod, quantity: 5), isTrue);
      expect(container.read(cartProvider).items.single.quantity, 3);

      // En el tope de stock, addProduct devuelve false
      expect(notifier.addProduct(prod, quantity: 1), isFalse);
    });

    test('loadOpenSale preserva devoluciones (isReturn, motivo, ticket) y cliente', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(cartProvider.notifier);
      final prod = _buildProduct(price: 5000, taxRate: 0, stockQuantity: 10);
      final now = DateTime(2026, 1, 1);
      final customer = CustomerEntity(
        id: 'cust-1',
        fullName: 'Cliente Prueba',
        type: CustomerTypeEntity.frequent,
        creditLimit: 100000,
        creditBalance: 0,
        isActive: true,
        createdAt: now,
      );

      final items = [
        CartItemEntity(
          id: 'line-1',
          product: prod,
          quantity: 2,
          unitPrice: 5000,
          discount: 10,
          taxRate: 0,
        ),
        CartItemEntity(
          id: 'line-2',
          product: prod,
          quantity: -1,
          unitPrice: 5000,
          discount: 0,
          taxRate: 0,
          isReturn: true,
          returnReason: 'deterioro',
          returnedFromTicket: 'TPV-2611-0001',
        ),
      ];

      notifier.loadOpenSale(
        saleId: 'sale-open-1',
        label: 'Mesa 4',
        items: items,
        customer: customer,
        note: 'Nota abierta',
      );

      final state = container.read(cartProvider);
      expect(state.openSaleId, 'sale-open-1');
      expect(state.openSaleLabel, 'Mesa 4');
      expect(state.customer?.id, 'cust-1');
      expect(state.hasReturns, isTrue);
      expect(state.returnItems.single.returnReason, 'deterioro');
      expect(state.returnItems.single.returnedFromTicket, 'TPV-2611-0001');
      // Venta: 2 * 5000 - 10% = 9000; Devolución: -1 * 5000 = -5000; Total neto = 4000
      expect(state.total, 4000);
    });
  });
}
