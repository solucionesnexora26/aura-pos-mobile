// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategoryEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  String? get iconName => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CategoryEntityCopyWith<CategoryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryEntityCopyWith<$Res> {
  factory $CategoryEntityCopyWith(
          CategoryEntity value, $Res Function(CategoryEntity) then) =
      _$CategoryEntityCopyWithImpl<$Res, CategoryEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String colorHex,
      String? iconName,
      int sortOrder,
      bool isActive});
}

/// @nodoc
class _$CategoryEntityCopyWithImpl<$Res, $Val extends CategoryEntity>
    implements $CategoryEntityCopyWith<$Res> {
  _$CategoryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? colorHex = null,
    Object? iconName = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryEntityImplCopyWith<$Res>
    implements $CategoryEntityCopyWith<$Res> {
  factory _$$CategoryEntityImplCopyWith(_$CategoryEntityImpl value,
          $Res Function(_$CategoryEntityImpl) then) =
      __$$CategoryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String colorHex,
      String? iconName,
      int sortOrder,
      bool isActive});
}

/// @nodoc
class __$$CategoryEntityImplCopyWithImpl<$Res>
    extends _$CategoryEntityCopyWithImpl<$Res, _$CategoryEntityImpl>
    implements _$$CategoryEntityImplCopyWith<$Res> {
  __$$CategoryEntityImplCopyWithImpl(
      _$CategoryEntityImpl _value, $Res Function(_$CategoryEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? colorHex = null,
    Object? iconName = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$CategoryEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CategoryEntityImpl implements _CategoryEntity {
  const _$CategoryEntityImpl(
      {required this.id,
      required this.name,
      required this.colorHex,
      this.iconName,
      required this.sortOrder,
      required this.isActive});

  @override
  final String id;
  @override
  final String name;
  @override
  final String colorHex;
  @override
  final String? iconName;
  @override
  final int sortOrder;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name, colorHex: $colorHex, iconName: $iconName, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, colorHex, iconName, sortOrder, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryEntityImplCopyWith<_$CategoryEntityImpl> get copyWith =>
      __$$CategoryEntityImplCopyWithImpl<_$CategoryEntityImpl>(
          this, _$identity);
}

abstract class _CategoryEntity implements CategoryEntity {
  const factory _CategoryEntity(
      {required final String id,
      required final String name,
      required final String colorHex,
      final String? iconName,
      required final int sortOrder,
      required final bool isActive}) = _$CategoryEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get colorHex;
  @override
  String? get iconName;
  @override
  int get sortOrder;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CategoryEntityImplCopyWith<_$CategoryEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BrandEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BrandEntityCopyWith<BrandEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandEntityCopyWith<$Res> {
  factory $BrandEntityCopyWith(
          BrandEntity value, $Res Function(BrandEntity) then) =
      _$BrandEntityCopyWithImpl<$Res, BrandEntity>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$BrandEntityCopyWithImpl<$Res, $Val extends BrandEntity>
    implements $BrandEntityCopyWith<$Res> {
  _$BrandEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrandEntityImplCopyWith<$Res>
    implements $BrandEntityCopyWith<$Res> {
  factory _$$BrandEntityImplCopyWith(
          _$BrandEntityImpl value, $Res Function(_$BrandEntityImpl) then) =
      __$$BrandEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$BrandEntityImplCopyWithImpl<$Res>
    extends _$BrandEntityCopyWithImpl<$Res, _$BrandEntityImpl>
    implements _$$BrandEntityImplCopyWith<$Res> {
  __$$BrandEntityImplCopyWithImpl(
      _$BrandEntityImpl _value, $Res Function(_$BrandEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$BrandEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BrandEntityImpl implements _BrandEntity {
  const _$BrandEntityImpl({required this.id, required this.name});

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'BrandEntity(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrandEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BrandEntityImplCopyWith<_$BrandEntityImpl> get copyWith =>
      __$$BrandEntityImplCopyWithImpl<_$BrandEntityImpl>(this, _$identity);
}

abstract class _BrandEntity implements BrandEntity {
  const factory _BrandEntity(
      {required final String id,
      required final String name}) = _$BrandEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$BrandEntityImplCopyWith<_$BrandEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SupplierEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get contactName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SupplierEntityCopyWith<SupplierEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierEntityCopyWith<$Res> {
  factory $SupplierEntityCopyWith(
          SupplierEntity value, $Res Function(SupplierEntity) then) =
      _$SupplierEntityCopyWithImpl<$Res, SupplierEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? contactName,
      String? phone,
      String? email,
      String? address,
      bool isActive});
}

/// @nodoc
class _$SupplierEntityCopyWithImpl<$Res, $Val extends SupplierEntity>
    implements $SupplierEntityCopyWith<$Res> {
  _$SupplierEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? contactName = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contactName: freezed == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupplierEntityImplCopyWith<$Res>
    implements $SupplierEntityCopyWith<$Res> {
  factory _$$SupplierEntityImplCopyWith(_$SupplierEntityImpl value,
          $Res Function(_$SupplierEntityImpl) then) =
      __$$SupplierEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? contactName,
      String? phone,
      String? email,
      String? address,
      bool isActive});
}

/// @nodoc
class __$$SupplierEntityImplCopyWithImpl<$Res>
    extends _$SupplierEntityCopyWithImpl<$Res, _$SupplierEntityImpl>
    implements _$$SupplierEntityImplCopyWith<$Res> {
  __$$SupplierEntityImplCopyWithImpl(
      _$SupplierEntityImpl _value, $Res Function(_$SupplierEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? contactName = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? isActive = null,
  }) {
    return _then(_$SupplierEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contactName: freezed == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SupplierEntityImpl implements _SupplierEntity {
  const _$SupplierEntityImpl(
      {required this.id,
      required this.name,
      this.contactName,
      this.phone,
      this.email,
      this.address,
      required this.isActive});

  @override
  final String id;
  @override
  final String name;
  @override
  final String? contactName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'SupplierEntity(id: $id, name: $name, contactName: $contactName, phone: $phone, email: $email, address: $address, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplierEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, contactName, phone, email, address, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplierEntityImplCopyWith<_$SupplierEntityImpl> get copyWith =>
      __$$SupplierEntityImplCopyWithImpl<_$SupplierEntityImpl>(
          this, _$identity);
}

abstract class _SupplierEntity implements SupplierEntity {
  const factory _SupplierEntity(
      {required final String id,
      required final String name,
      final String? contactName,
      final String? phone,
      final String? email,
      final String? address,
      required final bool isActive}) = _$SupplierEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get contactName;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$SupplierEntityImplCopyWith<_$SupplierEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProductVariantEntity {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  double get priceDelta => throw _privateConstructorUsedError;
  double get stockQuantity => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProductVariantEntityCopyWith<ProductVariantEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductVariantEntityCopyWith<$Res> {
  factory $ProductVariantEntityCopyWith(ProductVariantEntity value,
          $Res Function(ProductVariantEntity) then) =
      _$ProductVariantEntityCopyWithImpl<$Res, ProductVariantEntity>;
  @useResult
  $Res call(
      {String id,
      String productId,
      String name,
      String? sku,
      String? barcode,
      double priceDelta,
      double stockQuantity,
      bool isActive});
}

/// @nodoc
class _$ProductVariantEntityCopyWithImpl<$Res,
        $Val extends ProductVariantEntity>
    implements $ProductVariantEntityCopyWith<$Res> {
  _$ProductVariantEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? name = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? priceDelta = null,
    Object? stockQuantity = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      priceDelta: null == priceDelta
          ? _value.priceDelta
          : priceDelta // ignore: cast_nullable_to_non_nullable
              as double,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductVariantEntityImplCopyWith<$Res>
    implements $ProductVariantEntityCopyWith<$Res> {
  factory _$$ProductVariantEntityImplCopyWith(_$ProductVariantEntityImpl value,
          $Res Function(_$ProductVariantEntityImpl) then) =
      __$$ProductVariantEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String name,
      String? sku,
      String? barcode,
      double priceDelta,
      double stockQuantity,
      bool isActive});
}

/// @nodoc
class __$$ProductVariantEntityImplCopyWithImpl<$Res>
    extends _$ProductVariantEntityCopyWithImpl<$Res, _$ProductVariantEntityImpl>
    implements _$$ProductVariantEntityImplCopyWith<$Res> {
  __$$ProductVariantEntityImplCopyWithImpl(_$ProductVariantEntityImpl _value,
      $Res Function(_$ProductVariantEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? name = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? priceDelta = null,
    Object? stockQuantity = null,
    Object? isActive = null,
  }) {
    return _then(_$ProductVariantEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      priceDelta: null == priceDelta
          ? _value.priceDelta
          : priceDelta // ignore: cast_nullable_to_non_nullable
              as double,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ProductVariantEntityImpl implements _ProductVariantEntity {
  const _$ProductVariantEntityImpl(
      {required this.id,
      required this.productId,
      required this.name,
      this.sku,
      this.barcode,
      required this.priceDelta,
      required this.stockQuantity,
      required this.isActive});

  @override
  final String id;
  @override
  final String productId;
  @override
  final String name;
  @override
  final String? sku;
  @override
  final String? barcode;
  @override
  final double priceDelta;
  @override
  final double stockQuantity;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'ProductVariantEntity(id: $id, productId: $productId, name: $name, sku: $sku, barcode: $barcode, priceDelta: $priceDelta, stockQuantity: $stockQuantity, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductVariantEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.priceDelta, priceDelta) ||
                other.priceDelta == priceDelta) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, productId, name, sku,
      barcode, priceDelta, stockQuantity, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductVariantEntityImplCopyWith<_$ProductVariantEntityImpl>
      get copyWith =>
          __$$ProductVariantEntityImplCopyWithImpl<_$ProductVariantEntityImpl>(
              this, _$identity);
}

abstract class _ProductVariantEntity implements ProductVariantEntity {
  const factory _ProductVariantEntity(
      {required final String id,
      required final String productId,
      required final String name,
      final String? sku,
      final String? barcode,
      required final double priceDelta,
      required final double stockQuantity,
      required final bool isActive}) = _$ProductVariantEntityImpl;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get name;
  @override
  String? get sku;
  @override
  String? get barcode;
  @override
  double get priceDelta;
  @override
  double get stockQuantity;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$ProductVariantEntityImplCopyWith<_$ProductVariantEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProductEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get brandId => throw _privateConstructorUsedError;
  String? get supplierId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;
  double get taxRate => throw _privateConstructorUsedError;
  ProductUnitTypeEntity get unitType => throw _privateConstructorUsedError;
  bool get trackStock => throw _privateConstructorUsedError;
  double get stockQuantity => throw _privateConstructorUsedError;
  double get lowStockThreshold => throw _privateConstructorUsedError;
  bool get hasVariants => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  CategoryEntity? get category => throw _privateConstructorUsedError;
  BrandEntity? get brand => throw _privateConstructorUsedError;
  SupplierEntity? get supplier => throw _privateConstructorUsedError;
  List<ProductVariantEntity> get variants => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProductEntityCopyWith<ProductEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductEntityCopyWith<$Res> {
  factory $ProductEntityCopyWith(
          ProductEntity value, $Res Function(ProductEntity) then) =
      _$ProductEntityCopyWithImpl<$Res, ProductEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? sku,
      String? barcode,
      String? categoryId,
      String? brandId,
      String? supplierId,
      double price,
      double cost,
      double taxRate,
      ProductUnitTypeEntity unitType,
      bool trackStock,
      double stockQuantity,
      double lowStockThreshold,
      bool hasVariants,
      bool isFavorite,
      bool isActive,
      String? imagePath,
      CategoryEntity? category,
      BrandEntity? brand,
      SupplierEntity? supplier,
      List<ProductVariantEntity> variants,
      DateTime createdAt,
      DateTime updatedAt});

  $CategoryEntityCopyWith<$Res>? get category;
  $BrandEntityCopyWith<$Res>? get brand;
  $SupplierEntityCopyWith<$Res>? get supplier;
}

/// @nodoc
class _$ProductEntityCopyWithImpl<$Res, $Val extends ProductEntity>
    implements $ProductEntityCopyWith<$Res> {
  _$ProductEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? categoryId = freezed,
    Object? brandId = freezed,
    Object? supplierId = freezed,
    Object? price = null,
    Object? cost = null,
    Object? taxRate = null,
    Object? unitType = null,
    Object? trackStock = null,
    Object? stockQuantity = null,
    Object? lowStockThreshold = null,
    Object? hasVariants = null,
    Object? isFavorite = null,
    Object? isActive = null,
    Object? imagePath = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? supplier = freezed,
    Object? variants = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      unitType: null == unitType
          ? _value.unitType
          : unitType // ignore: cast_nullable_to_non_nullable
              as ProductUnitTypeEntity,
      trackStock: null == trackStock
          ? _value.trackStock
          : trackStock // ignore: cast_nullable_to_non_nullable
              as bool,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      lowStockThreshold: null == lowStockThreshold
          ? _value.lowStockThreshold
          : lowStockThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryEntity?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as BrandEntity?,
      supplier: freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as SupplierEntity?,
      variants: null == variants
          ? _value.variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantEntity>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CategoryEntityCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryEntityCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BrandEntityCopyWith<$Res>? get brand {
    if (_value.brand == null) {
      return null;
    }

    return $BrandEntityCopyWith<$Res>(_value.brand!, (value) {
      return _then(_value.copyWith(brand: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SupplierEntityCopyWith<$Res>? get supplier {
    if (_value.supplier == null) {
      return null;
    }

    return $SupplierEntityCopyWith<$Res>(_value.supplier!, (value) {
      return _then(_value.copyWith(supplier: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductEntityImplCopyWith<$Res>
    implements $ProductEntityCopyWith<$Res> {
  factory _$$ProductEntityImplCopyWith(
          _$ProductEntityImpl value, $Res Function(_$ProductEntityImpl) then) =
      __$$ProductEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? sku,
      String? barcode,
      String? categoryId,
      String? brandId,
      String? supplierId,
      double price,
      double cost,
      double taxRate,
      ProductUnitTypeEntity unitType,
      bool trackStock,
      double stockQuantity,
      double lowStockThreshold,
      bool hasVariants,
      bool isFavorite,
      bool isActive,
      String? imagePath,
      CategoryEntity? category,
      BrandEntity? brand,
      SupplierEntity? supplier,
      List<ProductVariantEntity> variants,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $CategoryEntityCopyWith<$Res>? get category;
  @override
  $BrandEntityCopyWith<$Res>? get brand;
  @override
  $SupplierEntityCopyWith<$Res>? get supplier;
}

/// @nodoc
class __$$ProductEntityImplCopyWithImpl<$Res>
    extends _$ProductEntityCopyWithImpl<$Res, _$ProductEntityImpl>
    implements _$$ProductEntityImplCopyWith<$Res> {
  __$$ProductEntityImplCopyWithImpl(
      _$ProductEntityImpl _value, $Res Function(_$ProductEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? categoryId = freezed,
    Object? brandId = freezed,
    Object? supplierId = freezed,
    Object? price = null,
    Object? cost = null,
    Object? taxRate = null,
    Object? unitType = null,
    Object? trackStock = null,
    Object? stockQuantity = null,
    Object? lowStockThreshold = null,
    Object? hasVariants = null,
    Object? isFavorite = null,
    Object? isActive = null,
    Object? imagePath = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? supplier = freezed,
    Object? variants = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProductEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      unitType: null == unitType
          ? _value.unitType
          : unitType // ignore: cast_nullable_to_non_nullable
              as ProductUnitTypeEntity,
      trackStock: null == trackStock
          ? _value.trackStock
          : trackStock // ignore: cast_nullable_to_non_nullable
              as bool,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      lowStockThreshold: null == lowStockThreshold
          ? _value.lowStockThreshold
          : lowStockThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryEntity?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as BrandEntity?,
      supplier: freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as SupplierEntity?,
      variants: null == variants
          ? _value._variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantEntity>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ProductEntityImpl extends _ProductEntity {
  const _$ProductEntityImpl(
      {required this.id,
      required this.name,
      this.description,
      this.sku,
      this.barcode,
      this.categoryId,
      this.brandId,
      this.supplierId,
      required this.price,
      required this.cost,
      required this.taxRate,
      required this.unitType,
      required this.trackStock,
      required this.stockQuantity,
      required this.lowStockThreshold,
      required this.hasVariants,
      required this.isFavorite,
      required this.isActive,
      this.imagePath,
      this.category,
      this.brand,
      this.supplier,
      final List<ProductVariantEntity> variants = const [],
      required this.createdAt,
      required this.updatedAt})
      : _variants = variants,
        super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? sku;
  @override
  final String? barcode;
  @override
  final String? categoryId;
  @override
  final String? brandId;
  @override
  final String? supplierId;
  @override
  final double price;
  @override
  final double cost;
  @override
  final double taxRate;
  @override
  final ProductUnitTypeEntity unitType;
  @override
  final bool trackStock;
  @override
  final double stockQuantity;
  @override
  final double lowStockThreshold;
  @override
  final bool hasVariants;
  @override
  final bool isFavorite;
  @override
  final bool isActive;
  @override
  final String? imagePath;
  @override
  final CategoryEntity? category;
  @override
  final BrandEntity? brand;
  @override
  final SupplierEntity? supplier;
  final List<ProductVariantEntity> _variants;
  @override
  @JsonKey()
  List<ProductVariantEntity> get variants {
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variants);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProductEntity(id: $id, name: $name, description: $description, sku: $sku, barcode: $barcode, categoryId: $categoryId, brandId: $brandId, supplierId: $supplierId, price: $price, cost: $cost, taxRate: $taxRate, unitType: $unitType, trackStock: $trackStock, stockQuantity: $stockQuantity, lowStockThreshold: $lowStockThreshold, hasVariants: $hasVariants, isFavorite: $isFavorite, isActive: $isActive, imagePath: $imagePath, category: $category, brand: $brand, supplier: $supplier, variants: $variants, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.unitType, unitType) ||
                other.unitType == unitType) &&
            (identical(other.trackStock, trackStock) ||
                other.trackStock == trackStock) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.lowStockThreshold, lowStockThreshold) ||
                other.lowStockThreshold == lowStockThreshold) &&
            (identical(other.hasVariants, hasVariants) ||
                other.hasVariants == hasVariants) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier) &&
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        sku,
        barcode,
        categoryId,
        brandId,
        supplierId,
        price,
        cost,
        taxRate,
        unitType,
        trackStock,
        stockQuantity,
        lowStockThreshold,
        hasVariants,
        isFavorite,
        isActive,
        imagePath,
        category,
        brand,
        supplier,
        const DeepCollectionEquality().hash(_variants),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductEntityImplCopyWith<_$ProductEntityImpl> get copyWith =>
      __$$ProductEntityImplCopyWithImpl<_$ProductEntityImpl>(this, _$identity);
}

abstract class _ProductEntity extends ProductEntity {
  const factory _ProductEntity(
      {required final String id,
      required final String name,
      final String? description,
      final String? sku,
      final String? barcode,
      final String? categoryId,
      final String? brandId,
      final String? supplierId,
      required final double price,
      required final double cost,
      required final double taxRate,
      required final ProductUnitTypeEntity unitType,
      required final bool trackStock,
      required final double stockQuantity,
      required final double lowStockThreshold,
      required final bool hasVariants,
      required final bool isFavorite,
      required final bool isActive,
      final String? imagePath,
      final CategoryEntity? category,
      final BrandEntity? brand,
      final SupplierEntity? supplier,
      final List<ProductVariantEntity> variants,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ProductEntityImpl;
  const _ProductEntity._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get sku;
  @override
  String? get barcode;
  @override
  String? get categoryId;
  @override
  String? get brandId;
  @override
  String? get supplierId;
  @override
  double get price;
  @override
  double get cost;
  @override
  double get taxRate;
  @override
  ProductUnitTypeEntity get unitType;
  @override
  bool get trackStock;
  @override
  double get stockQuantity;
  @override
  double get lowStockThreshold;
  @override
  bool get hasVariants;
  @override
  bool get isFavorite;
  @override
  bool get isActive;
  @override
  String? get imagePath;
  @override
  CategoryEntity? get category;
  @override
  BrandEntity? get brand;
  @override
  SupplierEntity? get supplier;
  @override
  List<ProductVariantEntity> get variants;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProductEntityImplCopyWith<_$ProductEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
