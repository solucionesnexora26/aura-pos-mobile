// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InventoryMovementEntity {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String? get variantId => throw _privateConstructorUsedError;
  InventoryMovementTypeEntity get type => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get stockBefore => throw _privateConstructorUsedError;
  double get stockAfter => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String? get referenceId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Datos denormalizados para mostrar en el Kardex sin join
  String? get productName => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InventoryMovementEntityCopyWith<InventoryMovementEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryMovementEntityCopyWith<$Res> {
  factory $InventoryMovementEntityCopyWith(InventoryMovementEntity value,
          $Res Function(InventoryMovementEntity) then) =
      _$InventoryMovementEntityCopyWithImpl<$Res, InventoryMovementEntity>;
  @useResult
  $Res call(
      {String id,
      String productId,
      String? variantId,
      InventoryMovementTypeEntity type,
      double quantity,
      double stockBefore,
      double stockAfter,
      String? reason,
      String? referenceId,
      String userId,
      DateTime createdAt,
      String? productName,
      String? userName});
}

/// @nodoc
class _$InventoryMovementEntityCopyWithImpl<$Res,
        $Val extends InventoryMovementEntity>
    implements $InventoryMovementEntityCopyWith<$Res> {
  _$InventoryMovementEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variantId = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? stockBefore = null,
    Object? stockAfter = null,
    Object? reason = freezed,
    Object? referenceId = freezed,
    Object? userId = null,
    Object? createdAt = null,
    Object? productName = freezed,
    Object? userName = freezed,
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
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InventoryMovementTypeEntity,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      stockBefore: null == stockBefore
          ? _value.stockBefore
          : stockBefore // ignore: cast_nullable_to_non_nullable
              as double,
      stockAfter: null == stockAfter
          ? _value.stockAfter
          : stockAfter // ignore: cast_nullable_to_non_nullable
              as double,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryMovementEntityImplCopyWith<$Res>
    implements $InventoryMovementEntityCopyWith<$Res> {
  factory _$$InventoryMovementEntityImplCopyWith(
          _$InventoryMovementEntityImpl value,
          $Res Function(_$InventoryMovementEntityImpl) then) =
      __$$InventoryMovementEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String? variantId,
      InventoryMovementTypeEntity type,
      double quantity,
      double stockBefore,
      double stockAfter,
      String? reason,
      String? referenceId,
      String userId,
      DateTime createdAt,
      String? productName,
      String? userName});
}

/// @nodoc
class __$$InventoryMovementEntityImplCopyWithImpl<$Res>
    extends _$InventoryMovementEntityCopyWithImpl<$Res,
        _$InventoryMovementEntityImpl>
    implements _$$InventoryMovementEntityImplCopyWith<$Res> {
  __$$InventoryMovementEntityImplCopyWithImpl(
      _$InventoryMovementEntityImpl _value,
      $Res Function(_$InventoryMovementEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variantId = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? stockBefore = null,
    Object? stockAfter = null,
    Object? reason = freezed,
    Object? referenceId = freezed,
    Object? userId = null,
    Object? createdAt = null,
    Object? productName = freezed,
    Object? userName = freezed,
  }) {
    return _then(_$InventoryMovementEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InventoryMovementTypeEntity,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      stockBefore: null == stockBefore
          ? _value.stockBefore
          : stockBefore // ignore: cast_nullable_to_non_nullable
              as double,
      stockAfter: null == stockAfter
          ? _value.stockAfter
          : stockAfter // ignore: cast_nullable_to_non_nullable
              as double,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$InventoryMovementEntityImpl implements _InventoryMovementEntity {
  const _$InventoryMovementEntityImpl(
      {required this.id,
      required this.productId,
      this.variantId,
      required this.type,
      required this.quantity,
      required this.stockBefore,
      required this.stockAfter,
      this.reason,
      this.referenceId,
      required this.userId,
      required this.createdAt,
      this.productName,
      this.userName});

  @override
  final String id;
  @override
  final String productId;
  @override
  final String? variantId;
  @override
  final InventoryMovementTypeEntity type;
  @override
  final double quantity;
  @override
  final double stockBefore;
  @override
  final double stockAfter;
  @override
  final String? reason;
  @override
  final String? referenceId;
  @override
  final String userId;
  @override
  final DateTime createdAt;
// Datos denormalizados para mostrar en el Kardex sin join
  @override
  final String? productName;
  @override
  final String? userName;

  @override
  String toString() {
    return 'InventoryMovementEntity(id: $id, productId: $productId, variantId: $variantId, type: $type, quantity: $quantity, stockBefore: $stockBefore, stockAfter: $stockAfter, reason: $reason, referenceId: $referenceId, userId: $userId, createdAt: $createdAt, productName: $productName, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryMovementEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.stockBefore, stockBefore) ||
                other.stockBefore == stockBefore) &&
            (identical(other.stockAfter, stockAfter) ||
                other.stockAfter == stockAfter) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.userName, userName) ||
                other.userName == userName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      variantId,
      type,
      quantity,
      stockBefore,
      stockAfter,
      reason,
      referenceId,
      userId,
      createdAt,
      productName,
      userName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryMovementEntityImplCopyWith<_$InventoryMovementEntityImpl>
      get copyWith => __$$InventoryMovementEntityImplCopyWithImpl<
          _$InventoryMovementEntityImpl>(this, _$identity);
}

abstract class _InventoryMovementEntity implements InventoryMovementEntity {
  const factory _InventoryMovementEntity(
      {required final String id,
      required final String productId,
      final String? variantId,
      required final InventoryMovementTypeEntity type,
      required final double quantity,
      required final double stockBefore,
      required final double stockAfter,
      final String? reason,
      final String? referenceId,
      required final String userId,
      required final DateTime createdAt,
      final String? productName,
      final String? userName}) = _$InventoryMovementEntityImpl;

  @override
  String get id;
  @override
  String get productId;
  @override
  String? get variantId;
  @override
  InventoryMovementTypeEntity get type;
  @override
  double get quantity;
  @override
  double get stockBefore;
  @override
  double get stockAfter;
  @override
  String? get reason;
  @override
  String? get referenceId;
  @override
  String get userId;
  @override
  DateTime get createdAt;
  @override // Datos denormalizados para mostrar en el Kardex sin join
  String? get productName;
  @override
  String? get userName;
  @override
  @JsonKey(ignore: true)
  _$$InventoryMovementEntityImplCopyWith<_$InventoryMovementEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
