import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../customers/domain/entities/customer_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/cart_entity.dart';

/// Administra el estado del carrito activo. Es el corazón del flujo POS:
/// agrega, edita y elimina ítems, asigna cliente, aplica descuentos, etc.
class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => _emptyCart();

  CartState _emptyCart() => CartState(
        cartId: const Uuid().v4(),
        items: const [],
        globalDiscount: 0,
      );

  // ── Productos ─────────────────────────────────────────────────────────────

  /// Stock disponible para un producto/variante. Productos sin control de
  /// inventario no tienen tope.
  static double _availableStock(ProductEntity product, ProductVariantEntity? variant) {
    if (!product.trackStock) return double.infinity;
    if (variant != null) return variant.stockQuantity;
    return product.stockQuantity;
  }

  /// Agrega [quantity] unidades del producto. Respeta el tope de stock: si la
  /// cantidad resultante excede el stock disponible, se limita a ese máximo.
  /// Retorna `false` si el carrito ya está en el tope (no hubo cambio).
  bool addProduct(ProductEntity product, {ProductVariantEntity? variant, double quantity = 1}) {
    final effectivePrice = product.priceForVariant(variant);
    final available = _availableStock(product, variant);
    final existingIndex = state.items.indexWhere(
      (i) => i.product.id == product.id && i.variant?.id == variant?.id,
    );

    if (existingIndex >= 0) {
      final current = state.items[existingIndex].quantity;
      final target = (current + quantity).clamp(0.0, available);
      if (target <= current) return false;
      final updated = state.items[existingIndex].copyWith(quantity: target);
      final newItems = List<CartItemEntity>.from(state.items);
      newItems[existingIndex] = updated;
      state = state.copyWith(items: newItems);
      return true;
    } else {
      final target = quantity.clamp(0.0, available);
      if (target <= 0) return false;
      final item = CartItemEntity(
        id: const Uuid().v4(),
        product: product,
        variant: variant,
        quantity: target,
        unitPrice: effectivePrice,
        discount: 0,
        taxRate: product.taxRate,
      );
      state = state.copyWith(items: [...state.items, item]);
      return true;
    }
  }

  void updateQuantity(String itemId, double quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    CartItemEntity? item;
    for (final i in state.items) {
      if (i.id == itemId) {
        item = i;
        break;
      }
    }
    if (item == null) return;
    final target = quantity.clamp(0.0, _availableStock(item.product, item.variant));
    if (target <= 0) {
      removeItem(itemId);
      return;
    }
    state = state.copyWith(
      items: state.items
          .map((i) => i.id == itemId ? i.copyWith(quantity: target) : i)
          .toList(),
    );
  }

  void updateDiscount(String itemId, double discount) {
    state = state.copyWith(
      items: state.items
          .map((i) => i.id == itemId
              ? i.copyWith(discount: discount.clamp(0, 100))
              : i)
          .toList(),
    );
  }

  void updateNote(String itemId, String? note) {
    state = state.copyWith(
      items: state.items
          .map((i) => i.id == itemId ? i.copyWith(note: note) : i)
          .toList(),
    );
  }

  void updatePrice(String itemId, double price) {
    state = state.copyWith(
      items: state.items
          .map((i) => i.id == itemId ? i.copyWith(unitPrice: price) : i)
          .toList(),
    );
  }

  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != itemId).toList(),
    );
  }

  // ── Cliente ───────────────────────────────────────────────────────────────

  void setCustomer(CustomerEntity? customer) {
    state = state.copyWith(customer: customer);
  }

  // ── Nota y descuento global ───────────────────────────────────────────────

  void setNote(String? note) => state = state.copyWith(note: note);

  void setGlobalDiscount(double discount) {
    state = state.copyWith(globalDiscount: discount.clamp(0, 100));
  }

  // ── Venta abierta ─────────────────────────────────────────────────────────

  /// Carga una venta abierta al carrito activo para continuar trabajando en ella.
  void loadOpenSale({
    required String saleId,
    required String? label,
    required List<CartItemEntity> items,
    CustomerEntity? customer,
    String? note,
    double globalDiscount = 0,
  }) {
    state = CartState(
      cartId: const Uuid().v4(),
      openSaleId: saleId,
      openSaleLabel: label,
      items: items,
      customer: customer,
      note: note,
      globalDiscount: globalDiscount,
    );
  }

  /// Marca que el carrito ya fue vinculado a una venta abierta existente
  /// (después de guardar en DB por primera vez).
  void attachToSale(String saleId, {String? label}) {
    state = state.copyWith(openSaleId: saleId, openSaleLabel: label);
  }

  // ── Limpiar ───────────────────────────────────────────────────────────────

  void clear() => state = _emptyCart();
}

final NotifierProvider<CartNotifier, CartState> cartProvider =
    NotifierProvider<CartNotifier, CartState>(CartNotifier.new);
