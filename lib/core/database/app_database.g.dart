// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _authUserIdMeta =
      const VerificationMeta('authUserId');
  @override
  late final GeneratedColumn<String> authUserId = GeneratedColumn<String>(
      'auth_user_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinSaltMeta =
      const VerificationMeta('pinSalt');
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
      'pin_salt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumnWithTypeConverter<UserRole, int> role =
      GeneratedColumn<int>('role', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<UserRole>($UsersTable.$converterrole);
  static const VerificationMeta _biometricEnabledMeta =
      const VerificationMeta('biometricEnabled');
  @override
  late final GeneratedColumn<bool> biometricEnabled = GeneratedColumn<bool>(
      'biometric_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("biometric_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        authUserId,
        fullName,
        username,
        email,
        pinHash,
        pinSalt,
        role,
        biometricEnabled,
        isActive,
        avatarPath,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<UserRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('auth_user_id')) {
      context.handle(
          _authUserIdMeta,
          authUserId.isAcceptableOrUnknown(
              data['auth_user_id']!, _authUserIdMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('pin_salt')) {
      context.handle(_pinSaltMeta,
          pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta));
    } else if (isInserting) {
      context.missing(_pinSaltMeta);
    }
    context.handle(_roleMeta, const VerificationResult.success());
    if (data.containsKey('biometric_enabled')) {
      context.handle(
          _biometricEnabledMeta,
          biometricEnabled.isAcceptableOrUnknown(
              data['biometric_enabled']!, _biometricEnabledMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      authUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}auth_user_id']),
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash'])!,
      pinSalt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_salt'])!,
      role: $UsersTable.$converterrole.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}role'])!),
      biometricEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}biometric_enabled'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UserRole, int, int> $converterrole =
      const EnumIndexConverter<UserRole>(UserRole.values);
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final String id;
  final String? authUserId;
  final String fullName;
  final String username;
  final String? email;
  final String pinHash;
  final String pinSalt;
  final UserRole role;
  final bool biometricEnabled;
  final bool isActive;
  final String? avatarPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserRow(
      {required this.id,
      this.authUserId,
      required this.fullName,
      required this.username,
      this.email,
      required this.pinHash,
      required this.pinSalt,
      required this.role,
      required this.biometricEnabled,
      required this.isActive,
      this.avatarPath,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || authUserId != null) {
      map['auth_user_id'] = Variable<String>(authUserId);
    }
    map['full_name'] = Variable<String>(fullName);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['pin_hash'] = Variable<String>(pinHash);
    map['pin_salt'] = Variable<String>(pinSalt);
    {
      map['role'] = Variable<int>($UsersTable.$converterrole.toSql(role));
    }
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      authUserId: authUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(authUserId),
      fullName: Value(fullName),
      username: Value(username),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      pinHash: Value(pinHash),
      pinSalt: Value(pinSalt),
      role: Value(role),
      biometricEnabled: Value(biometricEnabled),
      isActive: Value(isActive),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      id: serializer.fromJson<String>(json['id']),
      authUserId: serializer.fromJson<String?>(json['authUserId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String?>(json['email']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      pinSalt: serializer.fromJson<String>(json['pinSalt']),
      role: $UsersTable.$converterrole
          .fromJson(serializer.fromJson<int>(json['role'])),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authUserId': serializer.toJson<String?>(authUserId),
      'fullName': serializer.toJson<String>(fullName),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String?>(email),
      'pinHash': serializer.toJson<String>(pinHash),
      'pinSalt': serializer.toJson<String>(pinSalt),
      'role': serializer.toJson<int>($UsersTable.$converterrole.toJson(role)),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'isActive': serializer.toJson<bool>(isActive),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserRow copyWith(
          {String? id,
          Value<String?> authUserId = const Value.absent(),
          String? fullName,
          String? username,
          Value<String?> email = const Value.absent(),
          String? pinHash,
          String? pinSalt,
          UserRole? role,
          bool? biometricEnabled,
          bool? isActive,
          Value<String?> avatarPath = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserRow(
        id: id ?? this.id,
        authUserId: authUserId.present ? authUserId.value : this.authUserId,
        fullName: fullName ?? this.fullName,
        username: username ?? this.username,
        email: email.present ? email.value : this.email,
        pinHash: pinHash ?? this.pinHash,
        pinSalt: pinSalt ?? this.pinSalt,
        role: role ?? this.role,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        isActive: isActive ?? this.isActive,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserRow copyWithCompanion(UsersCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      authUserId:
          data.authUserId.present ? data.authUserId.value : this.authUserId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      role: data.role.present ? data.role.value : this.role,
      biometricEnabled: data.biometricEnabled.present
          ? data.biometricEnabled.value
          : this.biometricEnabled,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('authUserId: $authUserId, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('role: $role, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('isActive: $isActive, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      authUserId,
      fullName,
      username,
      email,
      pinHash,
      pinSalt,
      role,
      biometricEnabled,
      isActive,
      avatarPath,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.authUserId == this.authUserId &&
          other.fullName == this.fullName &&
          other.username == this.username &&
          other.email == this.email &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt &&
          other.role == this.role &&
          other.biometricEnabled == this.biometricEnabled &&
          other.isActive == this.isActive &&
          other.avatarPath == this.avatarPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<UserRow> {
  final Value<String> id;
  final Value<String?> authUserId;
  final Value<String> fullName;
  final Value<String> username;
  final Value<String?> email;
  final Value<String> pinHash;
  final Value<String> pinSalt;
  final Value<UserRole> role;
  final Value<bool> biometricEnabled;
  final Value<bool> isActive;
  final Value<String?> avatarPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.authUserId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.role = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.authUserId = const Value.absent(),
    required String fullName,
    required String username,
    this.email = const Value.absent(),
    required String pinHash,
    required String pinSalt,
    required UserRole role,
    this.biometricEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : fullName = Value(fullName),
        username = Value(username),
        pinHash = Value(pinHash),
        pinSalt = Value(pinSalt),
        role = Value(role);
  static Insertable<UserRow> custom({
    Expression<String>? id,
    Expression<String>? authUserId,
    Expression<String>? fullName,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
    Expression<int>? role,
    Expression<bool>? biometricEnabled,
    Expression<bool>? isActive,
    Expression<String>? avatarPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authUserId != null) 'auth_user_id': authUserId,
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (role != null) 'role': role,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (isActive != null) 'is_active': isActive,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? authUserId,
      Value<String>? fullName,
      Value<String>? username,
      Value<String?>? email,
      Value<String>? pinHash,
      Value<String>? pinSalt,
      Value<UserRole>? role,
      Value<bool>? biometricEnabled,
      Value<bool>? isActive,
      Value<String?>? avatarPath,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      role: role ?? this.role,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      isActive: isActive ?? this.isActive,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (authUserId.present) {
      map['auth_user_id'] = Variable<String>(authUserId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (role.present) {
      map['role'] = Variable<int>($UsersTable.$converterrole.toSql(role.value));
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('authUserId: $authUserId, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('role: $role, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('isActive: $isActive, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#5B5FEF'));
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, colorHex, iconName, sortOrder, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final String colorHex;
  final String? iconName;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  const CategoryRow(
      {required this.id,
      required this.name,
      required this.colorHex,
      this.iconName,
      required this.sortOrder,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory CategoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
      'iconName': serializer.toJson<String?>(iconName),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoryRow copyWith(
          {String? id,
          String? name,
          String? colorHex,
          Value<String?> iconName = const Value.absent(),
          int? sortOrder,
          bool? isActive,
          DateTime? createdAt}) =>
      CategoryRow(
        id: id ?? this.id,
        name: name ?? this.name,
        colorHex: colorHex ?? this.colorHex,
        iconName: iconName.present ? iconName.value : this.iconName,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, colorHex, iconName, sortOrder, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.iconName == this.iconName &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<String?> iconName;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorHex = const Value.absent(),
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<String>? iconName,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (iconName != null) 'icon_name': iconName,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? colorHex,
      Value<String?>? iconName,
      Value<int>? sortOrder,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      iconName: iconName ?? this.iconName,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrandsTable extends Brands with TableInfo<$BrandsTable, BrandRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brands';
  @override
  VerificationContext validateIntegrity(Insertable<BrandRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrandRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrandRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $BrandsTable createAlias(String alias) {
    return $BrandsTable(attachedDatabase, alias);
  }
}

class BrandRow extends DataClass implements Insertable<BrandRow> {
  final String id;
  final String name;
  const BrandRow({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  BrandsCompanion toCompanion(bool nullToAbsent) {
    return BrandsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory BrandRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrandRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  BrandRow copyWith({String? id, String? name}) => BrandRow(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  BrandRow copyWithCompanion(BrandsCompanion data) {
    return BrandRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrandRow(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrandRow && other.id == this.id && other.name == this.name);
}

class BrandsCompanion extends UpdateCompanion<BrandRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const BrandsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrandsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<BrandRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrandsCompanion copyWith(
      {Value<String>? id, Value<String>? name, Value<int>? rowid}) {
    return BrandsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, SupplierRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contactNameMeta =
      const VerificationMeta('contactName');
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
      'contact_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, contactName, phone, email, address, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<SupplierRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact_name')) {
      context.handle(
          _contactNameMeta,
          contactName.isAcceptableOrUnknown(
              data['contact_name']!, _contactNameMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      contactName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_name']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class SupplierRow extends DataClass implements Insertable<SupplierRow> {
  final String id;
  final String name;
  final String? contactName;
  final String? phone;
  final String? email;
  final String? address;
  final bool isActive;
  const SupplierRow(
      {required this.id,
      required this.name,
      this.contactName,
      this.phone,
      this.email,
      this.address,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || contactName != null) {
      map['contact_name'] = Variable<String>(contactName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      contactName: contactName == null && nullToAbsent
          ? const Value.absent()
          : Value(contactName),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      isActive: Value(isActive),
    );
  }

  factory SupplierRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contactName: serializer.fromJson<String?>(json['contactName']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'contactName': serializer.toJson<String?>(contactName),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SupplierRow copyWith(
          {String? id,
          String? name,
          Value<String?> contactName = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          bool? isActive}) =>
      SupplierRow(
        id: id ?? this.id,
        name: name ?? this.name,
        contactName: contactName.present ? contactName.value : this.contactName,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        isActive: isActive ?? this.isActive,
      );
  SupplierRow copyWithCompanion(SuppliersCompanion data) {
    return SupplierRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contactName:
          data.contactName.present ? data.contactName.value : this.contactName,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contactName: $contactName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, contactName, phone, email, address, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.contactName == this.contactName &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.isActive == this.isActive);
}

class SuppliersCompanion extends UpdateCompanion<SupplierRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> contactName;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contactName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.contactName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<SupplierRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? contactName,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contactName != null) 'contact_name': contactName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? contactName,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contactName: $contactName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _brandIdMeta =
      const VerificationMeta('brandId');
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
      'brand_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES brands (id)'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
      'cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxRateMeta =
      const VerificationMeta('taxRate');
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
      'tax_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unitTypeMeta =
      const VerificationMeta('unitType');
  @override
  late final GeneratedColumnWithTypeConverter<ProductUnitType, int> unitType =
      GeneratedColumn<int>('unit_type', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<ProductUnitType>($ProductsTable.$converterunitType);
  static const VerificationMeta _trackStockMeta =
      const VerificationMeta('trackStock');
  @override
  late final GeneratedColumn<bool> trackStock = GeneratedColumn<bool>(
      'track_stock', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("track_stock" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _stockQuantityMeta =
      const VerificationMeta('stockQuantity');
  @override
  late final GeneratedColumn<double> stockQuantity = GeneratedColumn<double>(
      'stock_quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lowStockThresholdMeta =
      const VerificationMeta('lowStockThreshold');
  @override
  late final GeneratedColumn<double> lowStockThreshold =
      GeneratedColumn<double>('low_stock_threshold', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(5));
  static const VerificationMeta _hasVariantsMeta =
      const VerificationMeta('hasVariants');
  @override
  late final GeneratedColumn<bool> hasVariants = GeneratedColumn<bool>(
      'has_variants', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_variants" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns => [
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
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<ProductRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('brand_id')) {
      context.handle(_brandIdMeta,
          brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    }
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta));
    }
    context.handle(_unitTypeMeta, const VerificationResult.success());
    if (data.containsKey('track_stock')) {
      context.handle(
          _trackStockMeta,
          trackStock.isAcceptableOrUnknown(
              data['track_stock']!, _trackStockMeta));
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
          _stockQuantityMeta,
          stockQuantity.isAcceptableOrUnknown(
              data['stock_quantity']!, _stockQuantityMeta));
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
          _lowStockThresholdMeta,
          lowStockThreshold.isAcceptableOrUnknown(
              data['low_stock_threshold']!, _lowStockThresholdMeta));
    }
    if (data.containsKey('has_variants')) {
      context.handle(
          _hasVariantsMeta,
          hasVariants.isAcceptableOrUnknown(
              data['has_variants']!, _hasVariantsMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      brandId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand_id']),
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_id']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost'])!,
      taxRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_rate'])!,
      unitType: $ProductsTable.$converterunitType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_type'])!),
      trackStock: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}track_stock'])!,
      stockQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_quantity'])!,
      lowStockThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}low_stock_threshold'])!,
      hasVariants: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_variants'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ProductUnitType, int, int> $converterunitType =
      const EnumIndexConverter<ProductUnitType>(ProductUnitType.values);
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  final String id;
  final String name;
  final String? description;
  final String? sku;
  final String? barcode;
  final String? categoryId;
  final String? brandId;
  final String? supplierId;
  final double price;
  final double cost;
  final double taxRate;
  final ProductUnitType unitType;
  final bool trackStock;
  final double stockQuantity;
  final double lowStockThreshold;
  final bool hasVariants;
  final bool isFavorite;
  final bool isActive;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProductRow(
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
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['price'] = Variable<double>(price);
    map['cost'] = Variable<double>(cost);
    map['tax_rate'] = Variable<double>(taxRate);
    {
      map['unit_type'] =
          Variable<int>($ProductsTable.$converterunitType.toSql(unitType));
    }
    map['track_stock'] = Variable<bool>(trackStock);
    map['stock_quantity'] = Variable<double>(stockQuantity);
    map['low_stock_threshold'] = Variable<double>(lowStockThreshold);
    map['has_variants'] = Variable<bool>(hasVariants);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      price: Value(price),
      cost: Value(cost),
      taxRate: Value(taxRate),
      unitType: Value(unitType),
      trackStock: Value(trackStock),
      stockQuantity: Value(stockQuantity),
      lowStockThreshold: Value(lowStockThreshold),
      hasVariants: Value(hasVariants),
      isFavorite: Value(isFavorite),
      isActive: Value(isActive),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      sku: serializer.fromJson<String?>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      price: serializer.fromJson<double>(json['price']),
      cost: serializer.fromJson<double>(json['cost']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      unitType: $ProductsTable.$converterunitType
          .fromJson(serializer.fromJson<int>(json['unitType'])),
      trackStock: serializer.fromJson<bool>(json['trackStock']),
      stockQuantity: serializer.fromJson<double>(json['stockQuantity']),
      lowStockThreshold: serializer.fromJson<double>(json['lowStockThreshold']),
      hasVariants: serializer.fromJson<bool>(json['hasVariants']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'sku': serializer.toJson<String?>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'categoryId': serializer.toJson<String?>(categoryId),
      'brandId': serializer.toJson<String?>(brandId),
      'supplierId': serializer.toJson<String?>(supplierId),
      'price': serializer.toJson<double>(price),
      'cost': serializer.toJson<double>(cost),
      'taxRate': serializer.toJson<double>(taxRate),
      'unitType': serializer
          .toJson<int>($ProductsTable.$converterunitType.toJson(unitType)),
      'trackStock': serializer.toJson<bool>(trackStock),
      'stockQuantity': serializer.toJson<double>(stockQuantity),
      'lowStockThreshold': serializer.toJson<double>(lowStockThreshold),
      'hasVariants': serializer.toJson<bool>(hasVariants),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isActive': serializer.toJson<bool>(isActive),
      'imagePath': serializer.toJson<String?>(imagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductRow copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> sku = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<String?> categoryId = const Value.absent(),
          Value<String?> brandId = const Value.absent(),
          Value<String?> supplierId = const Value.absent(),
          double? price,
          double? cost,
          double? taxRate,
          ProductUnitType? unitType,
          bool? trackStock,
          double? stockQuantity,
          double? lowStockThreshold,
          bool? hasVariants,
          bool? isFavorite,
          bool? isActive,
          Value<String?> imagePath = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ProductRow(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        sku: sku.present ? sku.value : this.sku,
        barcode: barcode.present ? barcode.value : this.barcode,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        brandId: brandId.present ? brandId.value : this.brandId,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        price: price ?? this.price,
        cost: cost ?? this.cost,
        taxRate: taxRate ?? this.taxRate,
        unitType: unitType ?? this.unitType,
        trackStock: trackStock ?? this.trackStock,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
        hasVariants: hasVariants ?? this.hasVariants,
        isFavorite: isFavorite ?? this.isFavorite,
        isActive: isActive ?? this.isActive,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProductRow copyWithCompanion(ProductsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      price: data.price.present ? data.price.value : this.price,
      cost: data.cost.present ? data.cost.value : this.cost,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      trackStock:
          data.trackStock.present ? data.trackStock.value : this.trackStock,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      hasVariants:
          data.hasVariants.present ? data.hasVariants.value : this.hasVariants,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('brandId: $brandId, ')
          ..write('supplierId: $supplierId, ')
          ..write('price: $price, ')
          ..write('cost: $cost, ')
          ..write('taxRate: $taxRate, ')
          ..write('unitType: $unitType, ')
          ..write('trackStock: $trackStock, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('hasVariants: $hasVariants, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isActive: $isActive, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.categoryId == this.categoryId &&
          other.brandId == this.brandId &&
          other.supplierId == this.supplierId &&
          other.price == this.price &&
          other.cost == this.cost &&
          other.taxRate == this.taxRate &&
          other.unitType == this.unitType &&
          other.trackStock == this.trackStock &&
          other.stockQuantity == this.stockQuantity &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.hasVariants == this.hasVariants &&
          other.isFavorite == this.isFavorite &&
          other.isActive == this.isActive &&
          other.imagePath == this.imagePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<ProductRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> sku;
  final Value<String?> barcode;
  final Value<String?> categoryId;
  final Value<String?> brandId;
  final Value<String?> supplierId;
  final Value<double> price;
  final Value<double> cost;
  final Value<double> taxRate;
  final Value<ProductUnitType> unitType;
  final Value<bool> trackStock;
  final Value<double> stockQuantity;
  final Value<double> lowStockThreshold;
  final Value<bool> hasVariants;
  final Value<bool> isFavorite;
  final Value<bool> isActive;
  final Value<String?> imagePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.price = const Value.absent(),
    this.cost = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.unitType = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.hasVariants = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isActive = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.supplierId = const Value.absent(),
    required double price,
    this.cost = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.unitType = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.hasVariants = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isActive = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        price = Value(price);
  static Insertable<ProductRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<String>? categoryId,
    Expression<String>? brandId,
    Expression<String>? supplierId,
    Expression<double>? price,
    Expression<double>? cost,
    Expression<double>? taxRate,
    Expression<int>? unitType,
    Expression<bool>? trackStock,
    Expression<double>? stockQuantity,
    Expression<double>? lowStockThreshold,
    Expression<bool>? hasVariants,
    Expression<bool>? isFavorite,
    Expression<bool>? isActive,
    Expression<String>? imagePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (price != null) 'price': price,
      if (cost != null) 'cost': cost,
      if (taxRate != null) 'tax_rate': taxRate,
      if (unitType != null) 'unit_type': unitType,
      if (trackStock != null) 'track_stock': trackStock,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (hasVariants != null) 'has_variants': hasVariants,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isActive != null) 'is_active': isActive,
      if (imagePath != null) 'image_path': imagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? sku,
      Value<String?>? barcode,
      Value<String?>? categoryId,
      Value<String?>? brandId,
      Value<String?>? supplierId,
      Value<double>? price,
      Value<double>? cost,
      Value<double>? taxRate,
      Value<ProductUnitType>? unitType,
      Value<bool>? trackStock,
      Value<double>? stockQuantity,
      Value<double>? lowStockThreshold,
      Value<bool>? hasVariants,
      Value<bool>? isFavorite,
      Value<bool>? isActive,
      Value<String?>? imagePath,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      supplierId: supplierId ?? this.supplierId,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      taxRate: taxRate ?? this.taxRate,
      unitType: unitType ?? this.unitType,
      trackStock: trackStock ?? this.trackStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      hasVariants: hasVariants ?? this.hasVariants,
      isFavorite: isFavorite ?? this.isFavorite,
      isActive: isActive ?? this.isActive,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<int>(
          $ProductsTable.$converterunitType.toSql(unitType.value));
    }
    if (trackStock.present) {
      map['track_stock'] = Variable<bool>(trackStock.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<double>(stockQuantity.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<double>(lowStockThreshold.value);
    }
    if (hasVariants.present) {
      map['has_variants'] = Variable<bool>(hasVariants.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('brandId: $brandId, ')
          ..write('supplierId: $supplierId, ')
          ..write('price: $price, ')
          ..write('cost: $cost, ')
          ..write('taxRate: $taxRate, ')
          ..write('unitType: $unitType, ')
          ..write('trackStock: $trackStock, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('hasVariants: $hasVariants, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isActive: $isActive, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductVariantsTable extends ProductVariants
    with TableInfo<$ProductVariantsTable, ProductVariantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _priceDeltaMeta =
      const VerificationMeta('priceDelta');
  @override
  late final GeneratedColumn<double> priceDelta = GeneratedColumn<double>(
      'price_delta', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stockQuantityMeta =
      const VerificationMeta('stockQuantity');
  @override
  late final GeneratedColumn<double> stockQuantity = GeneratedColumn<double>(
      'stock_quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, name, sku, barcode, priceDelta, stockQuantity, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_variants';
  @override
  VerificationContext validateIntegrity(Insertable<ProductVariantRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('price_delta')) {
      context.handle(
          _priceDeltaMeta,
          priceDelta.isAcceptableOrUnknown(
              data['price_delta']!, _priceDeltaMeta));
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
          _stockQuantityMeta,
          stockQuantity.isAcceptableOrUnknown(
              data['stock_quantity']!, _stockQuantityMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductVariantRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductVariantRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      priceDelta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_delta'])!,
      stockQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_quantity'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ProductVariantsTable createAlias(String alias) {
    return $ProductVariantsTable(attachedDatabase, alias);
  }
}

class ProductVariantRow extends DataClass
    implements Insertable<ProductVariantRow> {
  final String id;
  final String productId;
  final String name;
  final String? sku;
  final String? barcode;
  final double priceDelta;
  final double stockQuantity;
  final bool isActive;
  const ProductVariantRow(
      {required this.id,
      required this.productId,
      required this.name,
      this.sku,
      this.barcode,
      required this.priceDelta,
      required this.stockQuantity,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['price_delta'] = Variable<double>(priceDelta);
    map['stock_quantity'] = Variable<double>(stockQuantity);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductVariantsCompanion toCompanion(bool nullToAbsent) {
    return ProductVariantsCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      priceDelta: Value(priceDelta),
      stockQuantity: Value(stockQuantity),
      isActive: Value(isActive),
    );
  }

  factory ProductVariantRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductVariantRow(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      sku: serializer.fromJson<String?>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      priceDelta: serializer.fromJson<double>(json['priceDelta']),
      stockQuantity: serializer.fromJson<double>(json['stockQuantity']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'sku': serializer.toJson<String?>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'priceDelta': serializer.toJson<double>(priceDelta),
      'stockQuantity': serializer.toJson<double>(stockQuantity),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ProductVariantRow copyWith(
          {String? id,
          String? productId,
          String? name,
          Value<String?> sku = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          double? priceDelta,
          double? stockQuantity,
          bool? isActive}) =>
      ProductVariantRow(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        name: name ?? this.name,
        sku: sku.present ? sku.value : this.sku,
        barcode: barcode.present ? barcode.value : this.barcode,
        priceDelta: priceDelta ?? this.priceDelta,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        isActive: isActive ?? this.isActive,
      );
  ProductVariantRow copyWithCompanion(ProductVariantsCompanion data) {
    return ProductVariantRow(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      priceDelta:
          data.priceDelta.present ? data.priceDelta.value : this.priceDelta,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariantRow(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('priceDelta: $priceDelta, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, productId, name, sku, barcode, priceDelta, stockQuantity, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductVariantRow &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.priceDelta == this.priceDelta &&
          other.stockQuantity == this.stockQuantity &&
          other.isActive == this.isActive);
}

class ProductVariantsCompanion extends UpdateCompanion<ProductVariantRow> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> name;
  final Value<String?> sku;
  final Value<String?> barcode;
  final Value<double> priceDelta;
  final Value<double> stockQuantity;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ProductVariantsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.priceDelta = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductVariantsCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    required String name,
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.priceDelta = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : productId = Value(productId),
        name = Value(name);
  static Insertable<ProductVariantRow> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<double>? priceDelta,
    Expression<double>? stockQuantity,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (priceDelta != null) 'price_delta': priceDelta,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductVariantsCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? name,
      Value<String?>? sku,
      Value<String?>? barcode,
      Value<double>? priceDelta,
      Value<double>? stockQuantity,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ProductVariantsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      priceDelta: priceDelta ?? this.priceDelta,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (priceDelta.present) {
      map['price_delta'] = Variable<double>(priceDelta.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<double>(stockQuantity.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariantsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('priceDelta: $priceDelta, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
      'document_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<CustomerType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<CustomerType>($CustomersTable.$convertertype);
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _creditBalanceMeta =
      const VerificationMeta('creditBalance');
  @override
  late final GeneratedColumn<double> creditBalance = GeneratedColumn<double>(
      'credit_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.fromMillisecondsSinceEpoch(0)));
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fullName,
        documentId,
        phone,
        email,
        address,
        type,
        creditLimit,
        creditBalance,
        isActive,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<CustomerRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    }
    if (data.containsKey('credit_balance')) {
      context.handle(
          _creditBalanceMeta,
          creditBalance.isAcceptableOrUnknown(
              data['credit_balance']!, _creditBalanceMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_id']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      type: $CustomersTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit'])!,
      creditBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_balance'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CustomerType, int, int> $convertertype =
      const EnumIndexConverter<CustomerType>(CustomerType.values);
}

class CustomerRow extends DataClass implements Insertable<CustomerRow> {
  final String id;
  final String fullName;
  final String? documentId;
  final String? phone;
  final String? email;
  final String? address;
  final CustomerType type;
  final double creditLimit;
  final double creditBalance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const CustomerRow(
      {required this.id,
      required this.fullName,
      this.documentId,
      this.phone,
      this.email,
      this.address,
      required this.type,
      required this.creditLimit,
      required this.creditBalance,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || documentId != null) {
      map['document_id'] = Variable<String>(documentId);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    {
      map['type'] = Variable<int>($CustomersTable.$convertertype.toSql(type));
    }
    map['credit_limit'] = Variable<double>(creditLimit);
    map['credit_balance'] = Variable<double>(creditBalance);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      documentId: documentId == null && nullToAbsent
          ? const Value.absent()
          : Value(documentId),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      type: Value(type),
      creditLimit: Value(creditLimit),
      creditBalance: Value(creditBalance),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CustomerRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRow(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      documentId: serializer.fromJson<String?>(json['documentId']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      type: $CustomersTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      creditBalance: serializer.fromJson<double>(json['creditBalance']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'documentId': serializer.toJson<String?>(documentId),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'type':
          serializer.toJson<int>($CustomersTable.$convertertype.toJson(type)),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'creditBalance': serializer.toJson<double>(creditBalance),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CustomerRow copyWith(
          {String? id,
          String? fullName,
          Value<String?> documentId = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          CustomerType? type,
          double? creditLimit,
          double? creditBalance,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      CustomerRow(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        documentId: documentId.present ? documentId.value : this.documentId,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        type: type ?? this.type,
        creditLimit: creditLimit ?? this.creditLimit,
        creditBalance: creditBalance ?? this.creditBalance,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  CustomerRow copyWithCompanion(CustomersCompanion data) {
    return CustomerRow(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      type: data.type.present ? data.type.value : this.type,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      creditBalance: data.creditBalance.present
          ? data.creditBalance.value
          : this.creditBalance,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRow(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('documentId: $documentId, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('type: $type, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('creditBalance: $creditBalance, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      fullName,
      documentId,
      phone,
      email,
      address,
      type,
      creditLimit,
      creditBalance,
      isActive,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRow &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.documentId == this.documentId &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.type == this.type &&
          other.creditLimit == this.creditLimit &&
          other.creditBalance == this.creditBalance &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CustomersCompanion extends UpdateCompanion<CustomerRow> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String?> documentId;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<CustomerType> type;
  final Value<double> creditLimit;
  final Value<double> creditBalance;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.documentId = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.type = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.creditBalance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String fullName,
    this.documentId = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.type = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.creditBalance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : fullName = Value(fullName);
  static Insertable<CustomerRow> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? documentId,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<int>? type,
    Expression<double>? creditLimit,
    Expression<double>? creditBalance,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (documentId != null) 'document_id': documentId,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (type != null) 'type': type,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (creditBalance != null) 'credit_balance': creditBalance,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<String?>? documentId,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<CustomerType>? type,
      Value<double>? creditLimit,
      Value<double>? creditBalance,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return CustomersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      documentId: documentId ?? this.documentId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      type: type ?? this.type,
      creditLimit: creditLimit ?? this.creditLimit,
      creditBalance: creditBalance ?? this.creditBalance,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($CustomersTable.$convertertype.toSql(type.value));
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (creditBalance.present) {
      map['credit_balance'] = Variable<double>(creditBalance.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('documentId: $documentId, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('type: $type, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('creditBalance: $creditBalance, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, SaleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _ticketNumberMeta =
      const VerificationMeta('ticketNumber');
  @override
  late final GeneratedColumn<String> ticketNumber = GeneratedColumn<String>(
      'ticket_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ticketLabelMeta =
      const VerificationMeta('ticketLabel');
  @override
  late final GeneratedColumn<String> ticketLabel = GeneratedColumn<String>(
      'ticket_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _cashRegisterIdMeta =
      const VerificationMeta('cashRegisterId');
  @override
  late final GeneratedColumn<String> cashRegisterId = GeneratedColumn<String>(
      'cash_register_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<SaleStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<SaleStatus>($SalesTable.$converterstatus);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountTotalMeta =
      const VerificationMeta('discountTotal');
  @override
  late final GeneratedColumn<double> discountTotal = GeneratedColumn<double>(
      'discount_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxTotalMeta =
      const VerificationMeta('taxTotal');
  @override
  late final GeneratedColumn<double> taxTotal = GeneratedColumn<double>(
      'tax_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _changeGivenMeta =
      const VerificationMeta('changeGiven');
  @override
  late final GeneratedColumn<double> changeGiven = GeneratedColumn<double>(
      'change_given', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ticketNumber,
        ticketLabel,
        customerId,
        userId,
        cashRegisterId,
        status,
        subtotal,
        discountTotal,
        taxTotal,
        total,
        changeGiven,
        note,
        createdAt,
        updatedAt,
        paidAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<SaleRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ticket_number')) {
      context.handle(
          _ticketNumberMeta,
          ticketNumber.isAcceptableOrUnknown(
              data['ticket_number']!, _ticketNumberMeta));
    } else if (isInserting) {
      context.missing(_ticketNumberMeta);
    }
    if (data.containsKey('ticket_label')) {
      context.handle(
          _ticketLabelMeta,
          ticketLabel.isAcceptableOrUnknown(
              data['ticket_label']!, _ticketLabelMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('cash_register_id')) {
      context.handle(
          _cashRegisterIdMeta,
          cashRegisterId.isAcceptableOrUnknown(
              data['cash_register_id']!, _cashRegisterIdMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('discount_total')) {
      context.handle(
          _discountTotalMeta,
          discountTotal.isAcceptableOrUnknown(
              data['discount_total']!, _discountTotalMeta));
    }
    if (data.containsKey('tax_total')) {
      context.handle(_taxTotalMeta,
          taxTotal.isAcceptableOrUnknown(data['tax_total']!, _taxTotalMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    }
    if (data.containsKey('change_given')) {
      context.handle(
          _changeGivenMeta,
          changeGiven.isAcceptableOrUnknown(
              data['change_given']!, _changeGivenMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ticketNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ticket_number'])!,
      ticketLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ticket_label']),
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      cashRegisterId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cash_register_id']),
      status: $SalesTable.$converterstatus.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discountTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount_total'])!,
      taxTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_total'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      changeGiven: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change_given'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at']),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SaleStatus, int, int> $converterstatus =
      const EnumIndexConverter<SaleStatus>(SaleStatus.values);
}

class SaleRow extends DataClass implements Insertable<SaleRow> {
  final String id;
  final String ticketNumber;
  final String? ticketLabel;
  final String? customerId;
  final String userId;
  final String? cashRegisterId;
  final SaleStatus status;
  final double subtotal;
  final double discountTotal;
  final double taxTotal;
  final double total;
  final double changeGiven;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;
  const SaleRow(
      {required this.id,
      required this.ticketNumber,
      this.ticketLabel,
      this.customerId,
      required this.userId,
      this.cashRegisterId,
      required this.status,
      required this.subtotal,
      required this.discountTotal,
      required this.taxTotal,
      required this.total,
      required this.changeGiven,
      this.note,
      required this.createdAt,
      required this.updatedAt,
      this.paidAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ticket_number'] = Variable<String>(ticketNumber);
    if (!nullToAbsent || ticketLabel != null) {
      map['ticket_label'] = Variable<String>(ticketLabel);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || cashRegisterId != null) {
      map['cash_register_id'] = Variable<String>(cashRegisterId);
    }
    {
      map['status'] = Variable<int>($SalesTable.$converterstatus.toSql(status));
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['discount_total'] = Variable<double>(discountTotal);
    map['tax_total'] = Variable<double>(taxTotal);
    map['total'] = Variable<double>(total);
    map['change_given'] = Variable<double>(changeGiven);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      ticketNumber: Value(ticketNumber),
      ticketLabel: ticketLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(ticketLabel),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      userId: Value(userId),
      cashRegisterId: cashRegisterId == null && nullToAbsent
          ? const Value.absent()
          : Value(cashRegisterId),
      status: Value(status),
      subtotal: Value(subtotal),
      discountTotal: Value(discountTotal),
      taxTotal: Value(taxTotal),
      total: Value(total),
      changeGiven: Value(changeGiven),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      paidAt:
          paidAt == null && nullToAbsent ? const Value.absent() : Value(paidAt),
    );
  }

  factory SaleRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleRow(
      id: serializer.fromJson<String>(json['id']),
      ticketNumber: serializer.fromJson<String>(json['ticketNumber']),
      ticketLabel: serializer.fromJson<String?>(json['ticketLabel']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      userId: serializer.fromJson<String>(json['userId']),
      cashRegisterId: serializer.fromJson<String?>(json['cashRegisterId']),
      status: $SalesTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discountTotal: serializer.fromJson<double>(json['discountTotal']),
      taxTotal: serializer.fromJson<double>(json['taxTotal']),
      total: serializer.fromJson<double>(json['total']),
      changeGiven: serializer.fromJson<double>(json['changeGiven']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ticketNumber': serializer.toJson<String>(ticketNumber),
      'ticketLabel': serializer.toJson<String?>(ticketLabel),
      'customerId': serializer.toJson<String?>(customerId),
      'userId': serializer.toJson<String>(userId),
      'cashRegisterId': serializer.toJson<String?>(cashRegisterId),
      'status':
          serializer.toJson<int>($SalesTable.$converterstatus.toJson(status)),
      'subtotal': serializer.toJson<double>(subtotal),
      'discountTotal': serializer.toJson<double>(discountTotal),
      'taxTotal': serializer.toJson<double>(taxTotal),
      'total': serializer.toJson<double>(total),
      'changeGiven': serializer.toJson<double>(changeGiven),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
    };
  }

  SaleRow copyWith(
          {String? id,
          String? ticketNumber,
          Value<String?> ticketLabel = const Value.absent(),
          Value<String?> customerId = const Value.absent(),
          String? userId,
          Value<String?> cashRegisterId = const Value.absent(),
          SaleStatus? status,
          double? subtotal,
          double? discountTotal,
          double? taxTotal,
          double? total,
          double? changeGiven,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> paidAt = const Value.absent()}) =>
      SaleRow(
        id: id ?? this.id,
        ticketNumber: ticketNumber ?? this.ticketNumber,
        ticketLabel: ticketLabel.present ? ticketLabel.value : this.ticketLabel,
        customerId: customerId.present ? customerId.value : this.customerId,
        userId: userId ?? this.userId,
        cashRegisterId:
            cashRegisterId.present ? cashRegisterId.value : this.cashRegisterId,
        status: status ?? this.status,
        subtotal: subtotal ?? this.subtotal,
        discountTotal: discountTotal ?? this.discountTotal,
        taxTotal: taxTotal ?? this.taxTotal,
        total: total ?? this.total,
        changeGiven: changeGiven ?? this.changeGiven,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        paidAt: paidAt.present ? paidAt.value : this.paidAt,
      );
  SaleRow copyWithCompanion(SalesCompanion data) {
    return SaleRow(
      id: data.id.present ? data.id.value : this.id,
      ticketNumber: data.ticketNumber.present
          ? data.ticketNumber.value
          : this.ticketNumber,
      ticketLabel:
          data.ticketLabel.present ? data.ticketLabel.value : this.ticketLabel,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      userId: data.userId.present ? data.userId.value : this.userId,
      cashRegisterId: data.cashRegisterId.present
          ? data.cashRegisterId.value
          : this.cashRegisterId,
      status: data.status.present ? data.status.value : this.status,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discountTotal: data.discountTotal.present
          ? data.discountTotal.value
          : this.discountTotal,
      taxTotal: data.taxTotal.present ? data.taxTotal.value : this.taxTotal,
      total: data.total.present ? data.total.value : this.total,
      changeGiven:
          data.changeGiven.present ? data.changeGiven.value : this.changeGiven,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleRow(')
          ..write('id: $id, ')
          ..write('ticketNumber: $ticketNumber, ')
          ..write('ticketLabel: $ticketLabel, ')
          ..write('customerId: $customerId, ')
          ..write('userId: $userId, ')
          ..write('cashRegisterId: $cashRegisterId, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountTotal: $discountTotal, ')
          ..write('taxTotal: $taxTotal, ')
          ..write('total: $total, ')
          ..write('changeGiven: $changeGiven, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ticketNumber,
      ticketLabel,
      customerId,
      userId,
      cashRegisterId,
      status,
      subtotal,
      discountTotal,
      taxTotal,
      total,
      changeGiven,
      note,
      createdAt,
      updatedAt,
      paidAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleRow &&
          other.id == this.id &&
          other.ticketNumber == this.ticketNumber &&
          other.ticketLabel == this.ticketLabel &&
          other.customerId == this.customerId &&
          other.userId == this.userId &&
          other.cashRegisterId == this.cashRegisterId &&
          other.status == this.status &&
          other.subtotal == this.subtotal &&
          other.discountTotal == this.discountTotal &&
          other.taxTotal == this.taxTotal &&
          other.total == this.total &&
          other.changeGiven == this.changeGiven &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.paidAt == this.paidAt);
}

class SalesCompanion extends UpdateCompanion<SaleRow> {
  final Value<String> id;
  final Value<String> ticketNumber;
  final Value<String?> ticketLabel;
  final Value<String?> customerId;
  final Value<String> userId;
  final Value<String?> cashRegisterId;
  final Value<SaleStatus> status;
  final Value<double> subtotal;
  final Value<double> discountTotal;
  final Value<double> taxTotal;
  final Value<double> total;
  final Value<double> changeGiven;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> paidAt;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.ticketNumber = const Value.absent(),
    this.ticketLabel = const Value.absent(),
    this.customerId = const Value.absent(),
    this.userId = const Value.absent(),
    this.cashRegisterId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountTotal = const Value.absent(),
    this.taxTotal = const Value.absent(),
    this.total = const Value.absent(),
    this.changeGiven = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required String ticketNumber,
    this.ticketLabel = const Value.absent(),
    this.customerId = const Value.absent(),
    required String userId,
    this.cashRegisterId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountTotal = const Value.absent(),
    this.taxTotal = const Value.absent(),
    this.total = const Value.absent(),
    this.changeGiven = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : ticketNumber = Value(ticketNumber),
        userId = Value(userId);
  static Insertable<SaleRow> custom({
    Expression<String>? id,
    Expression<String>? ticketNumber,
    Expression<String>? ticketLabel,
    Expression<String>? customerId,
    Expression<String>? userId,
    Expression<String>? cashRegisterId,
    Expression<int>? status,
    Expression<double>? subtotal,
    Expression<double>? discountTotal,
    Expression<double>? taxTotal,
    Expression<double>? total,
    Expression<double>? changeGiven,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? paidAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ticketNumber != null) 'ticket_number': ticketNumber,
      if (ticketLabel != null) 'ticket_label': ticketLabel,
      if (customerId != null) 'customer_id': customerId,
      if (userId != null) 'user_id': userId,
      if (cashRegisterId != null) 'cash_register_id': cashRegisterId,
      if (status != null) 'status': status,
      if (subtotal != null) 'subtotal': subtotal,
      if (discountTotal != null) 'discount_total': discountTotal,
      if (taxTotal != null) 'tax_total': taxTotal,
      if (total != null) 'total': total,
      if (changeGiven != null) 'change_given': changeGiven,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (paidAt != null) 'paid_at': paidAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith(
      {Value<String>? id,
      Value<String>? ticketNumber,
      Value<String?>? ticketLabel,
      Value<String?>? customerId,
      Value<String>? userId,
      Value<String?>? cashRegisterId,
      Value<SaleStatus>? status,
      Value<double>? subtotal,
      Value<double>? discountTotal,
      Value<double>? taxTotal,
      Value<double>? total,
      Value<double>? changeGiven,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? paidAt,
      Value<int>? rowid}) {
    return SalesCompanion(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      ticketLabel: ticketLabel ?? this.ticketLabel,
      customerId: customerId ?? this.customerId,
      userId: userId ?? this.userId,
      cashRegisterId: cashRegisterId ?? this.cashRegisterId,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discountTotal: discountTotal ?? this.discountTotal,
      taxTotal: taxTotal ?? this.taxTotal,
      total: total ?? this.total,
      changeGiven: changeGiven ?? this.changeGiven,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paidAt: paidAt ?? this.paidAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ticketNumber.present) {
      map['ticket_number'] = Variable<String>(ticketNumber.value);
    }
    if (ticketLabel.present) {
      map['ticket_label'] = Variable<String>(ticketLabel.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (cashRegisterId.present) {
      map['cash_register_id'] = Variable<String>(cashRegisterId.value);
    }
    if (status.present) {
      map['status'] =
          Variable<int>($SalesTable.$converterstatus.toSql(status.value));
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discountTotal.present) {
      map['discount_total'] = Variable<double>(discountTotal.value);
    }
    if (taxTotal.present) {
      map['tax_total'] = Variable<double>(taxTotal.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (changeGiven.present) {
      map['change_given'] = Variable<double>(changeGiven.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('ticketNumber: $ticketNumber, ')
          ..write('ticketLabel: $ticketLabel, ')
          ..write('customerId: $customerId, ')
          ..write('userId: $userId, ')
          ..write('cashRegisterId: $cashRegisterId, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountTotal: $discountTotal, ')
          ..write('taxTotal: $taxTotal, ')
          ..write('total: $total, ')
          ..write('changeGiven: $changeGiven, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('paidAt: $paidAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sales (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _variantIdMeta =
      const VerificationMeta('variantId');
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
      'variant_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_variants (id)'));
  static const VerificationMeta _productNameSnapshotMeta =
      const VerificationMeta('productNameSnapshot');
  @override
  late final GeneratedColumn<String> productNameSnapshot =
      GeneratedColumn<String>('product_name_snapshot', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxRateMeta =
      const VerificationMeta('taxRate');
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
      'tax_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReturnMeta =
      const VerificationMeta('isReturn');
  @override
  late final GeneratedColumn<bool> isReturn = GeneratedColumn<bool>(
      'is_return', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_return" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _returnReasonMeta =
      const VerificationMeta('returnReason');
  @override
  late final GeneratedColumn<String> returnReason = GeneratedColumn<String>(
      'return_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _returnedFromTicketMeta =
      const VerificationMeta('returnedFromTicket');
  @override
  late final GeneratedColumn<String> returnedFromTicket =
      GeneratedColumn<String>('returned_from_ticket', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saleId,
        productId,
        variantId,
        productNameSnapshot,
        unitPrice,
        quantity,
        discount,
        taxRate,
        lineTotal,
        note,
        isReturn,
        returnReason,
        returnedFromTicket
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItemRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta));
    }
    if (data.containsKey('product_name_snapshot')) {
      context.handle(
          _productNameSnapshotMeta,
          productNameSnapshot.isAcceptableOrUnknown(
              data['product_name_snapshot']!, _productNameSnapshotMeta));
    } else if (isInserting) {
      context.missing(_productNameSnapshotMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta));
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_return')) {
      context.handle(_isReturnMeta,
          isReturn.isAcceptableOrUnknown(data['is_return']!, _isReturnMeta));
    }
    if (data.containsKey('return_reason')) {
      context.handle(
          _returnReasonMeta,
          returnReason.isAcceptableOrUnknown(
              data['return_reason']!, _returnReasonMeta));
    }
    if (data.containsKey('returned_from_ticket')) {
      context.handle(
          _returnedFromTicketMeta,
          returnedFromTicket.isAcceptableOrUnknown(
              data['returned_from_ticket']!, _returnedFromTicketMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItemRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      variantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variant_id']),
      productNameSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}product_name_snapshot'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      taxRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_rate'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      isReturn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_return'])!,
      returnReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}return_reason']),
      returnedFromTicket: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}returned_from_ticket']),
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItemRow extends DataClass implements Insertable<SaleItemRow> {
  final String id;
  final String saleId;
  final String productId;
  final String? variantId;
  final String productNameSnapshot;
  final double unitPrice;
  final double quantity;
  final double discount;
  final double taxRate;
  final double lineTotal;
  final String? note;
  final bool isReturn;
  final String? returnReason;
  final String? returnedFromTicket;
  const SaleItemRow(
      {required this.id,
      required this.saleId,
      required this.productId,
      this.variantId,
      required this.productNameSnapshot,
      required this.unitPrice,
      required this.quantity,
      required this.discount,
      required this.taxRate,
      required this.lineTotal,
      this.note,
      required this.isReturn,
      this.returnReason,
      this.returnedFromTicket});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    map['product_name_snapshot'] = Variable<String>(productNameSnapshot);
    map['unit_price'] = Variable<double>(unitPrice);
    map['quantity'] = Variable<double>(quantity);
    map['discount'] = Variable<double>(discount);
    map['tax_rate'] = Variable<double>(taxRate);
    map['line_total'] = Variable<double>(lineTotal);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_return'] = Variable<bool>(isReturn);
    if (!nullToAbsent || returnReason != null) {
      map['return_reason'] = Variable<String>(returnReason);
    }
    if (!nullToAbsent || returnedFromTicket != null) {
      map['returned_from_ticket'] = Variable<String>(returnedFromTicket);
    }
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      productNameSnapshot: Value(productNameSnapshot),
      unitPrice: Value(unitPrice),
      quantity: Value(quantity),
      discount: Value(discount),
      taxRate: Value(taxRate),
      lineTotal: Value(lineTotal),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isReturn: Value(isReturn),
      returnReason: returnReason == null && nullToAbsent
          ? const Value.absent()
          : Value(returnReason),
      returnedFromTicket: returnedFromTicket == null && nullToAbsent
          ? const Value.absent()
          : Value(returnedFromTicket),
    );
  }

  factory SaleItemRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItemRow(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      variantId: serializer.fromJson<String?>(json['variantId']),
      productNameSnapshot:
          serializer.fromJson<String>(json['productNameSnapshot']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      quantity: serializer.fromJson<double>(json['quantity']),
      discount: serializer.fromJson<double>(json['discount']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      note: serializer.fromJson<String?>(json['note']),
      isReturn: serializer.fromJson<bool>(json['isReturn']),
      returnReason: serializer.fromJson<String?>(json['returnReason']),
      returnedFromTicket:
          serializer.fromJson<String?>(json['returnedFromTicket']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'variantId': serializer.toJson<String?>(variantId),
      'productNameSnapshot': serializer.toJson<String>(productNameSnapshot),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'quantity': serializer.toJson<double>(quantity),
      'discount': serializer.toJson<double>(discount),
      'taxRate': serializer.toJson<double>(taxRate),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'note': serializer.toJson<String?>(note),
      'isReturn': serializer.toJson<bool>(isReturn),
      'returnReason': serializer.toJson<String?>(returnReason),
      'returnedFromTicket': serializer.toJson<String?>(returnedFromTicket),
    };
  }

  SaleItemRow copyWith(
          {String? id,
          String? saleId,
          String? productId,
          Value<String?> variantId = const Value.absent(),
          String? productNameSnapshot,
          double? unitPrice,
          double? quantity,
          double? discount,
          double? taxRate,
          double? lineTotal,
          Value<String?> note = const Value.absent(),
          bool? isReturn,
          Value<String?> returnReason = const Value.absent(),
          Value<String?> returnedFromTicket = const Value.absent()}) =>
      SaleItemRow(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        variantId: variantId.present ? variantId.value : this.variantId,
        productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        discount: discount ?? this.discount,
        taxRate: taxRate ?? this.taxRate,
        lineTotal: lineTotal ?? this.lineTotal,
        note: note.present ? note.value : this.note,
        isReturn: isReturn ?? this.isReturn,
        returnReason:
            returnReason.present ? returnReason.value : this.returnReason,
        returnedFromTicket: returnedFromTicket.present
            ? returnedFromTicket.value
            : this.returnedFromTicket,
      );
  SaleItemRow copyWithCompanion(SaleItemsCompanion data) {
    return SaleItemRow(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      productNameSnapshot: data.productNameSnapshot.present
          ? data.productNameSnapshot.value
          : this.productNameSnapshot,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      discount: data.discount.present ? data.discount.value : this.discount,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      note: data.note.present ? data.note.value : this.note,
      isReturn: data.isReturn.present ? data.isReturn.value : this.isReturn,
      returnReason: data.returnReason.present
          ? data.returnReason.value
          : this.returnReason,
      returnedFromTicket: data.returnedFromTicket.present
          ? data.returnedFromTicket.value
          : this.returnedFromTicket,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemRow(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('discount: $discount, ')
          ..write('taxRate: $taxRate, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('note: $note, ')
          ..write('isReturn: $isReturn, ')
          ..write('returnReason: $returnReason, ')
          ..write('returnedFromTicket: $returnedFromTicket')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      saleId,
      productId,
      variantId,
      productNameSnapshot,
      unitPrice,
      quantity,
      discount,
      taxRate,
      lineTotal,
      note,
      isReturn,
      returnReason,
      returnedFromTicket);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItemRow &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.variantId == this.variantId &&
          other.productNameSnapshot == this.productNameSnapshot &&
          other.unitPrice == this.unitPrice &&
          other.quantity == this.quantity &&
          other.discount == this.discount &&
          other.taxRate == this.taxRate &&
          other.lineTotal == this.lineTotal &&
          other.note == this.note &&
          other.isReturn == this.isReturn &&
          other.returnReason == this.returnReason &&
          other.returnedFromTicket == this.returnedFromTicket);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItemRow> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<String?> variantId;
  final Value<String> productNameSnapshot;
  final Value<double> unitPrice;
  final Value<double> quantity;
  final Value<double> discount;
  final Value<double> taxRate;
  final Value<double> lineTotal;
  final Value<String?> note;
  final Value<bool> isReturn;
  final Value<String?> returnReason;
  final Value<String?> returnedFromTicket;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.productNameSnapshot = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.discount = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.note = const Value.absent(),
    this.isReturn = const Value.absent(),
    this.returnReason = const Value.absent(),
    this.returnedFromTicket = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required String saleId,
    required String productId,
    this.variantId = const Value.absent(),
    required String productNameSnapshot,
    required double unitPrice,
    required double quantity,
    this.discount = const Value.absent(),
    this.taxRate = const Value.absent(),
    required double lineTotal,
    this.note = const Value.absent(),
    this.isReturn = const Value.absent(),
    this.returnReason = const Value.absent(),
    this.returnedFromTicket = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : saleId = Value(saleId),
        productId = Value(productId),
        productNameSnapshot = Value(productNameSnapshot),
        unitPrice = Value(unitPrice),
        quantity = Value(quantity),
        lineTotal = Value(lineTotal);
  static Insertable<SaleItemRow> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? variantId,
    Expression<String>? productNameSnapshot,
    Expression<double>? unitPrice,
    Expression<double>? quantity,
    Expression<double>? discount,
    Expression<double>? taxRate,
    Expression<double>? lineTotal,
    Expression<String>? note,
    Expression<bool>? isReturn,
    Expression<String>? returnReason,
    Expression<String>? returnedFromTicket,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      if (productNameSnapshot != null)
        'product_name_snapshot': productNameSnapshot,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (quantity != null) 'quantity': quantity,
      if (discount != null) 'discount': discount,
      if (taxRate != null) 'tax_rate': taxRate,
      if (lineTotal != null) 'line_total': lineTotal,
      if (note != null) 'note': note,
      if (isReturn != null) 'is_return': isReturn,
      if (returnReason != null) 'return_reason': returnReason,
      if (returnedFromTicket != null)
        'returned_from_ticket': returnedFromTicket,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? saleId,
      Value<String>? productId,
      Value<String?>? variantId,
      Value<String>? productNameSnapshot,
      Value<double>? unitPrice,
      Value<double>? quantity,
      Value<double>? discount,
      Value<double>? taxRate,
      Value<double>? lineTotal,
      Value<String?>? note,
      Value<bool>? isReturn,
      Value<String?>? returnReason,
      Value<String?>? returnedFromTicket,
      Value<int>? rowid}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      taxRate: taxRate ?? this.taxRate,
      lineTotal: lineTotal ?? this.lineTotal,
      note: note ?? this.note,
      isReturn: isReturn ?? this.isReturn,
      returnReason: returnReason ?? this.returnReason,
      returnedFromTicket: returnedFromTicket ?? this.returnedFromTicket,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (productNameSnapshot.present) {
      map['product_name_snapshot'] =
          Variable<String>(productNameSnapshot.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isReturn.present) {
      map['is_return'] = Variable<bool>(isReturn.value);
    }
    if (returnReason.present) {
      map['return_reason'] = Variable<String>(returnReason.value);
    }
    if (returnedFromTicket.present) {
      map['returned_from_ticket'] = Variable<String>(returnedFromTicket.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('discount: $discount, ')
          ..write('taxRate: $taxRate, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('note: $note, ')
          ..write('isReturn: $isReturn, ')
          ..write('returnReason: $returnReason, ')
          ..write('returnedFromTicket: $returnedFromTicket, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments
    with TableInfo<$PaymentsTable, PaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sales (id)'));
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMethod, int> method =
      GeneratedColumn<int>('method', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<PaymentMethod>($PaymentsTable.$convertermethod);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns =>
      [id, saleId, method, amount, reference, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    context.handle(_methodMeta, const VerificationResult.success());
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      method: $PaymentsTable.$convertermethod.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}method'])!),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentMethod, int, int> $convertermethod =
      const EnumIndexConverter<PaymentMethod>(PaymentMethod.values);
}

class PaymentRow extends DataClass implements Insertable<PaymentRow> {
  final String id;
  final String saleId;
  final PaymentMethod method;
  final double amount;
  final String? reference;
  final DateTime createdAt;
  const PaymentRow(
      {required this.id,
      required this.saleId,
      required this.method,
      required this.amount,
      this.reference,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    {
      map['method'] =
          Variable<int>($PaymentsTable.$convertermethod.toSql(method));
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      method: Value(method),
      amount: Value(amount),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentRow(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      method: $PaymentsTable.$convertermethod
          .fromJson(serializer.fromJson<int>(json['method'])),
      amount: serializer.fromJson<double>(json['amount']),
      reference: serializer.fromJson<String?>(json['reference']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'method': serializer
          .toJson<int>($PaymentsTable.$convertermethod.toJson(method)),
      'amount': serializer.toJson<double>(amount),
      'reference': serializer.toJson<String?>(reference),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentRow copyWith(
          {String? id,
          String? saleId,
          PaymentMethod? method,
          double? amount,
          Value<String?> reference = const Value.absent(),
          DateTime? createdAt}) =>
      PaymentRow(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        method: method ?? this.method,
        amount: amount ?? this.amount,
        reference: reference.present ? reference.value : this.reference,
        createdAt: createdAt ?? this.createdAt,
      );
  PaymentRow copyWithCompanion(PaymentsCompanion data) {
    return PaymentRow(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      reference: data.reference.present ? data.reference.value : this.reference,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentRow(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('reference: $reference, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, method, amount, reference, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentRow &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.reference == this.reference &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<PaymentRow> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<PaymentMethod> method;
  final Value<double> amount;
  final Value<String?> reference;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.reference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required String saleId,
    required PaymentMethod method,
    required double amount,
    this.reference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : saleId = Value(saleId),
        method = Value(method),
        amount = Value(amount);
  static Insertable<PaymentRow> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<int>? method,
    Expression<double>? amount,
    Expression<String>? reference,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (reference != null) 'reference': reference,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? saleId,
      Value<PaymentMethod>? method,
      Value<double>? amount,
      Value<String?>? reference,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (method.present) {
      map['method'] =
          Variable<int>($PaymentsTable.$convertermethod.toSql(method.value));
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('reference: $reference, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashRegistersTable extends CashRegisters
    with TableInfo<$CashRegistersTable, CashRegisterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashRegistersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _shiftLabelMeta =
      const VerificationMeta('shiftLabel');
  @override
  late final GeneratedColumn<String> shiftLabel = GeneratedColumn<String>(
      'shift_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _openingAmountMeta =
      const VerificationMeta('openingAmount');
  @override
  late final GeneratedColumn<double> openingAmount = GeneratedColumn<double>(
      'opening_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _expectedClosingAmountMeta =
      const VerificationMeta('expectedClosingAmount');
  @override
  late final GeneratedColumn<double> expectedClosingAmount =
      GeneratedColumn<double>('expected_closing_amount', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _countedClosingAmountMeta =
      const VerificationMeta('countedClosingAmount');
  @override
  late final GeneratedColumn<double> countedClosingAmount =
      GeneratedColumn<double>('counted_closing_amount', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _differenceMeta =
      const VerificationMeta('difference');
  @override
  late final GeneratedColumn<double> difference = GeneratedColumn<double>(
      'difference', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<CashRegisterStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<CashRegisterStatus>(
              $CashRegistersTable.$converterstatus);
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        shiftLabel,
        openingAmount,
        expectedClosingAmount,
        countedClosingAmount,
        difference,
        status,
        openedAt,
        closedAt,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_registers';
  @override
  VerificationContext validateIntegrity(Insertable<CashRegisterRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('shift_label')) {
      context.handle(
          _shiftLabelMeta,
          shiftLabel.isAcceptableOrUnknown(
              data['shift_label']!, _shiftLabelMeta));
    }
    if (data.containsKey('opening_amount')) {
      context.handle(
          _openingAmountMeta,
          openingAmount.isAcceptableOrUnknown(
              data['opening_amount']!, _openingAmountMeta));
    } else if (isInserting) {
      context.missing(_openingAmountMeta);
    }
    if (data.containsKey('expected_closing_amount')) {
      context.handle(
          _expectedClosingAmountMeta,
          expectedClosingAmount.isAcceptableOrUnknown(
              data['expected_closing_amount']!, _expectedClosingAmountMeta));
    }
    if (data.containsKey('counted_closing_amount')) {
      context.handle(
          _countedClosingAmountMeta,
          countedClosingAmount.isAcceptableOrUnknown(
              data['counted_closing_amount']!, _countedClosingAmountMeta));
    }
    if (data.containsKey('difference')) {
      context.handle(
          _differenceMeta,
          difference.isAcceptableOrUnknown(
              data['difference']!, _differenceMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashRegisterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashRegisterRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      shiftLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shift_label']),
      openingAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}opening_amount'])!,
      expectedClosingAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}expected_closing_amount']),
      countedClosingAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}counted_closing_amount']),
      difference: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difference']),
      status: $CashRegistersTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $CashRegistersTable createAlias(String alias) {
    return $CashRegistersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CashRegisterStatus, int, int> $converterstatus =
      const EnumIndexConverter<CashRegisterStatus>(CashRegisterStatus.values);
}

class CashRegisterRow extends DataClass implements Insertable<CashRegisterRow> {
  final String id;
  final String userId;
  final String? shiftLabel;
  final double openingAmount;
  final double? expectedClosingAmount;
  final double? countedClosingAmount;
  final double? difference;
  final CashRegisterStatus status;
  final DateTime openedAt;
  final DateTime? closedAt;
  final String? note;
  const CashRegisterRow(
      {required this.id,
      required this.userId,
      this.shiftLabel,
      required this.openingAmount,
      this.expectedClosingAmount,
      this.countedClosingAmount,
      this.difference,
      required this.status,
      required this.openedAt,
      this.closedAt,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || shiftLabel != null) {
      map['shift_label'] = Variable<String>(shiftLabel);
    }
    map['opening_amount'] = Variable<double>(openingAmount);
    if (!nullToAbsent || expectedClosingAmount != null) {
      map['expected_closing_amount'] = Variable<double>(expectedClosingAmount);
    }
    if (!nullToAbsent || countedClosingAmount != null) {
      map['counted_closing_amount'] = Variable<double>(countedClosingAmount);
    }
    if (!nullToAbsent || difference != null) {
      map['difference'] = Variable<double>(difference);
    }
    {
      map['status'] =
          Variable<int>($CashRegistersTable.$converterstatus.toSql(status));
    }
    map['opened_at'] = Variable<DateTime>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CashRegistersCompanion toCompanion(bool nullToAbsent) {
    return CashRegistersCompanion(
      id: Value(id),
      userId: Value(userId),
      shiftLabel: shiftLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftLabel),
      openingAmount: Value(openingAmount),
      expectedClosingAmount: expectedClosingAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedClosingAmount),
      countedClosingAmount: countedClosingAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(countedClosingAmount),
      difference: difference == null && nullToAbsent
          ? const Value.absent()
          : Value(difference),
      status: Value(status),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory CashRegisterRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashRegisterRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      shiftLabel: serializer.fromJson<String?>(json['shiftLabel']),
      openingAmount: serializer.fromJson<double>(json['openingAmount']),
      expectedClosingAmount:
          serializer.fromJson<double?>(json['expectedClosingAmount']),
      countedClosingAmount:
          serializer.fromJson<double?>(json['countedClosingAmount']),
      difference: serializer.fromJson<double?>(json['difference']),
      status: $CashRegistersTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'shiftLabel': serializer.toJson<String?>(shiftLabel),
      'openingAmount': serializer.toJson<double>(openingAmount),
      'expectedClosingAmount':
          serializer.toJson<double?>(expectedClosingAmount),
      'countedClosingAmount': serializer.toJson<double?>(countedClosingAmount),
      'difference': serializer.toJson<double?>(difference),
      'status': serializer
          .toJson<int>($CashRegistersTable.$converterstatus.toJson(status)),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  CashRegisterRow copyWith(
          {String? id,
          String? userId,
          Value<String?> shiftLabel = const Value.absent(),
          double? openingAmount,
          Value<double?> expectedClosingAmount = const Value.absent(),
          Value<double?> countedClosingAmount = const Value.absent(),
          Value<double?> difference = const Value.absent(),
          CashRegisterStatus? status,
          DateTime? openedAt,
          Value<DateTime?> closedAt = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      CashRegisterRow(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        shiftLabel: shiftLabel.present ? shiftLabel.value : this.shiftLabel,
        openingAmount: openingAmount ?? this.openingAmount,
        expectedClosingAmount: expectedClosingAmount.present
            ? expectedClosingAmount.value
            : this.expectedClosingAmount,
        countedClosingAmount: countedClosingAmount.present
            ? countedClosingAmount.value
            : this.countedClosingAmount,
        difference: difference.present ? difference.value : this.difference,
        status: status ?? this.status,
        openedAt: openedAt ?? this.openedAt,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
        note: note.present ? note.value : this.note,
      );
  CashRegisterRow copyWithCompanion(CashRegistersCompanion data) {
    return CashRegisterRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      shiftLabel:
          data.shiftLabel.present ? data.shiftLabel.value : this.shiftLabel,
      openingAmount: data.openingAmount.present
          ? data.openingAmount.value
          : this.openingAmount,
      expectedClosingAmount: data.expectedClosingAmount.present
          ? data.expectedClosingAmount.value
          : this.expectedClosingAmount,
      countedClosingAmount: data.countedClosingAmount.present
          ? data.countedClosingAmount.value
          : this.countedClosingAmount,
      difference:
          data.difference.present ? data.difference.value : this.difference,
      status: data.status.present ? data.status.value : this.status,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashRegisterRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('shiftLabel: $shiftLabel, ')
          ..write('openingAmount: $openingAmount, ')
          ..write('expectedClosingAmount: $expectedClosingAmount, ')
          ..write('countedClosingAmount: $countedClosingAmount, ')
          ..write('difference: $difference, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      shiftLabel,
      openingAmount,
      expectedClosingAmount,
      countedClosingAmount,
      difference,
      status,
      openedAt,
      closedAt,
      note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashRegisterRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.shiftLabel == this.shiftLabel &&
          other.openingAmount == this.openingAmount &&
          other.expectedClosingAmount == this.expectedClosingAmount &&
          other.countedClosingAmount == this.countedClosingAmount &&
          other.difference == this.difference &&
          other.status == this.status &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt &&
          other.note == this.note);
}

class CashRegistersCompanion extends UpdateCompanion<CashRegisterRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> shiftLabel;
  final Value<double> openingAmount;
  final Value<double?> expectedClosingAmount;
  final Value<double?> countedClosingAmount;
  final Value<double?> difference;
  final Value<CashRegisterStatus> status;
  final Value<DateTime> openedAt;
  final Value<DateTime?> closedAt;
  final Value<String?> note;
  final Value<int> rowid;
  const CashRegistersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.shiftLabel = const Value.absent(),
    this.openingAmount = const Value.absent(),
    this.expectedClosingAmount = const Value.absent(),
    this.countedClosingAmount = const Value.absent(),
    this.difference = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashRegistersCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.shiftLabel = const Value.absent(),
    required double openingAmount,
    this.expectedClosingAmount = const Value.absent(),
    this.countedClosingAmount = const Value.absent(),
    this.difference = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        openingAmount = Value(openingAmount);
  static Insertable<CashRegisterRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? shiftLabel,
    Expression<double>? openingAmount,
    Expression<double>? expectedClosingAmount,
    Expression<double>? countedClosingAmount,
    Expression<double>? difference,
    Expression<int>? status,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? closedAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (shiftLabel != null) 'shift_label': shiftLabel,
      if (openingAmount != null) 'opening_amount': openingAmount,
      if (expectedClosingAmount != null)
        'expected_closing_amount': expectedClosingAmount,
      if (countedClosingAmount != null)
        'counted_closing_amount': countedClosingAmount,
      if (difference != null) 'difference': difference,
      if (status != null) 'status': status,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashRegistersCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String?>? shiftLabel,
      Value<double>? openingAmount,
      Value<double?>? expectedClosingAmount,
      Value<double?>? countedClosingAmount,
      Value<double?>? difference,
      Value<CashRegisterStatus>? status,
      Value<DateTime>? openedAt,
      Value<DateTime?>? closedAt,
      Value<String?>? note,
      Value<int>? rowid}) {
    return CashRegistersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shiftLabel: shiftLabel ?? this.shiftLabel,
      openingAmount: openingAmount ?? this.openingAmount,
      expectedClosingAmount:
          expectedClosingAmount ?? this.expectedClosingAmount,
      countedClosingAmount: countedClosingAmount ?? this.countedClosingAmount,
      difference: difference ?? this.difference,
      status: status ?? this.status,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (shiftLabel.present) {
      map['shift_label'] = Variable<String>(shiftLabel.value);
    }
    if (openingAmount.present) {
      map['opening_amount'] = Variable<double>(openingAmount.value);
    }
    if (expectedClosingAmount.present) {
      map['expected_closing_amount'] =
          Variable<double>(expectedClosingAmount.value);
    }
    if (countedClosingAmount.present) {
      map['counted_closing_amount'] =
          Variable<double>(countedClosingAmount.value);
    }
    if (difference.present) {
      map['difference'] = Variable<double>(difference.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $CashRegistersTable.$converterstatus.toSql(status.value));
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashRegistersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('shiftLabel: $shiftLabel, ')
          ..write('openingAmount: $openingAmount, ')
          ..write('expectedClosingAmount: $expectedClosingAmount, ')
          ..write('countedClosingAmount: $countedClosingAmount, ')
          ..write('difference: $difference, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashMovementsTable extends CashMovements
    with TableInfo<$CashMovementsTable, CashMovementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _cashRegisterIdMeta =
      const VerificationMeta('cashRegisterId');
  @override
  late final GeneratedColumn<String> cashRegisterId = GeneratedColumn<String>(
      'cash_register_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cash_registers (id)'));
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<CashMovementType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<CashMovementType>($CashMovementsTable.$convertertype);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<int> method = GeneratedColumn<int>(
      'method', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cashRegisterId,
        saleId,
        type,
        amount,
        method,
        description,
        userId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_movements';
  @override
  VerificationContext validateIntegrity(Insertable<CashMovementRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cash_register_id')) {
      context.handle(
          _cashRegisterIdMeta,
          cashRegisterId.isAcceptableOrUnknown(
              data['cash_register_id']!, _cashRegisterIdMeta));
    } else if (isInserting) {
      context.missing(_cashRegisterIdMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashMovementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashMovementRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cashRegisterId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cash_register_id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id']),
      type: $CashMovementsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}method']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CashMovementsTable createAlias(String alias) {
    return $CashMovementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CashMovementType, int, int> $convertertype =
      const EnumIndexConverter<CashMovementType>(CashMovementType.values);
}

class CashMovementRow extends DataClass implements Insertable<CashMovementRow> {
  final String id;
  final String cashRegisterId;
  final String? saleId;
  final CashMovementType type;
  final double amount;
  final int? method;
  final String? description;
  final String userId;
  final DateTime createdAt;
  const CashMovementRow(
      {required this.id,
      required this.cashRegisterId,
      this.saleId,
      required this.type,
      required this.amount,
      this.method,
      this.description,
      required this.userId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cash_register_id'] = Variable<String>(cashRegisterId);
    if (!nullToAbsent || saleId != null) {
      map['sale_id'] = Variable<String>(saleId);
    }
    {
      map['type'] =
          Variable<int>($CashMovementsTable.$convertertype.toSql(type));
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<int>(method);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CashMovementsCompanion toCompanion(bool nullToAbsent) {
    return CashMovementsCompanion(
      id: Value(id),
      cashRegisterId: Value(cashRegisterId),
      saleId:
          saleId == null && nullToAbsent ? const Value.absent() : Value(saleId),
      type: Value(type),
      amount: Value(amount),
      method:
          method == null && nullToAbsent ? const Value.absent() : Value(method),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      userId: Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory CashMovementRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashMovementRow(
      id: serializer.fromJson<String>(json['id']),
      cashRegisterId: serializer.fromJson<String>(json['cashRegisterId']),
      saleId: serializer.fromJson<String?>(json['saleId']),
      type: $CashMovementsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      amount: serializer.fromJson<double>(json['amount']),
      method: serializer.fromJson<int?>(json['method']),
      description: serializer.fromJson<String?>(json['description']),
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cashRegisterId': serializer.toJson<String>(cashRegisterId),
      'saleId': serializer.toJson<String?>(saleId),
      'type': serializer
          .toJson<int>($CashMovementsTable.$convertertype.toJson(type)),
      'amount': serializer.toJson<double>(amount),
      'method': serializer.toJson<int?>(method),
      'description': serializer.toJson<String?>(description),
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CashMovementRow copyWith(
          {String? id,
          String? cashRegisterId,
          Value<String?> saleId = const Value.absent(),
          CashMovementType? type,
          double? amount,
          Value<int?> method = const Value.absent(),
          Value<String?> description = const Value.absent(),
          String? userId,
          DateTime? createdAt}) =>
      CashMovementRow(
        id: id ?? this.id,
        cashRegisterId: cashRegisterId ?? this.cashRegisterId,
        saleId: saleId.present ? saleId.value : this.saleId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        method: method.present ? method.value : this.method,
        description: description.present ? description.value : this.description,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
      );
  CashMovementRow copyWithCompanion(CashMovementsCompanion data) {
    return CashMovementRow(
      id: data.id.present ? data.id.value : this.id,
      cashRegisterId: data.cashRegisterId.present
          ? data.cashRegisterId.value
          : this.cashRegisterId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      method: data.method.present ? data.method.value : this.method,
      description:
          data.description.present ? data.description.value : this.description,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashMovementRow(')
          ..write('id: $id, ')
          ..write('cashRegisterId: $cashRegisterId, ')
          ..write('saleId: $saleId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('description: $description, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cashRegisterId, saleId, type, amount,
      method, description, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashMovementRow &&
          other.id == this.id &&
          other.cashRegisterId == this.cashRegisterId &&
          other.saleId == this.saleId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.method == this.method &&
          other.description == this.description &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class CashMovementsCompanion extends UpdateCompanion<CashMovementRow> {
  final Value<String> id;
  final Value<String> cashRegisterId;
  final Value<String?> saleId;
  final Value<CashMovementType> type;
  final Value<double> amount;
  final Value<int?> method;
  final Value<String?> description;
  final Value<String> userId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CashMovementsCompanion({
    this.id = const Value.absent(),
    this.cashRegisterId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.method = const Value.absent(),
    this.description = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashMovementsCompanion.insert({
    this.id = const Value.absent(),
    required String cashRegisterId,
    this.saleId = const Value.absent(),
    required CashMovementType type,
    required double amount,
    this.method = const Value.absent(),
    this.description = const Value.absent(),
    required String userId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : cashRegisterId = Value(cashRegisterId),
        type = Value(type),
        amount = Value(amount),
        userId = Value(userId);
  static Insertable<CashMovementRow> custom({
    Expression<String>? id,
    Expression<String>? cashRegisterId,
    Expression<String>? saleId,
    Expression<int>? type,
    Expression<double>? amount,
    Expression<int>? method,
    Expression<String>? description,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cashRegisterId != null) 'cash_register_id': cashRegisterId,
      if (saleId != null) 'sale_id': saleId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (method != null) 'method': method,
      if (description != null) 'description': description,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashMovementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? cashRegisterId,
      Value<String?>? saleId,
      Value<CashMovementType>? type,
      Value<double>? amount,
      Value<int?>? method,
      Value<String?>? description,
      Value<String>? userId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CashMovementsCompanion(
      id: id ?? this.id,
      cashRegisterId: cashRegisterId ?? this.cashRegisterId,
      saleId: saleId ?? this.saleId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cashRegisterId.present) {
      map['cash_register_id'] = Variable<String>(cashRegisterId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($CashMovementsTable.$convertertype.toSql(type.value));
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (method.present) {
      map['method'] = Variable<int>(method.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashMovementsCompanion(')
          ..write('id: $id, ')
          ..write('cashRegisterId: $cashRegisterId, ')
          ..write('saleId: $saleId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('description: $description, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryMovementsTable extends InventoryMovements
    with TableInfo<$InventoryMovementsTable, InventoryMovementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _variantIdMeta =
      const VerificationMeta('variantId');
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
      'variant_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_variants (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<InventoryMovementType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<InventoryMovementType>(
              $InventoryMovementsTable.$convertertype);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stockBeforeMeta =
      const VerificationMeta('stockBefore');
  @override
  late final GeneratedColumn<double> stockBefore = GeneratedColumn<double>(
      'stock_before', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stockAfterMeta =
      const VerificationMeta('stockAfter');
  @override
  late final GeneratedColumn<double> stockAfter = GeneratedColumn<double>(
      'stock_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns => [
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
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_movements';
  @override
  VerificationContext validateIntegrity(
      Insertable<InventoryMovementRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('stock_before')) {
      context.handle(
          _stockBeforeMeta,
          stockBefore.isAcceptableOrUnknown(
              data['stock_before']!, _stockBeforeMeta));
    } else if (isInserting) {
      context.missing(_stockBeforeMeta);
    }
    if (data.containsKey('stock_after')) {
      context.handle(
          _stockAfterMeta,
          stockAfter.isAcceptableOrUnknown(
              data['stock_after']!, _stockAfterMeta));
    } else if (isInserting) {
      context.missing(_stockAfterMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryMovementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryMovementRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      variantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variant_id']),
      type: $InventoryMovementsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      stockBefore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_before'])!,
      stockAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_after'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InventoryMovementsTable createAlias(String alias) {
    return $InventoryMovementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InventoryMovementType, int, int> $convertertype =
      const EnumIndexConverter<InventoryMovementType>(
          InventoryMovementType.values);
}

class InventoryMovementRow extends DataClass
    implements Insertable<InventoryMovementRow> {
  final String id;
  final String productId;
  final String? variantId;
  final InventoryMovementType type;
  final double quantity;
  final double stockBefore;
  final double stockAfter;
  final String? reason;
  final String? referenceId;
  final String userId;
  final DateTime createdAt;
  const InventoryMovementRow(
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
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    {
      map['type'] =
          Variable<int>($InventoryMovementsTable.$convertertype.toSql(type));
    }
    map['quantity'] = Variable<double>(quantity);
    map['stock_before'] = Variable<double>(stockBefore);
    map['stock_after'] = Variable<double>(stockAfter);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InventoryMovementsCompanion toCompanion(bool nullToAbsent) {
    return InventoryMovementsCompanion(
      id: Value(id),
      productId: Value(productId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      type: Value(type),
      quantity: Value(quantity),
      stockBefore: Value(stockBefore),
      stockAfter: Value(stockAfter),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      userId: Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory InventoryMovementRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryMovementRow(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      variantId: serializer.fromJson<String?>(json['variantId']),
      type: $InventoryMovementsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      quantity: serializer.fromJson<double>(json['quantity']),
      stockBefore: serializer.fromJson<double>(json['stockBefore']),
      stockAfter: serializer.fromJson<double>(json['stockAfter']),
      reason: serializer.fromJson<String?>(json['reason']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'variantId': serializer.toJson<String?>(variantId),
      'type': serializer
          .toJson<int>($InventoryMovementsTable.$convertertype.toJson(type)),
      'quantity': serializer.toJson<double>(quantity),
      'stockBefore': serializer.toJson<double>(stockBefore),
      'stockAfter': serializer.toJson<double>(stockAfter),
      'reason': serializer.toJson<String?>(reason),
      'referenceId': serializer.toJson<String?>(referenceId),
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InventoryMovementRow copyWith(
          {String? id,
          String? productId,
          Value<String?> variantId = const Value.absent(),
          InventoryMovementType? type,
          double? quantity,
          double? stockBefore,
          double? stockAfter,
          Value<String?> reason = const Value.absent(),
          Value<String?> referenceId = const Value.absent(),
          String? userId,
          DateTime? createdAt}) =>
      InventoryMovementRow(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        variantId: variantId.present ? variantId.value : this.variantId,
        type: type ?? this.type,
        quantity: quantity ?? this.quantity,
        stockBefore: stockBefore ?? this.stockBefore,
        stockAfter: stockAfter ?? this.stockAfter,
        reason: reason.present ? reason.value : this.reason,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
      );
  InventoryMovementRow copyWithCompanion(InventoryMovementsCompanion data) {
    return InventoryMovementRow(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      stockBefore:
          data.stockBefore.present ? data.stockBefore.value : this.stockBefore,
      stockAfter:
          data.stockAfter.present ? data.stockAfter.value : this.stockAfter,
      reason: data.reason.present ? data.reason.value : this.reason,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryMovementRow(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('stockBefore: $stockBefore, ')
          ..write('stockAfter: $stockAfter, ')
          ..write('reason: $reason, ')
          ..write('referenceId: $referenceId, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, variantId, type, quantity,
      stockBefore, stockAfter, reason, referenceId, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryMovementRow &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.variantId == this.variantId &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.stockBefore == this.stockBefore &&
          other.stockAfter == this.stockAfter &&
          other.reason == this.reason &&
          other.referenceId == this.referenceId &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class InventoryMovementsCompanion
    extends UpdateCompanion<InventoryMovementRow> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String?> variantId;
  final Value<InventoryMovementType> type;
  final Value<double> quantity;
  final Value<double> stockBefore;
  final Value<double> stockAfter;
  final Value<String?> reason;
  final Value<String?> referenceId;
  final Value<String> userId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InventoryMovementsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.stockBefore = const Value.absent(),
    this.stockAfter = const Value.absent(),
    this.reason = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryMovementsCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    this.variantId = const Value.absent(),
    required InventoryMovementType type,
    required double quantity,
    required double stockBefore,
    required double stockAfter,
    this.reason = const Value.absent(),
    this.referenceId = const Value.absent(),
    required String userId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : productId = Value(productId),
        type = Value(type),
        quantity = Value(quantity),
        stockBefore = Value(stockBefore),
        stockAfter = Value(stockAfter),
        userId = Value(userId);
  static Insertable<InventoryMovementRow> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? variantId,
    Expression<int>? type,
    Expression<double>? quantity,
    Expression<double>? stockBefore,
    Expression<double>? stockAfter,
    Expression<String>? reason,
    Expression<String>? referenceId,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (stockBefore != null) 'stock_before': stockBefore,
      if (stockAfter != null) 'stock_after': stockAfter,
      if (reason != null) 'reason': reason,
      if (referenceId != null) 'reference_id': referenceId,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryMovementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String?>? variantId,
      Value<InventoryMovementType>? type,
      Value<double>? quantity,
      Value<double>? stockBefore,
      Value<double>? stockAfter,
      Value<String?>? reason,
      Value<String?>? referenceId,
      Value<String>? userId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return InventoryMovementsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      stockBefore: stockBefore ?? this.stockBefore,
      stockAfter: stockAfter ?? this.stockAfter,
      reason: reason ?? this.reason,
      referenceId: referenceId ?? this.referenceId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
          $InventoryMovementsTable.$convertertype.toSql(type.value));
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (stockBefore.present) {
      map['stock_before'] = Variable<double>(stockBefore.value);
    }
    if (stockAfter.present) {
      map['stock_after'] = Variable<double>(stockAfter.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryMovementsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('stockBefore: $stockBefore, ')
          ..write('stockAfter: $stockAfter, ')
          ..write('reason: $reason, ')
          ..write('referenceId: $referenceId, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrinterConfigsTable extends PrinterConfigs
    with TableInfo<$PrinterConfigsTable, PrinterConfigRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrinterConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _connectionTypeMeta =
      const VerificationMeta('connectionType');
  @override
  late final GeneratedColumnWithTypeConverter<PrinterConnectionType, int>
      connectionType = GeneratedColumn<int>(
              'connection_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<PrinterConnectionType>(
              $PrinterConfigsTable.$converterconnectionType);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
      'port', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _paperWidthMeta =
      const VerificationMeta('paperWidth');
  @override
  late final GeneratedColumnWithTypeConverter<PrinterPaperWidth, int>
      paperWidth = GeneratedColumn<int>('paper_width', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(1))
          .withConverter<PrinterPaperWidth>(
              $PrinterConfigsTable.$converterpaperWidth);
  static const VerificationMeta _autoCutMeta =
      const VerificationMeta('autoCut');
  @override
  late final GeneratedColumn<bool> autoCut = GeneratedColumn<bool>(
      'auto_cut', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("auto_cut" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _headerTextMeta =
      const VerificationMeta('headerText');
  @override
  late final GeneratedColumn<String> headerText = GeneratedColumn<String>(
      'header_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _footerTextMeta =
      const VerificationMeta('footerText');
  @override
  late final GeneratedColumn<String> footerText = GeneratedColumn<String>(
      'footer_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        connectionType,
        address,
        port,
        paperWidth,
        autoCut,
        logoPath,
        headerText,
        footerText,
        isFavorite,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'printer_configs';
  @override
  VerificationContext validateIntegrity(Insertable<PrinterConfigRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_connectionTypeMeta, const VerificationResult.success());
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    }
    context.handle(_paperWidthMeta, const VerificationResult.success());
    if (data.containsKey('auto_cut')) {
      context.handle(_autoCutMeta,
          autoCut.isAcceptableOrUnknown(data['auto_cut']!, _autoCutMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('header_text')) {
      context.handle(
          _headerTextMeta,
          headerText.isAcceptableOrUnknown(
              data['header_text']!, _headerTextMeta));
    }
    if (data.containsKey('footer_text')) {
      context.handle(
          _footerTextMeta,
          footerText.isAcceptableOrUnknown(
              data['footer_text']!, _footerTextMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrinterConfigRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrinterConfigRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      connectionType: $PrinterConfigsTable.$converterconnectionType.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}connection_type'])!),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      port: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}port']),
      paperWidth: $PrinterConfigsTable.$converterpaperWidth.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}paper_width'])!),
      autoCut: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_cut'])!,
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      headerText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}header_text']),
      footerText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}footer_text']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PrinterConfigsTable createAlias(String alias) {
    return $PrinterConfigsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PrinterConnectionType, int, int>
      $converterconnectionType =
      const EnumIndexConverter<PrinterConnectionType>(
          PrinterConnectionType.values);
  static JsonTypeConverter2<PrinterPaperWidth, int, int> $converterpaperWidth =
      const EnumIndexConverter<PrinterPaperWidth>(PrinterPaperWidth.values);
}

class PrinterConfigRow extends DataClass
    implements Insertable<PrinterConfigRow> {
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
  final DateTime createdAt;
  const PrinterConfigRow(
      {required this.id,
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
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['connection_type'] = Variable<int>(
          $PrinterConfigsTable.$converterconnectionType.toSql(connectionType));
    }
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || port != null) {
      map['port'] = Variable<int>(port);
    }
    {
      map['paper_width'] = Variable<int>(
          $PrinterConfigsTable.$converterpaperWidth.toSql(paperWidth));
    }
    map['auto_cut'] = Variable<bool>(autoCut);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || headerText != null) {
      map['header_text'] = Variable<String>(headerText);
    }
    if (!nullToAbsent || footerText != null) {
      map['footer_text'] = Variable<String>(footerText);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PrinterConfigsCompanion toCompanion(bool nullToAbsent) {
    return PrinterConfigsCompanion(
      id: Value(id),
      name: Value(name),
      connectionType: Value(connectionType),
      address: Value(address),
      port: port == null && nullToAbsent ? const Value.absent() : Value(port),
      paperWidth: Value(paperWidth),
      autoCut: Value(autoCut),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      headerText: headerText == null && nullToAbsent
          ? const Value.absent()
          : Value(headerText),
      footerText: footerText == null && nullToAbsent
          ? const Value.absent()
          : Value(footerText),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
    );
  }

  factory PrinterConfigRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrinterConfigRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      connectionType: $PrinterConfigsTable.$converterconnectionType
          .fromJson(serializer.fromJson<int>(json['connectionType'])),
      address: serializer.fromJson<String>(json['address']),
      port: serializer.fromJson<int?>(json['port']),
      paperWidth: $PrinterConfigsTable.$converterpaperWidth
          .fromJson(serializer.fromJson<int>(json['paperWidth'])),
      autoCut: serializer.fromJson<bool>(json['autoCut']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      headerText: serializer.fromJson<String?>(json['headerText']),
      footerText: serializer.fromJson<String?>(json['footerText']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'connectionType': serializer.toJson<int>(
          $PrinterConfigsTable.$converterconnectionType.toJson(connectionType)),
      'address': serializer.toJson<String>(address),
      'port': serializer.toJson<int?>(port),
      'paperWidth': serializer.toJson<int>(
          $PrinterConfigsTable.$converterpaperWidth.toJson(paperWidth)),
      'autoCut': serializer.toJson<bool>(autoCut),
      'logoPath': serializer.toJson<String?>(logoPath),
      'headerText': serializer.toJson<String?>(headerText),
      'footerText': serializer.toJson<String?>(footerText),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PrinterConfigRow copyWith(
          {String? id,
          String? name,
          PrinterConnectionType? connectionType,
          String? address,
          Value<int?> port = const Value.absent(),
          PrinterPaperWidth? paperWidth,
          bool? autoCut,
          Value<String?> logoPath = const Value.absent(),
          Value<String?> headerText = const Value.absent(),
          Value<String?> footerText = const Value.absent(),
          bool? isFavorite,
          DateTime? createdAt}) =>
      PrinterConfigRow(
        id: id ?? this.id,
        name: name ?? this.name,
        connectionType: connectionType ?? this.connectionType,
        address: address ?? this.address,
        port: port.present ? port.value : this.port,
        paperWidth: paperWidth ?? this.paperWidth,
        autoCut: autoCut ?? this.autoCut,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        headerText: headerText.present ? headerText.value : this.headerText,
        footerText: footerText.present ? footerText.value : this.footerText,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt ?? this.createdAt,
      );
  PrinterConfigRow copyWithCompanion(PrinterConfigsCompanion data) {
    return PrinterConfigRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      connectionType: data.connectionType.present
          ? data.connectionType.value
          : this.connectionType,
      address: data.address.present ? data.address.value : this.address,
      port: data.port.present ? data.port.value : this.port,
      paperWidth:
          data.paperWidth.present ? data.paperWidth.value : this.paperWidth,
      autoCut: data.autoCut.present ? data.autoCut.value : this.autoCut,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      headerText:
          data.headerText.present ? data.headerText.value : this.headerText,
      footerText:
          data.footerText.present ? data.footerText.value : this.footerText,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrinterConfigRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('connectionType: $connectionType, ')
          ..write('address: $address, ')
          ..write('port: $port, ')
          ..write('paperWidth: $paperWidth, ')
          ..write('autoCut: $autoCut, ')
          ..write('logoPath: $logoPath, ')
          ..write('headerText: $headerText, ')
          ..write('footerText: $footerText, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      connectionType,
      address,
      port,
      paperWidth,
      autoCut,
      logoPath,
      headerText,
      footerText,
      isFavorite,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrinterConfigRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.connectionType == this.connectionType &&
          other.address == this.address &&
          other.port == this.port &&
          other.paperWidth == this.paperWidth &&
          other.autoCut == this.autoCut &&
          other.logoPath == this.logoPath &&
          other.headerText == this.headerText &&
          other.footerText == this.footerText &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt);
}

class PrinterConfigsCompanion extends UpdateCompanion<PrinterConfigRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<PrinterConnectionType> connectionType;
  final Value<String> address;
  final Value<int?> port;
  final Value<PrinterPaperWidth> paperWidth;
  final Value<bool> autoCut;
  final Value<String?> logoPath;
  final Value<String?> headerText;
  final Value<String?> footerText;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PrinterConfigsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.address = const Value.absent(),
    this.port = const Value.absent(),
    this.paperWidth = const Value.absent(),
    this.autoCut = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.headerText = const Value.absent(),
    this.footerText = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrinterConfigsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required PrinterConnectionType connectionType,
    required String address,
    this.port = const Value.absent(),
    this.paperWidth = const Value.absent(),
    this.autoCut = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.headerText = const Value.absent(),
    this.footerText = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        connectionType = Value(connectionType),
        address = Value(address);
  static Insertable<PrinterConfigRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? connectionType,
    Expression<String>? address,
    Expression<int>? port,
    Expression<int>? paperWidth,
    Expression<bool>? autoCut,
    Expression<String>? logoPath,
    Expression<String>? headerText,
    Expression<String>? footerText,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (connectionType != null) 'connection_type': connectionType,
      if (address != null) 'address': address,
      if (port != null) 'port': port,
      if (paperWidth != null) 'paper_width': paperWidth,
      if (autoCut != null) 'auto_cut': autoCut,
      if (logoPath != null) 'logo_path': logoPath,
      if (headerText != null) 'header_text': headerText,
      if (footerText != null) 'footer_text': footerText,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrinterConfigsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<PrinterConnectionType>? connectionType,
      Value<String>? address,
      Value<int?>? port,
      Value<PrinterPaperWidth>? paperWidth,
      Value<bool>? autoCut,
      Value<String?>? logoPath,
      Value<String?>? headerText,
      Value<String?>? footerText,
      Value<bool>? isFavorite,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PrinterConfigsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      connectionType: connectionType ?? this.connectionType,
      address: address ?? this.address,
      port: port ?? this.port,
      paperWidth: paperWidth ?? this.paperWidth,
      autoCut: autoCut ?? this.autoCut,
      logoPath: logoPath ?? this.logoPath,
      headerText: headerText ?? this.headerText,
      footerText: footerText ?? this.footerText,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (connectionType.present) {
      map['connection_type'] = Variable<int>($PrinterConfigsTable
          .$converterconnectionType
          .toSql(connectionType.value));
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (paperWidth.present) {
      map['paper_width'] = Variable<int>(
          $PrinterConfigsTable.$converterpaperWidth.toSql(paperWidth.value));
    }
    if (autoCut.present) {
      map['auto_cut'] = Variable<bool>(autoCut.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (headerText.present) {
      map['header_text'] = Variable<String>(headerText.value);
    }
    if (footerText.present) {
      map['footer_text'] = Variable<String>(footerText.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrinterConfigsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('connectionType: $connectionType, ')
          ..write('address: $address, ')
          ..write('port: $port, ')
          ..write('paperWidth: $paperWidth, ')
          ..write('autoCut: $autoCut, ')
          ..write('logoPath: $logoPath, ')
          ..write('headerText: $headerText, ')
          ..write('footerText: $footerText, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceiptConfigsTable extends ReceiptConfigs
    with TableInfo<$ReceiptConfigsTable, ReceiptConfigRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _branchIdMeta =
      const VerificationMeta('branchId');
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
      'branch_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taxIdMeta = const VerificationMeta('taxId');
  @override
  late final GeneratedColumn<String> taxId = GeneratedColumn<String>(
      'tax_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _headerMeta = const VerificationMeta('header');
  @override
  late final GeneratedColumn<String> header = GeneratedColumn<String>(
      'header', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _footerMeta = const VerificationMeta('footer');
  @override
  late final GeneratedColumn<String> footer = GeneratedColumn<String>(
      'footer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _thankYouMessageMeta =
      const VerificationMeta('thankYouMessage');
  @override
  late final GeneratedColumn<String> thankYouMessage = GeneratedColumn<String>(
      'thank_you_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoUrlMeta =
      const VerificationMeta('logoUrl');
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
      'logo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoPrintUrlMeta =
      const VerificationMeta('logoPrintUrl');
  @override
  late final GeneratedColumn<String> logoPrintUrl = GeneratedColumn<String>(
      'logo_print_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _showLogoMeta =
      const VerificationMeta('showLogo');
  @override
  late final GeneratedColumn<bool> showLogo = GeneratedColumn<bool>(
      'show_logo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_logo" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _showTaxIdMeta =
      const VerificationMeta('showTaxId');
  @override
  late final GeneratedColumn<bool> showTaxId = GeneratedColumn<bool>(
      'show_tax_id', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_tax_id" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showAddressMeta =
      const VerificationMeta('showAddress');
  @override
  late final GeneratedColumn<bool> showAddress = GeneratedColumn<bool>(
      'show_address', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_address" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showPhoneMeta =
      const VerificationMeta('showPhone');
  @override
  late final GeneratedColumn<bool> showPhone = GeneratedColumn<bool>(
      'show_phone', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_phone" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _printCopiesMeta =
      const VerificationMeta('printCopies');
  @override
  late final GeneratedColumn<int> printCopies = GeneratedColumn<int>(
      'print_copies', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        branchId,
        businessName,
        taxId,
        address,
        phone,
        header,
        footer,
        thankYouMessage,
        logoUrl,
        logoPrintUrl,
        showLogo,
        showTaxId,
        showAddress,
        showPhone,
        printCopies,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipt_configs';
  @override
  VerificationContext validateIntegrity(Insertable<ReceiptConfigRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    }
    if (data.containsKey('tax_id')) {
      context.handle(
          _taxIdMeta, taxId.isAcceptableOrUnknown(data['tax_id']!, _taxIdMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('header')) {
      context.handle(_headerMeta,
          header.isAcceptableOrUnknown(data['header']!, _headerMeta));
    }
    if (data.containsKey('footer')) {
      context.handle(_footerMeta,
          footer.isAcceptableOrUnknown(data['footer']!, _footerMeta));
    }
    if (data.containsKey('thank_you_message')) {
      context.handle(
          _thankYouMessageMeta,
          thankYouMessage.isAcceptableOrUnknown(
              data['thank_you_message']!, _thankYouMessageMeta));
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('logo_print_url')) {
      context.handle(
          _logoPrintUrlMeta,
          logoPrintUrl.isAcceptableOrUnknown(
              data['logo_print_url']!, _logoPrintUrlMeta));
    }
    if (data.containsKey('show_logo')) {
      context.handle(_showLogoMeta,
          showLogo.isAcceptableOrUnknown(data['show_logo']!, _showLogoMeta));
    }
    if (data.containsKey('show_tax_id')) {
      context.handle(
          _showTaxIdMeta,
          showTaxId.isAcceptableOrUnknown(
              data['show_tax_id']!, _showTaxIdMeta));
    }
    if (data.containsKey('show_address')) {
      context.handle(
          _showAddressMeta,
          showAddress.isAcceptableOrUnknown(
              data['show_address']!, _showAddressMeta));
    }
    if (data.containsKey('show_phone')) {
      context.handle(_showPhoneMeta,
          showPhone.isAcceptableOrUnknown(data['show_phone']!, _showPhoneMeta));
    }
    if (data.containsKey('print_copies')) {
      context.handle(
          _printCopiesMeta,
          printCopies.isAcceptableOrUnknown(
              data['print_copies']!, _printCopiesMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceiptConfigRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceiptConfigRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      branchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}branch_id']),
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name']),
      taxId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tax_id']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      header: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}header']),
      footer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}footer']),
      thankYouMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}thank_you_message']),
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      logoPrintUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_print_url']),
      showLogo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_logo'])!,
      showTaxId: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_tax_id'])!,
      showAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_address'])!,
      showPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_phone'])!,
      printCopies: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}print_copies'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ReceiptConfigsTable createAlias(String alias) {
    return $ReceiptConfigsTable(attachedDatabase, alias);
  }
}

class ReceiptConfigRow extends DataClass
    implements Insertable<ReceiptConfigRow> {
  final String id;
  final String? branchId;
  final String? businessName;
  final String? taxId;
  final String? address;
  final String? phone;
  final String? header;
  final String? footer;
  final String? thankYouMessage;
  final String? logoUrl;
  final String? logoPrintUrl;
  final bool showLogo;
  final bool showTaxId;
  final bool showAddress;
  final bool showPhone;
  final int printCopies;
  final DateTime updatedAt;
  const ReceiptConfigRow(
      {required this.id,
      this.branchId,
      this.businessName,
      this.taxId,
      this.address,
      this.phone,
      this.header,
      this.footer,
      this.thankYouMessage,
      this.logoUrl,
      this.logoPrintUrl,
      required this.showLogo,
      required this.showTaxId,
      required this.showAddress,
      required this.showPhone,
      required this.printCopies,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<String>(branchId);
    }
    if (!nullToAbsent || businessName != null) {
      map['business_name'] = Variable<String>(businessName);
    }
    if (!nullToAbsent || taxId != null) {
      map['tax_id'] = Variable<String>(taxId);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || header != null) {
      map['header'] = Variable<String>(header);
    }
    if (!nullToAbsent || footer != null) {
      map['footer'] = Variable<String>(footer);
    }
    if (!nullToAbsent || thankYouMessage != null) {
      map['thank_you_message'] = Variable<String>(thankYouMessage);
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || logoPrintUrl != null) {
      map['logo_print_url'] = Variable<String>(logoPrintUrl);
    }
    map['show_logo'] = Variable<bool>(showLogo);
    map['show_tax_id'] = Variable<bool>(showTaxId);
    map['show_address'] = Variable<bool>(showAddress);
    map['show_phone'] = Variable<bool>(showPhone);
    map['print_copies'] = Variable<int>(printCopies);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReceiptConfigsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptConfigsCompanion(
      id: Value(id),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      businessName: businessName == null && nullToAbsent
          ? const Value.absent()
          : Value(businessName),
      taxId:
          taxId == null && nullToAbsent ? const Value.absent() : Value(taxId),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      header:
          header == null && nullToAbsent ? const Value.absent() : Value(header),
      footer:
          footer == null && nullToAbsent ? const Value.absent() : Value(footer),
      thankYouMessage: thankYouMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(thankYouMessage),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      logoPrintUrl: logoPrintUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPrintUrl),
      showLogo: Value(showLogo),
      showTaxId: Value(showTaxId),
      showAddress: Value(showAddress),
      showPhone: Value(showPhone),
      printCopies: Value(printCopies),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReceiptConfigRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceiptConfigRow(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String?>(json['branchId']),
      businessName: serializer.fromJson<String?>(json['businessName']),
      taxId: serializer.fromJson<String?>(json['taxId']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      header: serializer.fromJson<String?>(json['header']),
      footer: serializer.fromJson<String?>(json['footer']),
      thankYouMessage: serializer.fromJson<String?>(json['thankYouMessage']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      logoPrintUrl: serializer.fromJson<String?>(json['logoPrintUrl']),
      showLogo: serializer.fromJson<bool>(json['showLogo']),
      showTaxId: serializer.fromJson<bool>(json['showTaxId']),
      showAddress: serializer.fromJson<bool>(json['showAddress']),
      showPhone: serializer.fromJson<bool>(json['showPhone']),
      printCopies: serializer.fromJson<int>(json['printCopies']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String?>(branchId),
      'businessName': serializer.toJson<String?>(businessName),
      'taxId': serializer.toJson<String?>(taxId),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'header': serializer.toJson<String?>(header),
      'footer': serializer.toJson<String?>(footer),
      'thankYouMessage': serializer.toJson<String?>(thankYouMessage),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'logoPrintUrl': serializer.toJson<String?>(logoPrintUrl),
      'showLogo': serializer.toJson<bool>(showLogo),
      'showTaxId': serializer.toJson<bool>(showTaxId),
      'showAddress': serializer.toJson<bool>(showAddress),
      'showPhone': serializer.toJson<bool>(showPhone),
      'printCopies': serializer.toJson<int>(printCopies),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReceiptConfigRow copyWith(
          {String? id,
          Value<String?> branchId = const Value.absent(),
          Value<String?> businessName = const Value.absent(),
          Value<String?> taxId = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> header = const Value.absent(),
          Value<String?> footer = const Value.absent(),
          Value<String?> thankYouMessage = const Value.absent(),
          Value<String?> logoUrl = const Value.absent(),
          Value<String?> logoPrintUrl = const Value.absent(),
          bool? showLogo,
          bool? showTaxId,
          bool? showAddress,
          bool? showPhone,
          int? printCopies,
          DateTime? updatedAt}) =>
      ReceiptConfigRow(
        id: id ?? this.id,
        branchId: branchId.present ? branchId.value : this.branchId,
        businessName:
            businessName.present ? businessName.value : this.businessName,
        taxId: taxId.present ? taxId.value : this.taxId,
        address: address.present ? address.value : this.address,
        phone: phone.present ? phone.value : this.phone,
        header: header.present ? header.value : this.header,
        footer: footer.present ? footer.value : this.footer,
        thankYouMessage: thankYouMessage.present
            ? thankYouMessage.value
            : this.thankYouMessage,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        logoPrintUrl:
            logoPrintUrl.present ? logoPrintUrl.value : this.logoPrintUrl,
        showLogo: showLogo ?? this.showLogo,
        showTaxId: showTaxId ?? this.showTaxId,
        showAddress: showAddress ?? this.showAddress,
        showPhone: showPhone ?? this.showPhone,
        printCopies: printCopies ?? this.printCopies,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ReceiptConfigRow copyWithCompanion(ReceiptConfigsCompanion data) {
    return ReceiptConfigRow(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      taxId: data.taxId.present ? data.taxId.value : this.taxId,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      header: data.header.present ? data.header.value : this.header,
      footer: data.footer.present ? data.footer.value : this.footer,
      thankYouMessage: data.thankYouMessage.present
          ? data.thankYouMessage.value
          : this.thankYouMessage,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      logoPrintUrl: data.logoPrintUrl.present
          ? data.logoPrintUrl.value
          : this.logoPrintUrl,
      showLogo: data.showLogo.present ? data.showLogo.value : this.showLogo,
      showTaxId: data.showTaxId.present ? data.showTaxId.value : this.showTaxId,
      showAddress:
          data.showAddress.present ? data.showAddress.value : this.showAddress,
      showPhone: data.showPhone.present ? data.showPhone.value : this.showPhone,
      printCopies:
          data.printCopies.present ? data.printCopies.value : this.printCopies,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptConfigRow(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('businessName: $businessName, ')
          ..write('taxId: $taxId, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('header: $header, ')
          ..write('footer: $footer, ')
          ..write('thankYouMessage: $thankYouMessage, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('logoPrintUrl: $logoPrintUrl, ')
          ..write('showLogo: $showLogo, ')
          ..write('showTaxId: $showTaxId, ')
          ..write('showAddress: $showAddress, ')
          ..write('showPhone: $showPhone, ')
          ..write('printCopies: $printCopies, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      branchId,
      businessName,
      taxId,
      address,
      phone,
      header,
      footer,
      thankYouMessage,
      logoUrl,
      logoPrintUrl,
      showLogo,
      showTaxId,
      showAddress,
      showPhone,
      printCopies,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceiptConfigRow &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.businessName == this.businessName &&
          other.taxId == this.taxId &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.header == this.header &&
          other.footer == this.footer &&
          other.thankYouMessage == this.thankYouMessage &&
          other.logoUrl == this.logoUrl &&
          other.logoPrintUrl == this.logoPrintUrl &&
          other.showLogo == this.showLogo &&
          other.showTaxId == this.showTaxId &&
          other.showAddress == this.showAddress &&
          other.showPhone == this.showPhone &&
          other.printCopies == this.printCopies &&
          other.updatedAt == this.updatedAt);
}

class ReceiptConfigsCompanion extends UpdateCompanion<ReceiptConfigRow> {
  final Value<String> id;
  final Value<String?> branchId;
  final Value<String?> businessName;
  final Value<String?> taxId;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> header;
  final Value<String?> footer;
  final Value<String?> thankYouMessage;
  final Value<String?> logoUrl;
  final Value<String?> logoPrintUrl;
  final Value<bool> showLogo;
  final Value<bool> showTaxId;
  final Value<bool> showAddress;
  final Value<bool> showPhone;
  final Value<int> printCopies;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReceiptConfigsCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.businessName = const Value.absent(),
    this.taxId = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.header = const Value.absent(),
    this.footer = const Value.absent(),
    this.thankYouMessage = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.logoPrintUrl = const Value.absent(),
    this.showLogo = const Value.absent(),
    this.showTaxId = const Value.absent(),
    this.showAddress = const Value.absent(),
    this.showPhone = const Value.absent(),
    this.printCopies = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceiptConfigsCompanion.insert({
    required String id,
    this.branchId = const Value.absent(),
    this.businessName = const Value.absent(),
    this.taxId = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.header = const Value.absent(),
    this.footer = const Value.absent(),
    this.thankYouMessage = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.logoPrintUrl = const Value.absent(),
    this.showLogo = const Value.absent(),
    this.showTaxId = const Value.absent(),
    this.showAddress = const Value.absent(),
    this.showPhone = const Value.absent(),
    this.printCopies = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ReceiptConfigRow> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? businessName,
    Expression<String>? taxId,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? header,
    Expression<String>? footer,
    Expression<String>? thankYouMessage,
    Expression<String>? logoUrl,
    Expression<String>? logoPrintUrl,
    Expression<bool>? showLogo,
    Expression<bool>? showTaxId,
    Expression<bool>? showAddress,
    Expression<bool>? showPhone,
    Expression<int>? printCopies,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (businessName != null) 'business_name': businessName,
      if (taxId != null) 'tax_id': taxId,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (header != null) 'header': header,
      if (footer != null) 'footer': footer,
      if (thankYouMessage != null) 'thank_you_message': thankYouMessage,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (logoPrintUrl != null) 'logo_print_url': logoPrintUrl,
      if (showLogo != null) 'show_logo': showLogo,
      if (showTaxId != null) 'show_tax_id': showTaxId,
      if (showAddress != null) 'show_address': showAddress,
      if (showPhone != null) 'show_phone': showPhone,
      if (printCopies != null) 'print_copies': printCopies,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceiptConfigsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? branchId,
      Value<String?>? businessName,
      Value<String?>? taxId,
      Value<String?>? address,
      Value<String?>? phone,
      Value<String?>? header,
      Value<String?>? footer,
      Value<String?>? thankYouMessage,
      Value<String?>? logoUrl,
      Value<String?>? logoPrintUrl,
      Value<bool>? showLogo,
      Value<bool>? showTaxId,
      Value<bool>? showAddress,
      Value<bool>? showPhone,
      Value<int>? printCopies,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ReceiptConfigsCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      businessName: businessName ?? this.businessName,
      taxId: taxId ?? this.taxId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      thankYouMessage: thankYouMessage ?? this.thankYouMessage,
      logoUrl: logoUrl ?? this.logoUrl,
      logoPrintUrl: logoPrintUrl ?? this.logoPrintUrl,
      showLogo: showLogo ?? this.showLogo,
      showTaxId: showTaxId ?? this.showTaxId,
      showAddress: showAddress ?? this.showAddress,
      showPhone: showPhone ?? this.showPhone,
      printCopies: printCopies ?? this.printCopies,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (taxId.present) {
      map['tax_id'] = Variable<String>(taxId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (header.present) {
      map['header'] = Variable<String>(header.value);
    }
    if (footer.present) {
      map['footer'] = Variable<String>(footer.value);
    }
    if (thankYouMessage.present) {
      map['thank_you_message'] = Variable<String>(thankYouMessage.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (logoPrintUrl.present) {
      map['logo_print_url'] = Variable<String>(logoPrintUrl.value);
    }
    if (showLogo.present) {
      map['show_logo'] = Variable<bool>(showLogo.value);
    }
    if (showTaxId.present) {
      map['show_tax_id'] = Variable<bool>(showTaxId.value);
    }
    if (showAddress.present) {
      map['show_address'] = Variable<bool>(showAddress.value);
    }
    if (showPhone.present) {
      map['show_phone'] = Variable<bool>(showPhone.value);
    }
    if (printCopies.present) {
      map['print_copies'] = Variable<int>(printCopies.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptConfigsCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('businessName: $businessName, ')
          ..write('taxId: $taxId, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('header: $header, ')
          ..write('footer: $footer, ')
          ..write('thankYouMessage: $thankYouMessage, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('logoPrintUrl: $logoPrintUrl, ')
          ..write('showLogo: $showLogo, ')
          ..write('showTaxId: $showTaxId, ')
          ..write('showAddress: $showAddress, ')
          ..write('showPhone: $showPhone, ')
          ..write('printCopies: $printCopies, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentMethodsTable extends PaymentMethods
    with TableInfo<$PaymentMethodsTable, PaymentMethodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMethodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<int> code = GeneratedColumn<int>(
      'code', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('credit-card'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isCreditMeta =
      const VerificationMeta('isCredit');
  @override
  late final GeneratedColumn<bool> isCredit = GeneratedColumn<bool>(
      'is_credit', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_credit" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        label,
        icon,
        isActive,
        isCredit,
        sortOrder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_methods';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentMethodRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_credit')) {
      context.handle(_isCreditMeta,
          isCredit.isAcceptableOrUnknown(data['is_credit']!, _isCreditMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentMethodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMethodRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}code'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isCredit: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_credit'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PaymentMethodsTable createAlias(String alias) {
    return $PaymentMethodsTable(attachedDatabase, alias);
  }
}

class PaymentMethodRow extends DataClass
    implements Insertable<PaymentMethodRow> {
  final String id;
  final int code;
  final String label;
  final String icon;
  final bool isActive;
  final bool isCredit;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PaymentMethodRow(
      {required this.id,
      required this.code,
      required this.label,
      required this.icon,
      required this.isActive,
      required this.isCredit,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<int>(code);
    map['label'] = Variable<String>(label);
    map['icon'] = Variable<String>(icon);
    map['is_active'] = Variable<bool>(isActive);
    map['is_credit'] = Variable<bool>(isCredit);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PaymentMethodsCompanion toCompanion(bool nullToAbsent) {
    return PaymentMethodsCompanion(
      id: Value(id),
      code: Value(code),
      label: Value(label),
      icon: Value(icon),
      isActive: Value(isActive),
      isCredit: Value(isCredit),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PaymentMethodRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentMethodRow(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<int>(json['code']),
      label: serializer.fromJson<String>(json['label']),
      icon: serializer.fromJson<String>(json['icon']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isCredit: serializer.fromJson<bool>(json['isCredit']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<int>(code),
      'label': serializer.toJson<String>(label),
      'icon': serializer.toJson<String>(icon),
      'isActive': serializer.toJson<bool>(isActive),
      'isCredit': serializer.toJson<bool>(isCredit),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PaymentMethodRow copyWith(
          {String? id,
          int? code,
          String? label,
          String? icon,
          bool? isActive,
          bool? isCredit,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PaymentMethodRow(
        id: id ?? this.id,
        code: code ?? this.code,
        label: label ?? this.label,
        icon: icon ?? this.icon,
        isActive: isActive ?? this.isActive,
        isCredit: isCredit ?? this.isCredit,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PaymentMethodRow copyWithCompanion(PaymentMethodsCompanion data) {
    return PaymentMethodRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      label: data.label.present ? data.label.value : this.label,
      icon: data.icon.present ? data.icon.value : this.icon,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isCredit: data.isCredit.present ? data.isCredit.value : this.isCredit,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('label: $label, ')
          ..write('icon: $icon, ')
          ..write('isActive: $isActive, ')
          ..write('isCredit: $isCredit, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, label, icon, isActive, isCredit,
      sortOrder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentMethodRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.label == this.label &&
          other.icon == this.icon &&
          other.isActive == this.isActive &&
          other.isCredit == this.isCredit &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PaymentMethodsCompanion extends UpdateCompanion<PaymentMethodRow> {
  final Value<String> id;
  final Value<int> code;
  final Value<String> label;
  final Value<String> icon;
  final Value<bool> isActive;
  final Value<bool> isCredit;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PaymentMethodsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.label = const Value.absent(),
    this.icon = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isCredit = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentMethodsCompanion.insert({
    this.id = const Value.absent(),
    required int code,
    required String label,
    this.icon = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isCredit = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        label = Value(label);
  static Insertable<PaymentMethodRow> custom({
    Expression<String>? id,
    Expression<int>? code,
    Expression<String>? label,
    Expression<String>? icon,
    Expression<bool>? isActive,
    Expression<bool>? isCredit,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (label != null) 'label': label,
      if (icon != null) 'icon': icon,
      if (isActive != null) 'is_active': isActive,
      if (isCredit != null) 'is_credit': isCredit,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentMethodsCompanion copyWith(
      {Value<String>? id,
      Value<int>? code,
      Value<String>? label,
      Value<String>? icon,
      Value<bool>? isActive,
      Value<bool>? isCredit,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PaymentMethodsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      isCredit: isCredit ?? this.isCredit,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<int>(code.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isCredit.present) {
      map['is_credit'] = Variable<bool>(isCredit.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('label: $label, ')
          ..write('icon: $icon, ')
          ..write('isActive: $isActive, ')
          ..write('isCredit: $isCredit, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TpvInventoryTable extends TpvInventory
    with TableInfo<$TpvInventoryTable, TpvInventoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TpvInventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _variantIdMeta =
      const VerificationMeta('variantId');
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
      'variant_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_variants (id)'));
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<double> stock = GeneratedColumn<double>(
      'stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, variantId, stock, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tpv_inventory';
  @override
  VerificationContext validateIntegrity(Insertable<TpvInventoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta));
    }
    if (data.containsKey('stock')) {
      context.handle(
          _stockMeta, stock.isAcceptableOrUnknown(data['stock']!, _stockMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TpvInventoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TpvInventoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      variantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variant_id']),
      stock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TpvInventoryTable createAlias(String alias) {
    return $TpvInventoryTable(attachedDatabase, alias);
  }
}

class TpvInventoryRow extends DataClass implements Insertable<TpvInventoryRow> {
  final String id;
  final String productId;
  final String? variantId;
  final double stock;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TpvInventoryRow(
      {required this.id,
      required this.productId,
      this.variantId,
      required this.stock,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    map['stock'] = Variable<double>(stock);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TpvInventoryCompanion toCompanion(bool nullToAbsent) {
    return TpvInventoryCompanion(
      id: Value(id),
      productId: Value(productId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      stock: Value(stock),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TpvInventoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TpvInventoryRow(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      variantId: serializer.fromJson<String?>(json['variantId']),
      stock: serializer.fromJson<double>(json['stock']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'variantId': serializer.toJson<String?>(variantId),
      'stock': serializer.toJson<double>(stock),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TpvInventoryRow copyWith(
          {String? id,
          String? productId,
          Value<String?> variantId = const Value.absent(),
          double? stock,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TpvInventoryRow(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        variantId: variantId.present ? variantId.value : this.variantId,
        stock: stock ?? this.stock,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TpvInventoryRow copyWithCompanion(TpvInventoryCompanion data) {
    return TpvInventoryRow(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      stock: data.stock.present ? data.stock.value : this.stock,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TpvInventoryRow(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('stock: $stock, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, variantId, stock, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TpvInventoryRow &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.variantId == this.variantId &&
          other.stock == this.stock &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TpvInventoryCompanion extends UpdateCompanion<TpvInventoryRow> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String?> variantId;
  final Value<double> stock;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TpvInventoryCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.stock = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TpvInventoryCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    this.variantId = const Value.absent(),
    this.stock = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : productId = Value(productId);
  static Insertable<TpvInventoryRow> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? variantId,
    Expression<double>? stock,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      if (stock != null) 'stock': stock,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TpvInventoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String?>? variantId,
      Value<double>? stock,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TpvInventoryCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (stock.present) {
      map['stock'] = Variable<double>(stock.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TpvInventoryCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('stock: $stock, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _entityTableMeta =
      const VerificationMeta('entityTable');
  @override
  late final GeneratedColumn<String> entityTable = GeneratedColumn<String>(
      'entity_table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumnWithTypeConverter<SyncOperation, int> operation =
      GeneratedColumn<int>('operation', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SyncOperation>(
              $SyncQueueItemsTable.$converteroperation);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<SyncStatus>($SyncQueueItemsTable.$converterstatus);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: DateTime.now);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityTable,
        entityId,
        operation,
        payloadJson,
        status,
        retryCount,
        lastError,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_items';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_table')) {
      context.handle(
          _entityTableMeta,
          entityTable.isAcceptableOrUnknown(
              data['entity_table']!, _entityTableMeta));
    } else if (isInserting) {
      context.missing(_entityTableMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    context.handle(_operationMeta, const VerificationResult.success());
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_table'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: $SyncQueueItemsTable.$converteroperation.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}operation'])!),
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      status: $SyncQueueItemsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncOperation, int, int> $converteroperation =
      const EnumIndexConverter<SyncOperation>(SyncOperation.values);
  static JsonTypeConverter2<SyncStatus, int, int> $converterstatus =
      const EnumIndexConverter<SyncStatus>(SyncStatus.values);
}

class SyncQueueRow extends DataClass implements Insertable<SyncQueueRow> {
  final String id;
  final String entityTable;
  final String entityId;
  final SyncOperation operation;
  final String payloadJson;
  final SyncStatus status;
  final int retryCount;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueRow(
      {required this.id,
      required this.entityTable,
      required this.entityId,
      required this.operation,
      required this.payloadJson,
      required this.status,
      required this.retryCount,
      this.lastError,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_table'] = Variable<String>(entityTable);
    map['entity_id'] = Variable<String>(entityId);
    {
      map['operation'] = Variable<int>(
          $SyncQueueItemsTable.$converteroperation.toSql(operation));
    }
    map['payload_json'] = Variable<String>(payloadJson);
    {
      map['status'] =
          Variable<int>($SyncQueueItemsTable.$converterstatus.toSql(status));
    }
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      id: Value(id),
      entityTable: Value(entityTable),
      entityId: Value(entityId),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      status: Value(status),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueRow(
      id: serializer.fromJson<String>(json['id']),
      entityTable: serializer.fromJson<String>(json['entityTable']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: $SyncQueueItemsTable.$converteroperation
          .fromJson(serializer.fromJson<int>(json['operation'])),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: $SyncQueueItemsTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityTable': serializer.toJson<String>(entityTable),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<int>(
          $SyncQueueItemsTable.$converteroperation.toJson(operation)),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer
          .toJson<int>($SyncQueueItemsTable.$converterstatus.toJson(status)),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueRow copyWith(
          {String? id,
          String? entityTable,
          String? entityId,
          SyncOperation? operation,
          String? payloadJson,
          SyncStatus? status,
          int? retryCount,
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SyncQueueRow(
        id: id ?? this.id,
        entityTable: entityTable ?? this.entityTable,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payloadJson: payloadJson ?? this.payloadJson,
        status: status ?? this.status,
        retryCount: retryCount ?? this.retryCount,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncQueueRow copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueRow(
      id: data.id.present ? data.id.value : this.id,
      entityTable:
          data.entityTable.present ? data.entityTable.value : this.entityTable,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueRow(')
          ..write('id: $id, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityTable, entityId, operation,
      payloadJson, status, retryCount, lastError, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueRow &&
          other.id == this.id &&
          other.entityTable == this.entityTable &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueRow> {
  final Value<String> id;
  final Value<String> entityTable;
  final Value<String> entityId;
  final Value<SyncOperation> operation;
  final Value<String> payloadJson;
  final Value<SyncStatus> status;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueItemsCompanion({
    this.id = const Value.absent(),
    this.entityTable = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required String entityTable,
    required String entityId,
    required SyncOperation operation,
    required String payloadJson,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : entityTable = Value(entityTable),
        entityId = Value(entityId),
        operation = Value(operation),
        payloadJson = Value(payloadJson);
  static Insertable<SyncQueueRow> custom({
    Expression<String>? id,
    Expression<String>? entityTable,
    Expression<String>? entityId,
    Expression<int>? operation,
    Expression<String>? payloadJson,
    Expression<int>? status,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityTable != null) 'entity_table': entityTable,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityTable,
      Value<String>? entityId,
      Value<SyncOperation>? operation,
      Value<String>? payloadJson,
      Value<SyncStatus>? status,
      Value<int>? retryCount,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncQueueItemsCompanion(
      id: id ?? this.id,
      entityTable: entityTable ?? this.entityTable,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityTable.present) {
      map['entity_table'] = Variable<String>(entityTable.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<int>(
          $SyncQueueItemsTable.$converteroperation.toSql(operation.value));
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $SyncQueueItemsTable.$converterstatus.toSql(status.value));
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSettingRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  const AppSettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSettingRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingRow copyWith({String? key, String? value}) => AppSettingRow(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BrandsTable brands = $BrandsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductVariantsTable productVariants =
      $ProductVariantsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $CashRegistersTable cashRegisters = $CashRegistersTable(this);
  late final $CashMovementsTable cashMovements = $CashMovementsTable(this);
  late final $InventoryMovementsTable inventoryMovements =
      $InventoryMovementsTable(this);
  late final $PrinterConfigsTable printerConfigs = $PrinterConfigsTable(this);
  late final $ReceiptConfigsTable receiptConfigs = $ReceiptConfigsTable(this);
  late final $PaymentMethodsTable paymentMethods = $PaymentMethodsTable(this);
  late final $TpvInventoryTable tpvInventory = $TpvInventoryTable(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        categories,
        brands,
        suppliers,
        products,
        productVariants,
        customers,
        sales,
        saleItems,
        payments,
        cashRegisters,
        cashMovements,
        inventoryMovements,
        printerConfigs,
        receiptConfigs,
        paymentMethods,
        tpvInventory,
        syncQueueItems,
        appSettings
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String?> authUserId,
  required String fullName,
  required String username,
  Value<String?> email,
  required String pinHash,
  required String pinSalt,
  required UserRole role,
  Value<bool> biometricEnabled,
  Value<bool> isActive,
  Value<String?> avatarPath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String?> authUserId,
  Value<String> fullName,
  Value<String> username,
  Value<String?> email,
  Value<String> pinHash,
  Value<String> pinSalt,
  Value<UserRole> role,
  Value<bool> biometricEnabled,
  Value<bool> isActive,
  Value<String?> avatarPath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    UserRow,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UsersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UsersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> authUserId = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String> pinHash = const Value.absent(),
            Value<String> pinSalt = const Value.absent(),
            Value<UserRole> role = const Value.absent(),
            Value<bool> biometricEnabled = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            authUserId: authUserId,
            fullName: fullName,
            username: username,
            email: email,
            pinHash: pinHash,
            pinSalt: pinSalt,
            role: role,
            biometricEnabled: biometricEnabled,
            isActive: isActive,
            avatarPath: avatarPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> authUserId = const Value.absent(),
            required String fullName,
            required String username,
            Value<String?> email = const Value.absent(),
            required String pinHash,
            required String pinSalt,
            required UserRole role,
            Value<bool> biometricEnabled = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            authUserId: authUserId,
            fullName: fullName,
            username: username,
            email: email,
            pinHash: pinHash,
            pinSalt: pinSalt,
            role: role,
            biometricEnabled: biometricEnabled,
            isActive: isActive,
            avatarPath: avatarPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$UsersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get authUserId => $state.composableBuilder(
      column: $state.table.authUserId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fullName => $state.composableBuilder(
      column: $state.table.fullName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pinHash => $state.composableBuilder(
      column: $state.table.pinHash,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pinSalt => $state.composableBuilder(
      column: $state.table.pinSalt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<UserRole, UserRole, int> get role =>
      $state.composableBuilder(
          column: $state.table.role,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<bool> get biometricEnabled => $state.composableBuilder(
      column: $state.table.biometricEnabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get avatarPath => $state.composableBuilder(
      column: $state.table.avatarPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter salesRefs(
      ComposableFilter Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.sales,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder, parentComposers) => $$SalesTableFilterComposer(
            ComposerState(
                $state.db, $state.db.sales, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter cashRegistersRefs(
      ComposableFilter Function($$CashRegistersTableFilterComposer f) f) {
    final $$CashRegistersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.cashRegisters,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder, parentComposers) =>
            $$CashRegistersTableFilterComposer(ComposerState($state.db,
                $state.db.cashRegisters, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter cashMovementsRefs(
      ComposableFilter Function($$CashMovementsTableFilterComposer f) f) {
    final $$CashMovementsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.cashMovements,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder, parentComposers) =>
            $$CashMovementsTableFilterComposer(ComposerState($state.db,
                $state.db.cashMovements, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter inventoryMovementsRefs(
      ComposableFilter Function($$InventoryMovementsTableFilterComposer f) f) {
    final $$InventoryMovementsTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.inventoryMovements,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder, parentComposers) =>
                $$InventoryMovementsTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.inventoryMovements,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get authUserId => $state.composableBuilder(
      column: $state.table.authUserId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fullName => $state.composableBuilder(
      column: $state.table.fullName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pinHash => $state.composableBuilder(
      column: $state.table.pinHash,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pinSalt => $state.composableBuilder(
      column: $state.table.pinSalt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get biometricEnabled => $state.composableBuilder(
      column: $state.table.biometricEnabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get avatarPath => $state.composableBuilder(
      column: $state.table.avatarPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  required String name,
  Value<String> colorHex,
  Value<String?> iconName,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> colorHex,
  Value<String?> iconName,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryRow,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            colorHex: colorHex,
            iconName: iconName,
            sortOrder: sortOrder,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String> colorHex = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            colorHex: colorHex,
            iconName: iconName,
            sortOrder: sortOrder,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$CategoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get colorHex => $state.composableBuilder(
      column: $state.table.colorHex,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get iconName => $state.composableBuilder(
      column: $state.table.iconName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter productsRefs(
      ComposableFilter Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get colorHex => $state.composableBuilder(
      column: $state.table.colorHex,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get iconName => $state.composableBuilder(
      column: $state.table.iconName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BrandsTableCreateCompanionBuilder = BrandsCompanion Function({
  Value<String> id,
  required String name,
  Value<int> rowid,
});
typedef $$BrandsTableUpdateCompanionBuilder = BrandsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> rowid,
});

class $$BrandsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BrandsTable,
    BrandRow,
    $$BrandsTableFilterComposer,
    $$BrandsTableOrderingComposer,
    $$BrandsTableCreateCompanionBuilder,
    $$BrandsTableUpdateCompanionBuilder> {
  $$BrandsTableTableManager(_$AppDatabase db, $BrandsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BrandsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BrandsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BrandsCompanion(
            id: id,
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              BrandsCompanion.insert(
            id: id,
            name: name,
            rowid: rowid,
          ),
        ));
}

class $$BrandsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter productsRefs(
      ComposableFilter Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.brandId,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$BrandsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> contactName,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> contactName,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    SupplierRow,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SuppliersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SuppliersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> contactName = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            name: name,
            contactName: contactName,
            phone: phone,
            email: email,
            address: address,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> contactName = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            name: name,
            contactName: contactName,
            phone: phone,
            email: email,
            address: address,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$SuppliersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get contactName => $state.composableBuilder(
      column: $state.table.contactName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter productsRefs(
      ComposableFilter Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contactName => $state.composableBuilder(
      column: $state.table.contactName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> description,
  Value<String?> sku,
  Value<String?> barcode,
  Value<String?> categoryId,
  Value<String?> brandId,
  Value<String?> supplierId,
  required double price,
  Value<double> cost,
  Value<double> taxRate,
  Value<ProductUnitType> unitType,
  Value<bool> trackStock,
  Value<double> stockQuantity,
  Value<double> lowStockThreshold,
  Value<bool> hasVariants,
  Value<bool> isFavorite,
  Value<bool> isActive,
  Value<String?> imagePath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> sku,
  Value<String?> barcode,
  Value<String?> categoryId,
  Value<String?> brandId,
  Value<String?> supplierId,
  Value<double> price,
  Value<double> cost,
  Value<double> taxRate,
  Value<ProductUnitType> unitType,
  Value<bool> trackStock,
  Value<double> stockQuantity,
  Value<double> lowStockThreshold,
  Value<bool> hasVariants,
  Value<bool> isFavorite,
  Value<bool> isActive,
  Value<String?> imagePath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    ProductRow,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProductsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> brandId = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> cost = const Value.absent(),
            Value<double> taxRate = const Value.absent(),
            Value<ProductUnitType> unitType = const Value.absent(),
            Value<bool> trackStock = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<double> lowStockThreshold = const Value.absent(),
            Value<bool> hasVariants = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            description: description,
            sku: sku,
            barcode: barcode,
            categoryId: categoryId,
            brandId: brandId,
            supplierId: supplierId,
            price: price,
            cost: cost,
            taxRate: taxRate,
            unitType: unitType,
            trackStock: trackStock,
            stockQuantity: stockQuantity,
            lowStockThreshold: lowStockThreshold,
            hasVariants: hasVariants,
            isFavorite: isFavorite,
            isActive: isActive,
            imagePath: imagePath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> brandId = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            required double price,
            Value<double> cost = const Value.absent(),
            Value<double> taxRate = const Value.absent(),
            Value<ProductUnitType> unitType = const Value.absent(),
            Value<bool> trackStock = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<double> lowStockThreshold = const Value.absent(),
            Value<bool> hasVariants = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            description: description,
            sku: sku,
            barcode: barcode,
            categoryId: categoryId,
            brandId: brandId,
            supplierId: supplierId,
            price: price,
            cost: cost,
            taxRate: taxRate,
            unitType: unitType,
            trackStock: trackStock,
            stockQuantity: stockQuantity,
            lowStockThreshold: lowStockThreshold,
            hasVariants: hasVariants,
            isFavorite: isFavorite,
            isActive: isActive,
            imagePath: imagePath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$ProductsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get barcode => $state.composableBuilder(
      column: $state.table.barcode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get cost => $state.composableBuilder(
      column: $state.table.cost,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get taxRate => $state.composableBuilder(
      column: $state.table.taxRate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<ProductUnitType, ProductUnitType, int>
      get unitType => $state.composableBuilder(
          column: $state.table.unitType,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<bool> get trackStock => $state.composableBuilder(
      column: $state.table.trackStock,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stockQuantity => $state.composableBuilder(
      column: $state.table.stockQuantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lowStockThreshold => $state.composableBuilder(
      column: $state.table.lowStockThreshold,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get hasVariants => $state.composableBuilder(
      column: $state.table.hasVariants,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get imagePath => $state.composableBuilder(
      column: $state.table.imagePath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableFilterComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }

  $$BrandsTableFilterComposer get brandId {
    final $$BrandsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.brandId,
        referencedTable: $state.db.brands,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$BrandsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.brands, joinBuilder, parentComposers)));
    return composer;
  }

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableFilterComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter productVariantsRefs(
      ComposableFilter Function($$ProductVariantsTableFilterComposer f) f) {
    final $$ProductVariantsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.productVariants,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder, parentComposers) =>
                $$ProductVariantsTableFilterComposer(ComposerState($state.db,
                    $state.db.productVariants, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter saleItemsRefs(
      ComposableFilter Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.saleItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder, parentComposers) =>
            $$SaleItemsTableFilterComposer(ComposerState(
                $state.db, $state.db.saleItems, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter inventoryMovementsRefs(
      ComposableFilter Function($$InventoryMovementsTableFilterComposer f) f) {
    final $$InventoryMovementsTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.inventoryMovements,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder, parentComposers) =>
                $$InventoryMovementsTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.inventoryMovements,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }

  ComposableFilter tpvInventoryRefs(
      ComposableFilter Function($$TpvInventoryTableFilterComposer f) f) {
    final $$TpvInventoryTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.tpvInventory,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder, parentComposers) =>
            $$TpvInventoryTableFilterComposer(ComposerState($state.db,
                $state.db.tpvInventory, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get barcode => $state.composableBuilder(
      column: $state.table.barcode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get cost => $state.composableBuilder(
      column: $state.table.cost,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get taxRate => $state.composableBuilder(
      column: $state.table.taxRate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get unitType => $state.composableBuilder(
      column: $state.table.unitType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get trackStock => $state.composableBuilder(
      column: $state.table.trackStock,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stockQuantity => $state.composableBuilder(
      column: $state.table.stockQuantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lowStockThreshold => $state.composableBuilder(
      column: $state.table.lowStockThreshold,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get hasVariants => $state.composableBuilder(
      column: $state.table.hasVariants,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get imagePath => $state.composableBuilder(
      column: $state.table.imagePath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableOrderingComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }

  $$BrandsTableOrderingComposer get brandId {
    final $$BrandsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.brandId,
        referencedTable: $state.db.brands,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$BrandsTableOrderingComposer(ComposerState(
                $state.db, $state.db.brands, joinBuilder, parentComposers)));
    return composer;
  }

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableOrderingComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ProductVariantsTableCreateCompanionBuilder = ProductVariantsCompanion
    Function({
  Value<String> id,
  required String productId,
  required String name,
  Value<String?> sku,
  Value<String?> barcode,
  Value<double> priceDelta,
  Value<double> stockQuantity,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ProductVariantsTableUpdateCompanionBuilder = ProductVariantsCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<String> name,
  Value<String?> sku,
  Value<String?> barcode,
  Value<double> priceDelta,
  Value<double> stockQuantity,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$ProductVariantsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductVariantsTable,
    ProductVariantRow,
    $$ProductVariantsTableFilterComposer,
    $$ProductVariantsTableOrderingComposer,
    $$ProductVariantsTableCreateCompanionBuilder,
    $$ProductVariantsTableUpdateCompanionBuilder> {
  $$ProductVariantsTableTableManager(
      _$AppDatabase db, $ProductVariantsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductVariantsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProductVariantsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double> priceDelta = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductVariantsCompanion(
            id: id,
            productId: productId,
            name: name,
            sku: sku,
            barcode: barcode,
            priceDelta: priceDelta,
            stockQuantity: stockQuantity,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String productId,
            required String name,
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double> priceDelta = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductVariantsCompanion.insert(
            id: id,
            productId: productId,
            name: name,
            sku: sku,
            barcode: barcode,
            priceDelta: priceDelta,
            stockQuantity: stockQuantity,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$ProductVariantsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get barcode => $state.composableBuilder(
      column: $state.table.barcode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get priceDelta => $state.composableBuilder(
      column: $state.table.priceDelta,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stockQuantity => $state.composableBuilder(
      column: $state.table.stockQuantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter saleItemsRefs(
      ComposableFilter Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.saleItems,
        getReferencedColumn: (t) => t.variantId,
        builder: (joinBuilder, parentComposers) =>
            $$SaleItemsTableFilterComposer(ComposerState(
                $state.db, $state.db.saleItems, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter inventoryMovementsRefs(
      ComposableFilter Function($$InventoryMovementsTableFilterComposer f) f) {
    final $$InventoryMovementsTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.inventoryMovements,
            getReferencedColumn: (t) => t.variantId,
            builder: (joinBuilder, parentComposers) =>
                $$InventoryMovementsTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.inventoryMovements,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }

  ComposableFilter tpvInventoryRefs(
      ComposableFilter Function($$TpvInventoryTableFilterComposer f) f) {
    final $$TpvInventoryTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.tpvInventory,
        getReferencedColumn: (t) => t.variantId,
        builder: (joinBuilder, parentComposers) =>
            $$TpvInventoryTableFilterComposer(ComposerState($state.db,
                $state.db.tpvInventory, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ProductVariantsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get barcode => $state.composableBuilder(
      column: $state.table.barcode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get priceDelta => $state.composableBuilder(
      column: $state.table.priceDelta,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stockQuantity => $state.composableBuilder(
      column: $state.table.stockQuantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  required String fullName,
  Value<String?> documentId,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<CustomerType> type,
  Value<double> creditLimit,
  Value<double> creditBalance,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<String> fullName,
  Value<String?> documentId,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<CustomerType> type,
  Value<double> creditLimit,
  Value<double> creditBalance,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    CustomerRow,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CustomersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CustomersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String?> documentId = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<CustomerType> type = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<double> creditBalance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            fullName: fullName,
            documentId: documentId,
            phone: phone,
            email: email,
            address: address,
            type: type,
            creditLimit: creditLimit,
            creditBalance: creditBalance,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String fullName,
            Value<String?> documentId = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<CustomerType> type = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<double> creditBalance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            fullName: fullName,
            documentId: documentId,
            phone: phone,
            email: email,
            address: address,
            type: type,
            creditLimit: creditLimit,
            creditBalance: creditBalance,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
        ));
}

class $$CustomersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fullName => $state.composableBuilder(
      column: $state.table.fullName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get documentId => $state.composableBuilder(
      column: $state.table.documentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<CustomerType, CustomerType, int> get type =>
      $state.composableBuilder(
          column: $state.table.type,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<double> get creditLimit => $state.composableBuilder(
      column: $state.table.creditLimit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get creditBalance => $state.composableBuilder(
      column: $state.table.creditBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter salesRefs(
      ComposableFilter Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.sales,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder, parentComposers) => $$SalesTableFilterComposer(
            ComposerState(
                $state.db, $state.db.sales, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fullName => $state.composableBuilder(
      column: $state.table.fullName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get documentId => $state.composableBuilder(
      column: $state.table.documentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get creditLimit => $state.composableBuilder(
      column: $state.table.creditLimit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get creditBalance => $state.composableBuilder(
      column: $state.table.creditBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  required String ticketNumber,
  Value<String?> ticketLabel,
  Value<String?> customerId,
  required String userId,
  Value<String?> cashRegisterId,
  Value<SaleStatus> status,
  Value<double> subtotal,
  Value<double> discountTotal,
  Value<double> taxTotal,
  Value<double> total,
  Value<double> changeGiven,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> paidAt,
  Value<int> rowid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  Value<String> ticketNumber,
  Value<String?> ticketLabel,
  Value<String?> customerId,
  Value<String> userId,
  Value<String?> cashRegisterId,
  Value<SaleStatus> status,
  Value<double> subtotal,
  Value<double> discountTotal,
  Value<double> taxTotal,
  Value<double> total,
  Value<double> changeGiven,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> paidAt,
  Value<int> rowid,
});

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    SaleRow,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SalesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SalesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ticketNumber = const Value.absent(),
            Value<String?> ticketLabel = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> cashRegisterId = const Value.absent(),
            Value<SaleStatus> status = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discountTotal = const Value.absent(),
            Value<double> taxTotal = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<double> changeGiven = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            ticketNumber: ticketNumber,
            ticketLabel: ticketLabel,
            customerId: customerId,
            userId: userId,
            cashRegisterId: cashRegisterId,
            status: status,
            subtotal: subtotal,
            discountTotal: discountTotal,
            taxTotal: taxTotal,
            total: total,
            changeGiven: changeGiven,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            paidAt: paidAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String ticketNumber,
            Value<String?> ticketLabel = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            required String userId,
            Value<String?> cashRegisterId = const Value.absent(),
            Value<SaleStatus> status = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discountTotal = const Value.absent(),
            Value<double> taxTotal = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<double> changeGiven = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            ticketNumber: ticketNumber,
            ticketLabel: ticketLabel,
            customerId: customerId,
            userId: userId,
            cashRegisterId: cashRegisterId,
            status: status,
            subtotal: subtotal,
            discountTotal: discountTotal,
            taxTotal: taxTotal,
            total: total,
            changeGiven: changeGiven,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            paidAt: paidAt,
            rowid: rowid,
          ),
        ));
}

class $$SalesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ticketNumber => $state.composableBuilder(
      column: $state.table.ticketNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ticketLabel => $state.composableBuilder(
      column: $state.table.ticketLabel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cashRegisterId => $state.composableBuilder(
      column: $state.table.cashRegisterId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SaleStatus, SaleStatus, int> get status =>
      $state.composableBuilder(
          column: $state.table.status,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discountTotal => $state.composableBuilder(
      column: $state.table.discountTotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get taxTotal => $state.composableBuilder(
      column: $state.table.taxTotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get total => $state.composableBuilder(
      column: $state.table.total,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get changeGiven => $state.composableBuilder(
      column: $state.table.changeGiven,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get paidAt => $state.composableBuilder(
      column: $state.table.paidAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $state.db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CustomersTableFilterComposer(ComposerState(
                $state.db, $state.db.customers, joinBuilder, parentComposers)));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableFilterComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter saleItemsRefs(
      ComposableFilter Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.saleItems,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder, parentComposers) =>
            $$SaleItemsTableFilterComposer(ComposerState(
                $state.db, $state.db.saleItems, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter paymentsRefs(
      ComposableFilter Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.payments,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder, parentComposers) =>
            $$PaymentsTableFilterComposer(ComposerState(
                $state.db, $state.db.payments, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ticketNumber => $state.composableBuilder(
      column: $state.table.ticketNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ticketLabel => $state.composableBuilder(
      column: $state.table.ticketLabel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cashRegisterId => $state.composableBuilder(
      column: $state.table.cashRegisterId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discountTotal => $state.composableBuilder(
      column: $state.table.discountTotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get taxTotal => $state.composableBuilder(
      column: $state.table.taxTotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get total => $state.composableBuilder(
      column: $state.table.total,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get changeGiven => $state.composableBuilder(
      column: $state.table.changeGiven,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get paidAt => $state.composableBuilder(
      column: $state.table.paidAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $state.db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CustomersTableOrderingComposer(ComposerState(
                $state.db, $state.db.customers, joinBuilder, parentComposers)));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  Value<String> id,
  required String saleId,
  required String productId,
  Value<String?> variantId,
  required String productNameSnapshot,
  required double unitPrice,
  required double quantity,
  Value<double> discount,
  Value<double> taxRate,
  required double lineTotal,
  Value<String?> note,
  Value<bool> isReturn,
  Value<String?> returnReason,
  Value<String?> returnedFromTicket,
  Value<int> rowid,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<String> id,
  Value<String> saleId,
  Value<String> productId,
  Value<String?> variantId,
  Value<String> productNameSnapshot,
  Value<double> unitPrice,
  Value<double> quantity,
  Value<double> discount,
  Value<double> taxRate,
  Value<double> lineTotal,
  Value<String?> note,
  Value<bool> isReturn,
  Value<String?> returnReason,
  Value<String?> returnedFromTicket,
  Value<int> rowid,
});

class $$SaleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItemRow,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder> {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SaleItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SaleItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String?> variantId = const Value.absent(),
            Value<String> productNameSnapshot = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<double> taxRate = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isReturn = const Value.absent(),
            Value<String?> returnReason = const Value.absent(),
            Value<String?> returnedFromTicket = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            saleId: saleId,
            productId: productId,
            variantId: variantId,
            productNameSnapshot: productNameSnapshot,
            unitPrice: unitPrice,
            quantity: quantity,
            discount: discount,
            taxRate: taxRate,
            lineTotal: lineTotal,
            note: note,
            isReturn: isReturn,
            returnReason: returnReason,
            returnedFromTicket: returnedFromTicket,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String saleId,
            required String productId,
            Value<String?> variantId = const Value.absent(),
            required String productNameSnapshot,
            required double unitPrice,
            required double quantity,
            Value<double> discount = const Value.absent(),
            Value<double> taxRate = const Value.absent(),
            required double lineTotal,
            Value<String?> note = const Value.absent(),
            Value<bool> isReturn = const Value.absent(),
            Value<String?> returnReason = const Value.absent(),
            Value<String?> returnedFromTicket = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            saleId: saleId,
            productId: productId,
            variantId: variantId,
            productNameSnapshot: productNameSnapshot,
            unitPrice: unitPrice,
            quantity: quantity,
            discount: discount,
            taxRate: taxRate,
            lineTotal: lineTotal,
            note: note,
            isReturn: isReturn,
            returnReason: returnReason,
            returnedFromTicket: returnedFromTicket,
            rowid: rowid,
          ),
        ));
}

class $$SaleItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get productNameSnapshot => $state.composableBuilder(
      column: $state.table.productNameSnapshot,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discount => $state.composableBuilder(
      column: $state.table.discount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get taxRate => $state.composableBuilder(
      column: $state.table.taxRate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lineTotal => $state.composableBuilder(
      column: $state.table.lineTotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isReturn => $state.composableBuilder(
      column: $state.table.isReturn,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get returnReason => $state.composableBuilder(
      column: $state.table.returnReason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get returnedFromTicket => $state.composableBuilder(
      column: $state.table.returnedFromTicket,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $state.db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$SalesTableFilterComposer(
            ComposerState(
                $state.db, $state.db.sales, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductVariantsTableFilterComposer get variantId {
    final $$ProductVariantsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.variantId,
            referencedTable: $state.db.productVariants,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductVariantsTableFilterComposer(ComposerState($state.db,
                    $state.db.productVariants, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$SaleItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get productNameSnapshot => $state.composableBuilder(
      column: $state.table.productNameSnapshot,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discount => $state.composableBuilder(
      column: $state.table.discount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get taxRate => $state.composableBuilder(
      column: $state.table.taxRate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lineTotal => $state.composableBuilder(
      column: $state.table.lineTotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isReturn => $state.composableBuilder(
      column: $state.table.isReturn,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get returnReason => $state.composableBuilder(
      column: $state.table.returnReason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get returnedFromTicket => $state.composableBuilder(
      column: $state.table.returnedFromTicket,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $state.db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$SalesTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.sales, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get variantId {
    final $$ProductVariantsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.variantId,
            referencedTable: $state.db.productVariants,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductVariantsTableOrderingComposer(ComposerState($state.db,
                    $state.db.productVariants, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<String> id,
  required String saleId,
  required PaymentMethod method,
  required double amount,
  Value<String?> reference,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> id,
  Value<String> saleId,
  Value<PaymentMethod> method,
  Value<double> amount,
  Value<String?> reference,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    PaymentRow,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PaymentsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PaymentsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<PaymentMethod> method = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            saleId: saleId,
            method: method,
            amount: amount,
            reference: reference,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String saleId,
            required PaymentMethod method,
            required double amount,
            Value<String?> reference = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            saleId: saleId,
            method: method,
            amount: amount,
            reference: reference,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$PaymentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<PaymentMethod, PaymentMethod, int>
      get method => $state.composableBuilder(
          column: $state.table.method,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reference => $state.composableBuilder(
      column: $state.table.reference,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $state.db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$SalesTableFilterComposer(
            ComposerState(
                $state.db, $state.db.sales, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reference => $state.composableBuilder(
      column: $state.table.reference,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $state.db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$SalesTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.sales, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$CashRegistersTableCreateCompanionBuilder = CashRegistersCompanion
    Function({
  Value<String> id,
  required String userId,
  Value<String?> shiftLabel,
  required double openingAmount,
  Value<double?> expectedClosingAmount,
  Value<double?> countedClosingAmount,
  Value<double?> difference,
  Value<CashRegisterStatus> status,
  Value<DateTime> openedAt,
  Value<DateTime?> closedAt,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$CashRegistersTableUpdateCompanionBuilder = CashRegistersCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String?> shiftLabel,
  Value<double> openingAmount,
  Value<double?> expectedClosingAmount,
  Value<double?> countedClosingAmount,
  Value<double?> difference,
  Value<CashRegisterStatus> status,
  Value<DateTime> openedAt,
  Value<DateTime?> closedAt,
  Value<String?> note,
  Value<int> rowid,
});

class $$CashRegistersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CashRegistersTable,
    CashRegisterRow,
    $$CashRegistersTableFilterComposer,
    $$CashRegistersTableOrderingComposer,
    $$CashRegistersTableCreateCompanionBuilder,
    $$CashRegistersTableUpdateCompanionBuilder> {
  $$CashRegistersTableTableManager(_$AppDatabase db, $CashRegistersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CashRegistersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CashRegistersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> shiftLabel = const Value.absent(),
            Value<double> openingAmount = const Value.absent(),
            Value<double?> expectedClosingAmount = const Value.absent(),
            Value<double?> countedClosingAmount = const Value.absent(),
            Value<double?> difference = const Value.absent(),
            Value<CashRegisterStatus> status = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CashRegistersCompanion(
            id: id,
            userId: userId,
            shiftLabel: shiftLabel,
            openingAmount: openingAmount,
            expectedClosingAmount: expectedClosingAmount,
            countedClosingAmount: countedClosingAmount,
            difference: difference,
            status: status,
            openedAt: openedAt,
            closedAt: closedAt,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String userId,
            Value<String?> shiftLabel = const Value.absent(),
            required double openingAmount,
            Value<double?> expectedClosingAmount = const Value.absent(),
            Value<double?> countedClosingAmount = const Value.absent(),
            Value<double?> difference = const Value.absent(),
            Value<CashRegisterStatus> status = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CashRegistersCompanion.insert(
            id: id,
            userId: userId,
            shiftLabel: shiftLabel,
            openingAmount: openingAmount,
            expectedClosingAmount: expectedClosingAmount,
            countedClosingAmount: countedClosingAmount,
            difference: difference,
            status: status,
            openedAt: openedAt,
            closedAt: closedAt,
            note: note,
            rowid: rowid,
          ),
        ));
}

class $$CashRegistersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CashRegistersTable> {
  $$CashRegistersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get shiftLabel => $state.composableBuilder(
      column: $state.table.shiftLabel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get openingAmount => $state.composableBuilder(
      column: $state.table.openingAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get expectedClosingAmount => $state.composableBuilder(
      column: $state.table.expectedClosingAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get countedClosingAmount => $state.composableBuilder(
      column: $state.table.countedClosingAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get difference => $state.composableBuilder(
      column: $state.table.difference,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<CashRegisterStatus, CashRegisterStatus, int>
      get status => $state.composableBuilder(
          column: $state.table.status,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get openedAt => $state.composableBuilder(
      column: $state.table.openedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get closedAt => $state.composableBuilder(
      column: $state.table.closedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableFilterComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter cashMovementsRefs(
      ComposableFilter Function($$CashMovementsTableFilterComposer f) f) {
    final $$CashMovementsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.cashMovements,
        getReferencedColumn: (t) => t.cashRegisterId,
        builder: (joinBuilder, parentComposers) =>
            $$CashMovementsTableFilterComposer(ComposerState($state.db,
                $state.db.cashMovements, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CashRegistersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CashRegistersTable> {
  $$CashRegistersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get shiftLabel => $state.composableBuilder(
      column: $state.table.shiftLabel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get openingAmount => $state.composableBuilder(
      column: $state.table.openingAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get expectedClosingAmount => $state.composableBuilder(
      column: $state.table.expectedClosingAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get countedClosingAmount => $state.composableBuilder(
      column: $state.table.countedClosingAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get difference => $state.composableBuilder(
      column: $state.table.difference,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get openedAt => $state.composableBuilder(
      column: $state.table.openedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get closedAt => $state.composableBuilder(
      column: $state.table.closedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$CashMovementsTableCreateCompanionBuilder = CashMovementsCompanion
    Function({
  Value<String> id,
  required String cashRegisterId,
  Value<String?> saleId,
  required CashMovementType type,
  required double amount,
  Value<int?> method,
  Value<String?> description,
  required String userId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CashMovementsTableUpdateCompanionBuilder = CashMovementsCompanion
    Function({
  Value<String> id,
  Value<String> cashRegisterId,
  Value<String?> saleId,
  Value<CashMovementType> type,
  Value<double> amount,
  Value<int?> method,
  Value<String?> description,
  Value<String> userId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CashMovementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CashMovementsTable,
    CashMovementRow,
    $$CashMovementsTableFilterComposer,
    $$CashMovementsTableOrderingComposer,
    $$CashMovementsTableCreateCompanionBuilder,
    $$CashMovementsTableUpdateCompanionBuilder> {
  $$CashMovementsTableTableManager(_$AppDatabase db, $CashMovementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CashMovementsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CashMovementsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cashRegisterId = const Value.absent(),
            Value<String?> saleId = const Value.absent(),
            Value<CashMovementType> type = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int?> method = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CashMovementsCompanion(
            id: id,
            cashRegisterId: cashRegisterId,
            saleId: saleId,
            type: type,
            amount: amount,
            method: method,
            description: description,
            userId: userId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String cashRegisterId,
            Value<String?> saleId = const Value.absent(),
            required CashMovementType type,
            required double amount,
            Value<int?> method = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required String userId,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CashMovementsCompanion.insert(
            id: id,
            cashRegisterId: cashRegisterId,
            saleId: saleId,
            type: type,
            amount: amount,
            method: method,
            description: description,
            userId: userId,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$CashMovementsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get saleId => $state.composableBuilder(
      column: $state.table.saleId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<CashMovementType, CashMovementType, int>
      get type => $state.composableBuilder(
          column: $state.table.type,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CashRegistersTableFilterComposer get cashRegisterId {
    final $$CashRegistersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashRegisterId,
        referencedTable: $state.db.cashRegisters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CashRegistersTableFilterComposer(ComposerState($state.db,
                $state.db.cashRegisters, joinBuilder, parentComposers)));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableFilterComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$CashMovementsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get saleId => $state.composableBuilder(
      column: $state.table.saleId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CashRegistersTableOrderingComposer get cashRegisterId {
    final $$CashRegistersTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.cashRegisterId,
            referencedTable: $state.db.cashRegisters,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$CashRegistersTableOrderingComposer(ComposerState($state.db,
                    $state.db.cashRegisters, joinBuilder, parentComposers)));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$InventoryMovementsTableCreateCompanionBuilder
    = InventoryMovementsCompanion Function({
  Value<String> id,
  required String productId,
  Value<String?> variantId,
  required InventoryMovementType type,
  required double quantity,
  required double stockBefore,
  required double stockAfter,
  Value<String?> reason,
  Value<String?> referenceId,
  required String userId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$InventoryMovementsTableUpdateCompanionBuilder
    = InventoryMovementsCompanion Function({
  Value<String> id,
  Value<String> productId,
  Value<String?> variantId,
  Value<InventoryMovementType> type,
  Value<double> quantity,
  Value<double> stockBefore,
  Value<double> stockAfter,
  Value<String?> reason,
  Value<String?> referenceId,
  Value<String> userId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$InventoryMovementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryMovementsTable,
    InventoryMovementRow,
    $$InventoryMovementsTableFilterComposer,
    $$InventoryMovementsTableOrderingComposer,
    $$InventoryMovementsTableCreateCompanionBuilder,
    $$InventoryMovementsTableUpdateCompanionBuilder> {
  $$InventoryMovementsTableTableManager(
      _$AppDatabase db, $InventoryMovementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$InventoryMovementsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$InventoryMovementsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String?> variantId = const Value.absent(),
            Value<InventoryMovementType> type = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> stockBefore = const Value.absent(),
            Value<double> stockAfter = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryMovementsCompanion(
            id: id,
            productId: productId,
            variantId: variantId,
            type: type,
            quantity: quantity,
            stockBefore: stockBefore,
            stockAfter: stockAfter,
            reason: reason,
            referenceId: referenceId,
            userId: userId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String productId,
            Value<String?> variantId = const Value.absent(),
            required InventoryMovementType type,
            required double quantity,
            required double stockBefore,
            required double stockAfter,
            Value<String?> reason = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            required String userId,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryMovementsCompanion.insert(
            id: id,
            productId: productId,
            variantId: variantId,
            type: type,
            quantity: quantity,
            stockBefore: stockBefore,
            stockAfter: stockAfter,
            reason: reason,
            referenceId: referenceId,
            userId: userId,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$InventoryMovementsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InventoryMovementsTable> {
  $$InventoryMovementsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<InventoryMovementType, InventoryMovementType,
          int>
      get type => $state.composableBuilder(
          column: $state.table.type,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stockBefore => $state.composableBuilder(
      column: $state.table.stockBefore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stockAfter => $state.composableBuilder(
      column: $state.table.stockAfter,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get referenceId => $state.composableBuilder(
      column: $state.table.referenceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductVariantsTableFilterComposer get variantId {
    final $$ProductVariantsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.variantId,
            referencedTable: $state.db.productVariants,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductVariantsTableFilterComposer(ComposerState($state.db,
                    $state.db.productVariants, joinBuilder, parentComposers)));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableFilterComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$InventoryMovementsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InventoryMovementsTable> {
  $$InventoryMovementsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stockBefore => $state.composableBuilder(
      column: $state.table.stockBefore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stockAfter => $state.composableBuilder(
      column: $state.table.stockAfter,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get referenceId => $state.composableBuilder(
      column: $state.table.referenceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get variantId {
    final $$ProductVariantsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.variantId,
            referencedTable: $state.db.productVariants,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductVariantsTableOrderingComposer(ComposerState($state.db,
                    $state.db.productVariants, joinBuilder, parentComposers)));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PrinterConfigsTableCreateCompanionBuilder = PrinterConfigsCompanion
    Function({
  Value<String> id,
  required String name,
  required PrinterConnectionType connectionType,
  required String address,
  Value<int?> port,
  Value<PrinterPaperWidth> paperWidth,
  Value<bool> autoCut,
  Value<String?> logoPath,
  Value<String?> headerText,
  Value<String?> footerText,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PrinterConfigsTableUpdateCompanionBuilder = PrinterConfigsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<PrinterConnectionType> connectionType,
  Value<String> address,
  Value<int?> port,
  Value<PrinterPaperWidth> paperWidth,
  Value<bool> autoCut,
  Value<String?> logoPath,
  Value<String?> headerText,
  Value<String?> footerText,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$PrinterConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrinterConfigsTable,
    PrinterConfigRow,
    $$PrinterConfigsTableFilterComposer,
    $$PrinterConfigsTableOrderingComposer,
    $$PrinterConfigsTableCreateCompanionBuilder,
    $$PrinterConfigsTableUpdateCompanionBuilder> {
  $$PrinterConfigsTableTableManager(
      _$AppDatabase db, $PrinterConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PrinterConfigsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PrinterConfigsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<PrinterConnectionType> connectionType = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<int?> port = const Value.absent(),
            Value<PrinterPaperWidth> paperWidth = const Value.absent(),
            Value<bool> autoCut = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> headerText = const Value.absent(),
            Value<String?> footerText = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrinterConfigsCompanion(
            id: id,
            name: name,
            connectionType: connectionType,
            address: address,
            port: port,
            paperWidth: paperWidth,
            autoCut: autoCut,
            logoPath: logoPath,
            headerText: headerText,
            footerText: footerText,
            isFavorite: isFavorite,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            required PrinterConnectionType connectionType,
            required String address,
            Value<int?> port = const Value.absent(),
            Value<PrinterPaperWidth> paperWidth = const Value.absent(),
            Value<bool> autoCut = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> headerText = const Value.absent(),
            Value<String?> footerText = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrinterConfigsCompanion.insert(
            id: id,
            name: name,
            connectionType: connectionType,
            address: address,
            port: port,
            paperWidth: paperWidth,
            autoCut: autoCut,
            logoPath: logoPath,
            headerText: headerText,
            footerText: footerText,
            isFavorite: isFavorite,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$PrinterConfigsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PrinterConfigsTable> {
  $$PrinterConfigsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<PrinterConnectionType, PrinterConnectionType,
          int>
      get connectionType => $state.composableBuilder(
          column: $state.table.connectionType,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get port => $state.composableBuilder(
      column: $state.table.port,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<PrinterPaperWidth, PrinterPaperWidth, int>
      get paperWidth => $state.composableBuilder(
          column: $state.table.paperWidth,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<bool> get autoCut => $state.composableBuilder(
      column: $state.table.autoCut,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get logoPath => $state.composableBuilder(
      column: $state.table.logoPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get headerText => $state.composableBuilder(
      column: $state.table.headerText,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get footerText => $state.composableBuilder(
      column: $state.table.footerText,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PrinterConfigsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PrinterConfigsTable> {
  $$PrinterConfigsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get connectionType => $state.composableBuilder(
      column: $state.table.connectionType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get port => $state.composableBuilder(
      column: $state.table.port,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get paperWidth => $state.composableBuilder(
      column: $state.table.paperWidth,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get autoCut => $state.composableBuilder(
      column: $state.table.autoCut,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get logoPath => $state.composableBuilder(
      column: $state.table.logoPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get headerText => $state.composableBuilder(
      column: $state.table.headerText,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get footerText => $state.composableBuilder(
      column: $state.table.footerText,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ReceiptConfigsTableCreateCompanionBuilder = ReceiptConfigsCompanion
    Function({
  required String id,
  Value<String?> branchId,
  Value<String?> businessName,
  Value<String?> taxId,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> header,
  Value<String?> footer,
  Value<String?> thankYouMessage,
  Value<String?> logoUrl,
  Value<String?> logoPrintUrl,
  Value<bool> showLogo,
  Value<bool> showTaxId,
  Value<bool> showAddress,
  Value<bool> showPhone,
  Value<int> printCopies,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ReceiptConfigsTableUpdateCompanionBuilder = ReceiptConfigsCompanion
    Function({
  Value<String> id,
  Value<String?> branchId,
  Value<String?> businessName,
  Value<String?> taxId,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> header,
  Value<String?> footer,
  Value<String?> thankYouMessage,
  Value<String?> logoUrl,
  Value<String?> logoPrintUrl,
  Value<bool> showLogo,
  Value<bool> showTaxId,
  Value<bool> showAddress,
  Value<bool> showPhone,
  Value<int> printCopies,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ReceiptConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReceiptConfigsTable,
    ReceiptConfigRow,
    $$ReceiptConfigsTableFilterComposer,
    $$ReceiptConfigsTableOrderingComposer,
    $$ReceiptConfigsTableCreateCompanionBuilder,
    $$ReceiptConfigsTableUpdateCompanionBuilder> {
  $$ReceiptConfigsTableTableManager(
      _$AppDatabase db, $ReceiptConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ReceiptConfigsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ReceiptConfigsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> branchId = const Value.absent(),
            Value<String?> businessName = const Value.absent(),
            Value<String?> taxId = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> header = const Value.absent(),
            Value<String?> footer = const Value.absent(),
            Value<String?> thankYouMessage = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<String?> logoPrintUrl = const Value.absent(),
            Value<bool> showLogo = const Value.absent(),
            Value<bool> showTaxId = const Value.absent(),
            Value<bool> showAddress = const Value.absent(),
            Value<bool> showPhone = const Value.absent(),
            Value<int> printCopies = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceiptConfigsCompanion(
            id: id,
            branchId: branchId,
            businessName: businessName,
            taxId: taxId,
            address: address,
            phone: phone,
            header: header,
            footer: footer,
            thankYouMessage: thankYouMessage,
            logoUrl: logoUrl,
            logoPrintUrl: logoPrintUrl,
            showLogo: showLogo,
            showTaxId: showTaxId,
            showAddress: showAddress,
            showPhone: showPhone,
            printCopies: printCopies,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> branchId = const Value.absent(),
            Value<String?> businessName = const Value.absent(),
            Value<String?> taxId = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> header = const Value.absent(),
            Value<String?> footer = const Value.absent(),
            Value<String?> thankYouMessage = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<String?> logoPrintUrl = const Value.absent(),
            Value<bool> showLogo = const Value.absent(),
            Value<bool> showTaxId = const Value.absent(),
            Value<bool> showAddress = const Value.absent(),
            Value<bool> showPhone = const Value.absent(),
            Value<int> printCopies = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceiptConfigsCompanion.insert(
            id: id,
            branchId: branchId,
            businessName: businessName,
            taxId: taxId,
            address: address,
            phone: phone,
            header: header,
            footer: footer,
            thankYouMessage: thankYouMessage,
            logoUrl: logoUrl,
            logoPrintUrl: logoPrintUrl,
            showLogo: showLogo,
            showTaxId: showTaxId,
            showAddress: showAddress,
            showPhone: showPhone,
            printCopies: printCopies,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$ReceiptConfigsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ReceiptConfigsTable> {
  $$ReceiptConfigsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get branchId => $state.composableBuilder(
      column: $state.table.branchId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get businessName => $state.composableBuilder(
      column: $state.table.businessName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get taxId => $state.composableBuilder(
      column: $state.table.taxId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get header => $state.composableBuilder(
      column: $state.table.header,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get footer => $state.composableBuilder(
      column: $state.table.footer,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get thankYouMessage => $state.composableBuilder(
      column: $state.table.thankYouMessage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get logoUrl => $state.composableBuilder(
      column: $state.table.logoUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get logoPrintUrl => $state.composableBuilder(
      column: $state.table.logoPrintUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showLogo => $state.composableBuilder(
      column: $state.table.showLogo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showTaxId => $state.composableBuilder(
      column: $state.table.showTaxId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showAddress => $state.composableBuilder(
      column: $state.table.showAddress,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showPhone => $state.composableBuilder(
      column: $state.table.showPhone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get printCopies => $state.composableBuilder(
      column: $state.table.printCopies,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ReceiptConfigsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ReceiptConfigsTable> {
  $$ReceiptConfigsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get branchId => $state.composableBuilder(
      column: $state.table.branchId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get businessName => $state.composableBuilder(
      column: $state.table.businessName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get taxId => $state.composableBuilder(
      column: $state.table.taxId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get header => $state.composableBuilder(
      column: $state.table.header,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get footer => $state.composableBuilder(
      column: $state.table.footer,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get thankYouMessage => $state.composableBuilder(
      column: $state.table.thankYouMessage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get logoUrl => $state.composableBuilder(
      column: $state.table.logoUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get logoPrintUrl => $state.composableBuilder(
      column: $state.table.logoPrintUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showLogo => $state.composableBuilder(
      column: $state.table.showLogo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showTaxId => $state.composableBuilder(
      column: $state.table.showTaxId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showAddress => $state.composableBuilder(
      column: $state.table.showAddress,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showPhone => $state.composableBuilder(
      column: $state.table.showPhone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get printCopies => $state.composableBuilder(
      column: $state.table.printCopies,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PaymentMethodsTableCreateCompanionBuilder = PaymentMethodsCompanion
    Function({
  Value<String> id,
  required int code,
  required String label,
  Value<String> icon,
  Value<bool> isActive,
  Value<bool> isCredit,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$PaymentMethodsTableUpdateCompanionBuilder = PaymentMethodsCompanion
    Function({
  Value<String> id,
  Value<int> code,
  Value<String> label,
  Value<String> icon,
  Value<bool> isActive,
  Value<bool> isCredit,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PaymentMethodsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentMethodsTable,
    PaymentMethodRow,
    $$PaymentMethodsTableFilterComposer,
    $$PaymentMethodsTableOrderingComposer,
    $$PaymentMethodsTableCreateCompanionBuilder,
    $$PaymentMethodsTableUpdateCompanionBuilder> {
  $$PaymentMethodsTableTableManager(
      _$AppDatabase db, $PaymentMethodsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PaymentMethodsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PaymentMethodsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> code = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isCredit = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentMethodsCompanion(
            id: id,
            code: code,
            label: label,
            icon: icon,
            isActive: isActive,
            isCredit: isCredit,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required int code,
            required String label,
            Value<String> icon = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isCredit = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentMethodsCompanion.insert(
            id: id,
            code: code,
            label: label,
            icon: icon,
            isActive: isActive,
            isCredit: isCredit,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$PaymentMethodsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get label => $state.composableBuilder(
      column: $state.table.label,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isCredit => $state.composableBuilder(
      column: $state.table.isCredit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PaymentMethodsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get label => $state.composableBuilder(
      column: $state.table.label,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isCredit => $state.composableBuilder(
      column: $state.table.isCredit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TpvInventoryTableCreateCompanionBuilder = TpvInventoryCompanion
    Function({
  Value<String> id,
  required String productId,
  Value<String?> variantId,
  Value<double> stock,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$TpvInventoryTableUpdateCompanionBuilder = TpvInventoryCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<String?> variantId,
  Value<double> stock,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TpvInventoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TpvInventoryTable,
    TpvInventoryRow,
    $$TpvInventoryTableFilterComposer,
    $$TpvInventoryTableOrderingComposer,
    $$TpvInventoryTableCreateCompanionBuilder,
    $$TpvInventoryTableUpdateCompanionBuilder> {
  $$TpvInventoryTableTableManager(_$AppDatabase db, $TpvInventoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TpvInventoryTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TpvInventoryTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String?> variantId = const Value.absent(),
            Value<double> stock = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TpvInventoryCompanion(
            id: id,
            productId: productId,
            variantId: variantId,
            stock: stock,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String productId,
            Value<String?> variantId = const Value.absent(),
            Value<double> stock = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TpvInventoryCompanion.insert(
            id: id,
            productId: productId,
            variantId: variantId,
            stock: stock,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$TpvInventoryTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TpvInventoryTable> {
  $$TpvInventoryTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stock => $state.composableBuilder(
      column: $state.table.stock,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductVariantsTableFilterComposer get variantId {
    final $$ProductVariantsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.variantId,
            referencedTable: $state.db.productVariants,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductVariantsTableFilterComposer(ComposerState($state.db,
                    $state.db.productVariants, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TpvInventoryTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TpvInventoryTable> {
  $$TpvInventoryTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stock => $state.composableBuilder(
      column: $state.table.stock,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get variantId {
    final $$ProductVariantsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.variantId,
            referencedTable: $state.db.productVariants,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductVariantsTableOrderingComposer(ComposerState($state.db,
                    $state.db.productVariants, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$SyncQueueItemsTableCreateCompanionBuilder = SyncQueueItemsCompanion
    Function({
  Value<String> id,
  required String entityTable,
  required String entityId,
  required SyncOperation operation,
  required String payloadJson,
  Value<SyncStatus> status,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SyncQueueItemsTableUpdateCompanionBuilder = SyncQueueItemsCompanion
    Function({
  Value<String> id,
  Value<String> entityTable,
  Value<String> entityId,
  Value<SyncOperation> operation,
  Value<String> payloadJson,
  Value<SyncStatus> status,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncQueueItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueItemsTable,
    SyncQueueRow,
    $$SyncQueueItemsTableFilterComposer,
    $$SyncQueueItemsTableOrderingComposer,
    $$SyncQueueItemsTableCreateCompanionBuilder,
    $$SyncQueueItemsTableUpdateCompanionBuilder> {
  $$SyncQueueItemsTableTableManager(
      _$AppDatabase db, $SyncQueueItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SyncQueueItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SyncQueueItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityTable = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<SyncOperation> operation = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<SyncStatus> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueItemsCompanion(
            id: id,
            entityTable: entityTable,
            entityId: entityId,
            operation: operation,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String entityTable,
            required String entityId,
            required SyncOperation operation,
            required String payloadJson,
            Value<SyncStatus> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueItemsCompanion.insert(
            id: id,
            entityTable: entityTable,
            entityId: entityId,
            operation: operation,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$SyncQueueItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entityTable => $state.composableBuilder(
      column: $state.table.entityTable,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entityId => $state.composableBuilder(
      column: $state.table.entityId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncOperation, SyncOperation, int>
      get operation => $state.composableBuilder(
          column: $state.table.operation,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get payloadJson => $state.composableBuilder(
      column: $state.table.payloadJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, int> get status =>
      $state.composableBuilder(
          column: $state.table.status,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lastError => $state.composableBuilder(
      column: $state.table.lastError,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SyncQueueItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entityTable => $state.composableBuilder(
      column: $state.table.entityTable,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entityId => $state.composableBuilder(
      column: $state.table.entityId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get operation => $state.composableBuilder(
      column: $state.table.operation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get payloadJson => $state.composableBuilder(
      column: $state.table.payloadJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lastError => $state.composableBuilder(
      column: $state.table.lastError,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingRow,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AppSettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AppSettingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
        ));
}

class $$AppSettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer(super.$state);
  ColumnFilters<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AppSettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db, _db.brands);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductVariantsTableTableManager get productVariants =>
      $$ProductVariantsTableTableManager(_db, _db.productVariants);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$CashRegistersTableTableManager get cashRegisters =>
      $$CashRegistersTableTableManager(_db, _db.cashRegisters);
  $$CashMovementsTableTableManager get cashMovements =>
      $$CashMovementsTableTableManager(_db, _db.cashMovements);
  $$InventoryMovementsTableTableManager get inventoryMovements =>
      $$InventoryMovementsTableTableManager(_db, _db.inventoryMovements);
  $$PrinterConfigsTableTableManager get printerConfigs =>
      $$PrinterConfigsTableTableManager(_db, _db.printerConfigs);
  $$ReceiptConfigsTableTableManager get receiptConfigs =>
      $$ReceiptConfigsTableTableManager(_db, _db.receiptConfigs);
  $$PaymentMethodsTableTableManager get paymentMethods =>
      $$PaymentMethodsTableTableManager(_db, _db.paymentMethods);
  $$TpvInventoryTableTableManager get tpvInventory =>
      $$TpvInventoryTableTableManager(_db, _db.tpvInventory);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
