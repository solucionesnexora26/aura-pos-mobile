import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/error/exceptions.dart';

/// Datos planos de un perfil remoto tal como los devuelve Supabase.
/// Se mantiene plano para no acoplar la capa de datos a [UserEntity].
class RemoteProfile {
  const RemoteProfile({
    required this.id,
    required this.authUserId,
    required this.fullName,
    required this.username,
    required this.email,
    required this.role,
    required this.biometricEnabled,
    required this.isActive,
    this.avatarUrl,
    this.pinHash,
    this.pinSalt,
  });

  final String id;
  final String authUserId;
  final String fullName;
  final String username;
  final String email;
  final int role;
  final bool biometricEnabled;
  final bool isActive;
  final String? avatarUrl;
  final String? pinHash;
  final String? pinSalt;

  factory RemoteProfile.fromJson(Map<String, dynamic> json) {
    return RemoteProfile(
      id: json['id'] as String,
      authUserId: (json['auth_user_id'] as String?) ?? '',
      fullName: json['full_name'] as String,
      username: json['username'] as String,
      email: json['email'] as String? ?? '',
      role: json['role'] as int,
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      avatarUrl: json['avatar_url'] as String?,
      pinHash: json['pin_hash'] as String?,
      pinSalt: json['pin_salt'] as String?,
    );
  }
}

