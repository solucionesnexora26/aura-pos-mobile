// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CartItemEntity {
  String get id => throw _privateConstructorUsedError;
  ProductEntity get product => throw _privateConstructorUsedError;
  ProductVariantEntity? get variant => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get taxRate => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CartItemEntityCopyWith<CartItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemEntityCopyWith<$Res> {
  factory $CartItemEntityCopyWith(
          CartItemEntity value, $Res Function(CartItemEntity) then) =
      _$CartItemEntityCopyWithImpl<$Res, CartItemEntity>;
  @useResult
  $Res call(
      {String id,
      ProductEntity product,
      ProductVariantEntity? variant,
      double quantity,
      double unitPrice,
      double discount,
      double taxRate,
      String? note});

  $ProductEntityCopyWith<$Res> get product;
  $ProductVariantEntityCopyWith<$Res>? get variant;
}

/// @nodoc
class _$CartItemEntityCopyWithImpl<$Res, $Val extends CartItemEntity>
    implements $CartItemEntityCopyWith<$Res> {
  _$CartItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
    Object? variant = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? discount = null,
    Object? taxRate = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductEntity,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as ProductVariantEntity?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductEntityCopyWith<$Res> get product {
    return $ProductEntityCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductVariantEntityCopyWith<$Res>? get variant {
    if (_value.variant == null) {
      return null;
    }

    return $ProductVariantEntityCopyWith<$Res>(_value.variant!, (value) {
      return _then(_value.copyWith(variant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartItemEntityImplCopyWith<$Res>
    implements $CartItemEntityCopyWith<$Res> {
  factory _$$CartItemEntityImplCopyWith(_$CartItemEntityImpl value,
          $Res Function(_$CartItemEntityImpl) then) =
      __$$CartItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ProductEntity product,
      ProductVariantEntity? variant,
      double quantity,
      double unitPrice,
      double discount,
      double taxRate,
      String? note});

  @override
  $ProductEntityCopyWith<$Res> get product;
  @override
  $ProductVariantEntityCopyWith<$Res>? get variant;
}

/// @nodoc
class __$$CartItemEntityImplCopyWithImpl<$Res>
    extends _$CartItemEntityCopyWithImpl<$Res, _$CartItemEntityImpl>
    implements _$$CartItemEntityImplCopyWith<$Res> {
  __$$CartItemEntityImplCopyWithImpl(
      _$CartItemEntityImpl _value, $Res Function(_$CartItemEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
    Object? variant = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? discount = null,
    Object? taxRate = null,
    Object? note = freezed,
  }) {
    return _then(_$CartItemEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductEntity,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as ProductVariantEntity?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CartItemEntityImpl extends _CartItemEntity {
  const _$CartItemEntityImpl(
      {required this.id,
      required this.product,
      this.variant,
      required this.quantity,
      required this.unitPrice,
      required this.discount,
      required this.taxRate,
      this.note})
      : super._();

  @override
  final String id;
  @override
  final ProductEntity product;
  @override
  final ProductVariantEntity? variant;
  @override
  final double quantity;
  @override
  final double unitPrice;
  @override
  final double discount;
  @override
  final double taxRate;
  @override
  final String? note;

  @override
  String toString() {
    return 'CartItemEntity(id: $id, product: $product, variant: $variant, quantity: $quantity, unitPrice: $unitPrice, discount: $discount, taxRate: $taxRate, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, product, variant, quantity,
      unitPrice, discount, taxRate, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemEntityImplCopyWith<_$CartItemEntityImpl> get copyWith =>
      __$$CartItemEntityImplCopyWithImpl<_$CartItemEntityImpl>(
          this, _$identity);
}

abstract class _CartItemEntity extends CartItemEntity {
  const factory _CartItemEntity(
      {required final String id,
      required final ProductEntity product,
      final ProductVariantEntity? variant,
      required final double quantity,
      required final double unitPrice,
      required final double discount,
      required final double taxRate,
      final String? note}) = _$CartItemEntityImpl;
  const _CartItemEntity._() : super._();

  @override
  String get id;
  @override
  ProductEntity get product;
  @override
  ProductVariantEntity? get variant;
  @override
  double get quantity;
  @override
  double get unitPrice;
  @override
  double get discount;
  @override
  double get taxRate;
  @override
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$CartItemEntityImplCopyWith<_$CartItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CartState {
  String get cartId => throw _privateConstructorUsedError;
  String? get openSaleId => throw _privateConstructorUsedError;
  String? get openSaleLabel => throw _privateConstructorUsedError;
  List<CartItemEntity> get items => throw _privateConstructorUsedError;
  CustomerEntity? get customer => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  double get globalDiscount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CartStateCopyWith<CartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartStateCopyWith<$Res> {
  factory $CartStateCopyWith(CartState value, $Res Function(CartState) then) =
      _$CartStateCopyWithImpl<$Res, CartState>;
  @useResult
  $Res call(
      {String cartId,
      String? openSaleId,
      String? openSaleLabel,
      List<CartItemEntity> items,
      CustomerEntity? customer,
      String? note,
      double globalDiscount});

  $CustomerEntityCopyWith<$Res>? get customer;
}

/// @nodoc
class _$CartStateCopyWithImpl<$Res, $Val extends CartState>
    implements $CartStateCopyWith<$Res> {
  _$CartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartId = null,
    Object? openSaleId = freezed,
    Object? openSaleLabel = freezed,
    Object? items = null,
    Object? customer = freezed,
    Object? note = freezed,
    Object? globalDiscount = null,
  }) {
    return _then(_value.copyWith(
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      openSaleId: freezed == openSaleId
          ? _value.openSaleId
          : openSaleId // ignore: cast_nullable_to_non_nullable
              as String?,
      openSaleLabel: freezed == openSaleLabel
          ? _value.openSaleLabel
          : openSaleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItemEntity>,
      customer: freezed == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerEntity?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      globalDiscount: null == globalDiscount
          ? _value.globalDiscount
          : globalDiscount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CustomerEntityCopyWith<$Res>? get customer {
    if (_value.customer == null) {
      return null;
    }

    return $CustomerEntityCopyWith<$Res>(_value.customer!, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartStateImplCopyWith<$Res>
    implements $CartStateCopyWith<$Res> {
  factory _$$CartStateImplCopyWith(
          _$CartStateImpl value, $Res Function(_$CartStateImpl) then) =
      __$$CartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cartId,
      String? openSaleId,
      String? openSaleLabel,
      List<CartItemEntity> items,
      CustomerEntity? customer,
      String? note,
      double globalDiscount});

  @override
  $CustomerEntityCopyWith<$Res>? get customer;
}

/// @nodoc
class __$$CartStateImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$CartStateImpl>
    implements _$$CartStateImplCopyWith<$Res> {
  __$$CartStateImplCopyWithImpl(
      _$CartStateImpl _value, $Res Function(_$CartStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartId = null,
    Object? openSaleId = freezed,
    Object? openSaleLabel = freezed,
    Object? items = null,
    Object? customer = freezed,
    Object? note = freezed,
    Object? globalDiscount = null,
  }) {
    return _then(_$CartStateImpl(
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      openSaleId: freezed == openSaleId
          ? _value.openSaleId
          : openSaleId // ignore: cast_nullable_to_non_nullable
              as String?,
      openSaleLabel: freezed == openSaleLabel
          ? _value.openSaleLabel
          : openSaleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItemEntity>,
      customer: freezed == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerEntity?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      globalDiscount: null == globalDiscount
          ? _value.globalDiscount
          : globalDiscount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$CartStateImpl extends _CartState {
  const _$CartStateImpl(
      {required this.cartId,
      this.openSaleId,
      this.openSaleLabel,
      required final List<CartItemEntity> items,
      this.customer,
      this.note,
      required this.globalDiscount})
      : _items = items,
        super._();

  @override
  final String cartId;
  @override
  final String? openSaleId;
  @override
  final String? openSaleLabel;
  final List<CartItemEntity> _items;
  @override
  List<CartItemEntity> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final CustomerEntity? customer;
  @override
  final String? note;
  @override
  final double globalDiscount;

  @override
  String toString() {
    return 'CartState(cartId: $cartId, openSaleId: $openSaleId, openSaleLabel: $openSaleLabel, items: $items, customer: $customer, note: $note, globalDiscount: $globalDiscount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartStateImpl &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.openSaleId, openSaleId) ||
                other.openSaleId == openSaleId) &&
            (identical(other.openSaleLabel, openSaleLabel) ||
                other.openSaleLabel == openSaleLabel) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.globalDiscount, globalDiscount) ||
                other.globalDiscount == globalDiscount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      cartId,
      openSaleId,
      openSaleLabel,
      const DeepCollectionEquality().hash(_items),
      customer,
      note,
      globalDiscount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartStateImplCopyWith<_$CartStateImpl> get copyWith =>
      __$$CartStateImplCopyWithImpl<_$CartStateImpl>(this, _$identity);
}

abstract class _CartState extends CartState {
  const factory _CartState(
      {required final String cartId,
      final String? openSaleId,
      final String? openSaleLabel,
      required final List<CartItemEntity> items,
      final CustomerEntity? customer,
      final String? note,
      required final double globalDiscount}) = _$CartStateImpl;
  const _CartState._() : super._();

  @override
  String get cartId;
  @override
  String? get openSaleId;
  @override
  String? get openSaleLabel;
  @override
  List<CartItemEntity> get items;
  @override
  CustomerEntity? get customer;
  @override
  String? get note;
  @override
  double get globalDiscount;
  @override
  @JsonKey(ignore: true)
  _$$CartStateImplCopyWith<_$CartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
