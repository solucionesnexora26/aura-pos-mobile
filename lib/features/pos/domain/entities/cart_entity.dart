import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../customers/domain/entities/customer_entity.dart';
import '../../../products/domain/entities/product_entity.dart';

part 'cart_entity.freezed.dart';

@freezed
class CartItemEntity with _$CartItemEntity {
  const factory CartItemEntity({
    required String id,
    required ProductEntity product,
    ProductVariantEntity? variant,
    required double quantity,
    required double unitPrice,
    required double discount,
    required double taxRate,
    String? note,
  }) = _CartItemEntity;

  const CartItemEntity._();

  double get subtotal => unitPrice * quantity;
  double get discountAmount => subtotal * (discount / 100);
  double get taxableAmount => subtotal - discountAmount;
  double get taxAmount => taxableAmount * (taxRate / 100);
  double get lineTotal => taxableAmount + taxAmount;

  String get displayName =>
      variant != null ? '${product.name} — ${variant!.name}' : product.name;
}

@freezed
class CartState with _$CartState {
  const factory CartState({
    required String cartId,
    String? openSaleId,
    String? openSaleLabel,
    required List<CartItemEntity> items,
    CustomerEntity? customer,
    String? note,
    required double globalDiscount,
  }) = _CartState;

  const CartState._();

  double get subtotal => items.fold(0.0, (sum, i) => sum + i.subtotal);
  double get discountTotal =>
      items.fold(0.0, (sum, i) => sum + i.discountAmount) +
      subtotal * (globalDiscount / 100);
  double get taxTotal => items.fold(0.0, (sum, i) => sum + i.taxAmount);
  double get total => subtotal - discountTotal + taxTotal;
  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity.toInt());

  bool get isOpenSale => openSaleId != null;

  /// Cantidad total en el carrito de un producto SIN variante (para la UI
  /// de la grilla de productos). Un producto con variantes se resuelve por
  /// variante y no debe usar este acceso directo.
  double quantityForProduct(String productId) {
    var total = 0.0;
    for (final i in items) {
      if (i.variant == null && i.product.id == productId) total += i.quantity;
    }
    return total;
  }

  /// Primer ítem del carrito de un producto SIN variante (o null si no está).
  CartItemEntity? itemForProduct(String productId) {
    for (final i in items) {
      if (i.variant == null && i.product.id == productId) return i;
    }
    return null;
  }
}