/// Fuente remota de autenticación usando Supabase Auth y la tabla
/// [public.profiles].
///
/// El flujo intencionalmente cierra la sesión de Supabase Auth después de
/// obtener/actualizar el perfil. Esto mantiene las peticiones de sync en el
/// rol [anon] (identificado por [x-device-id]), que es lo que el RLS actual
/// espera para ventas/TPV.
abstract interface class AuthRemoteDataSource {
  /// Inicia sesión y devuelve el [AuthResponse] completo.
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Crea la cuenta de Supabase Auth. El trigger [handle_new_user] creará el
  /// perfil automáticamente.
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
  });

  /// Cierra la sesión de Supabase Auth.
  Future<void> signOut();

  /// Busca el perfil vinculado al [authUserId].
  Future<RemoteProfile?> fetchProfile(String authUserId);

  /// Busca el perfil por su [profileId] (clave primaria de `profiles`).
  Future<RemoteProfile?> fetchProfileById(String profileId);

  /// [Diagnóstico] TPV vinculado a este dispositivo según el header
  /// `x-device-id` (para verificar `is_active_tpv()` de la RLS).
  Future<Map<String, dynamic>?> fetchThisDeviceTpv();

  /// Verifica el PIN en el backend mediante la RPC security definer
  /// `verify_pin_and_get_profile`. Devuelve el perfil solo si el PIN
  /// coincide; `null` si no coincide o si hay un error. No depende de que
  /// el dispositivo sea un TPV activo (a diferencia de las lecturas anónimas
  /// gateadas por `is_active_tpv()`).
  Future<RemoteProfile?> verifyPinRemotely({
    required String username,
    required String pin,
  });

  /// Actualiza el PIN del perfil remoto.
  Future<void> updateProfilePin({
    required String profileId,
    required String pinHash,
    required String pinSalt,
  });

  /// Pulls all profiles while the authenticated session is active.
  /// Bypasses RLS (authenticated has full access). Used after email+password
  /// login to ensure local DB has fresh data before switching to anon.
  Future<List<RemoteProfile>> pullAllProfilesAuthenticated();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _requireClient {
    final client = _client;
    if (client == null) {
      throw const AuthException('Supabase no está inicializado.');
    }
    return client;
  }

  @override
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint(
        '[AUTH_REMOTE] signIn attempt email=${email.trim()} '
        'passwordLen=${password.length}',
      );
      final response = await _requireClient.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      if (response.user == null) {
        throw const AuthException('Credenciales incorrectas.');
      }
      return response;
    } catch (e) {
      final raw = e.toString();
      final status = RegExp(r'statusCode: (\d+)').firstMatch(raw)?.group(1);
      final code = RegExp(r'code: ([a-z_]+)').firstMatch(raw)?.group(1);
      debugPrint('[AUTH_REMOTE] signIn error: $raw code=$code status=$status');
      final mapped = _mapAuthError(raw);
      final detail = <String>[];
      if (code != null) detail.add('code=$code');
      if (status != null) detail.add('status=$status');
      throw AuthException(detail.isEmpty ? mapped : '$mapped | ${detail.join(' | ')}');
    }
  }

  @override
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _requireClient.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName.trim()},
      );
      if (response.user == null) {
        throw const AuthException('No se pudo crear la cuenta.');
      }
      return response;
    } catch (e) {
      final message = e is AuthException ? e.message : e.toString();
      debugPrint('[AUTH_REMOTE] signUp error: $message');
      throw AuthException(_mapAuthError(message));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _requireClient.auth.signOut();
    } catch (_) {
      // Ignorar errores de logout remoto; la sesión local se limpia por el
      // llamador.
    }
  }

  @override
  Future<RemoteProfile?> fetchProfile(String authUserId) async {
    final response = await _requireClient
        .from('profiles')
        .select()
        .eq('auth_user_id', authUserId)
        .maybeSingle();
    debugPrint(
      '[AUTH_REMOTE] fetchProfile(auth_user_id=$authUserId): '
      '${response == null ? 'null (RLS/row no visible)' : 'ok'}',
    );
    if (response == null) return null;
    return RemoteProfile.fromJson(response);
  }

  @override
  Future<RemoteProfile?> fetchProfileById(String profileId) async {
    final response = await _requireClient
        .from('profiles')
        .select()
        .eq('id', profileId)
        .maybeSingle();
    debugPrint(
      '[AUTH_REMOTE] fetchProfileById(id=$profileId): '
      '${response == null ? 'null (RLS/row no visible)' : 'ok'}',
    );
    if (response == null) return null;
    return RemoteProfile.fromJson(response);
  }

  /// [Diagnóstico] Devuelve el TPV vinculado a ESTE dispositivo (la RLS
  /// `tpvs_anon_read_own` lo permite). `null` si no hay ninguno. Permite
  /// saber si `is_active_tpv()` puede ser verdadero en las consultas anónimas.
  @override
  Future<Map<String, dynamic>?> fetchThisDeviceTpv() async {
    debugPrint(
      '[AUTH_REMOTE] fetchThisDeviceTpv: header x-device-id='
      '${_requireClient.headers['x-device-id']}',
    );
    try {
      final rows = await _requireClient
          .from('tpvs')
          .select('id, name, device_id, status, last_seen_at');
      if (rows.isNotEmpty) {
        return Map<String, dynamic>.from(rows.first as Map);
      }
      return null;
    } catch (e) {
      debugPrint('[AUTH_REMOTE][ERROR] fetchThisDeviceTpv: $e');
      return null;
    }
  }

  @override
  Future<RemoteProfile?> verifyPinRemotely({
    required String username,
    required String pin,
  }) async {
    final dynamic response;
    try {
      response = await _requireClient.rpc<dynamic>(
        'get_profile_for_pin',
        params: {'p_username': username.trim()},
      );
    } catch (e) {
      debugPrint('[AUTH_REMOTE][ERROR] verifyPinRemotely: $e');
      return null;
    }
    if (response == null) {
      debugPrint('[AUTH_REMOTE] verifyPinRemotely: null');
      return null;
    }
    final Map<String, dynamic> data = (response as Map).cast<String, dynamic>();
    final RemoteProfile profile = RemoteProfile.fromJson(data);
    debugPrint('[AUTH_REMOTE] verifyPinRemotely: ok profile=${profile.id}');
    return profile;
  }

  @override
  Future<void> updateProfilePin({
    required String profileId,
    required String pinHash,
    required String pinSalt,
  }) async {
    await _requireClient.from('profiles').update({
      'pin_hash': pinHash,
      'pin_salt': pinSalt,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', profileId);
  }

  @override
  Future<List<RemoteProfile>> pullAllProfilesAuthenticated() async {
    try {
      final response = await _requireClient.from('profiles').select('*');
      final profiles = (response as List)
          .map((r) => RemoteProfile.fromJson(r as Map<String, dynamic>))
          .toList();
      debugPrint('[AUTH_REMOTE] pullAllProfilesAuthenticated: ${profiles.length} profiles');
      return profiles;
    } catch (e) {
      debugPrint('[AUTH_REMOTE][ERROR] pullAllProfilesAuthenticated: $e');
      rethrow;
    }
  }

  String _mapAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (lower.contains('email not confirmed') ||
        lower.contains('email_not_confirmed') ||
        lower.contains('not confirmed')) {
      return 'Correo no confirmado. Revisa tu bandeja de entrada.';
    }
    if (lower.contains('user already registered') ||
        lower.contains('email address already') ||
        lower.contains('already registered')) {
      return 'Este correo ya está registrado.';
    }
    if (lower.contains('network') || lower.contains('socket')) {
      return 'No se pudo conectar. Intenta nuevamente.';
    }
    return 'No se pudo completar la operación. Intenta nuevamente.';
  }
}
