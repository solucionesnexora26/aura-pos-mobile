import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/sync/supabase_providers.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/change_pin_usecase.dart';
import '../../domain/usecases/get_active_users_usecase.dart';
import '../../domain/usecases/get_current_session_usecase.dart';
import '../../domain/usecases/login_with_biometrics_usecase.dart';
import '../../domain/usecases/login_with_pin_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/recover_pin_usecase.dart';
import '../../../pos/presentation/providers/pos_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATASOURCE
// ─────────────────────────────────────────────────────────────────────────────

final Provider<AuthLocalDataSource> authLocalDataSourceProvider =
    Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    database: ref.watch(appDatabaseProvider),
    secureStorage: ref.watch(secureStorageProvider),
    preferencesBox: ref.watch(preferencesBoxProvider),
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// REPOSITORY
// ─────────────────────────────────────────────────────────────────────────────

final Provider<AuthRemoteDataSource> authRemoteDataSourceProvider =
    Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(client: ref.watch(supabaseClientProvider));
});

final Provider<AuthRepository> authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    localDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    database: ref.watch(appDatabaseProvider),
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// USECASES
// ─────────────────────────────────────────────────────────────────────────────

final Provider<LoginWithPinUseCase> loginWithPinUseCaseProvider =
    Provider<LoginWithPinUseCase>((ref) =>
        LoginWithPinUseCase(ref.watch(authRepositoryProvider)));

final Provider<LoginWithBiometricsUseCase> loginWithBiometricsUseCaseProvider =
    Provider<LoginWithBiometricsUseCase>((ref) =>
        LoginWithBiometricsUseCase(ref.watch(authRepositoryProvider)));

final Provider<LogoutUseCase> logoutUseCaseProvider =
    Provider<LogoutUseCase>((ref) =>
        LogoutUseCase(ref.watch(authRepositoryProvider)));

final Provider<GetActiveUsersUseCase> getActiveUsersUseCaseProvider =
    Provider<GetActiveUsersUseCase>((ref) =>
        GetActiveUsersUseCase(ref.watch(authRepositoryProvider)));

final Provider<ChangePinUseCase> changePinUseCaseProvider =
    Provider<ChangePinUseCase>((ref) =>
        ChangePinUseCase(ref.watch(authRepositoryProvider)));

final Provider<RecoverPinUseCase> recoverPinUseCaseProvider =
    Provider<RecoverPinUseCase>((ref) =>
        RecoverPinUseCase(ref.watch(authRepositoryProvider)));

final Provider<GetCurrentSessionUseCase> getCurrentSessionUseCaseProvider =
    Provider<GetCurrentSessionUseCase>((ref) =>
        GetCurrentSessionUseCase(ref.watch(authRepositoryProvider)));

// ─────────────────────────────────────────────────────────────────────────────
// SESSION STATE
// ─────────────────────────────────────────────────────────────────────────────

class AuthSessionState {
  const AuthSessionState({
    this.user,
    required this.isAuthenticated,
    this.errorMessage,
    this.requiresPinSetup = false,
  });
  final UserEntity? user;
  final bool isAuthenticated;
  final String? errorMessage;

  /// Indica que el usuario inició sesión correctamente pero aún no tiene un
  /// PIN configurado (p. ej. registro con confirmación de email).
  final bool requiresPinSetup;
}

class AuthSessionNotifier extends Notifier<AuthSessionState> {
  @override
  AuthSessionState build() {
    // Carga la sesión guardada en segundo plano.
    Future.microtask(_initSession);
    return const AuthSessionState(user: null, isAuthenticated: false);
  }

  Future<void> _initSession() async {
    final result = await ref
        .read(getCurrentSessionUseCaseProvider)
        .call(const NoParams());
    await result.fold(
      (failure) async {
        state = AuthSessionState(
          user: null,
          isAuthenticated: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) async {
        if (user != null && Validators.isValidUuid(user.id)) {
          await _migrateLegacySales(user.id);
        }
        // Se carga el usuario recordado pero NO se autentica; el desbloqueo
        // con PIN es obligatorio al reiniciar la app.
        state = AuthSessionState(
          user: user,
          isAuthenticated: false,
        );
        return true;
      },
    );
    // La restauración de sesión terminó: el router ya puede decidir a dónde ir
    // (PIN, login o dashboard) sin quedar pegado en /login.
    ref.read(sessionLoadedProvider.notifier).state = true;
  }

  Future<void> _migrateLegacySales(String validUserId) async {
    try {
      final migrated = await ref
          .read(saleRepositoryProvider)
          .migrateLegacyDevUserSales(validUserId);
      if (migrated > 0) {
        debugPrint('[AUTH] migrated $migrated legacy sales to userId=$validUserId');
      }
    } catch (e) {
      debugPrint('[AUTH][ERROR] failed to migrate legacy sales: $e');
    }
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final result = await ref.read(authRepositoryProvider).loginWithEmailPassword(
          email: email,
          password: password,
        );
    await result.fold(
      (failure) async {
        state = AuthSessionState(
          user: null,
          isAuthenticated: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) async {
        if (Validators.isValidUuid(user.id)) {
          await _migrateLegacySales(user.id);
        }
        final hasPinResult = await ref.read(authRepositoryProvider).userHasPin(user.id);
        final hasPin = hasPinResult.getOrElse((_) => false);
        if (hasPin) {
          state = AuthSessionState(user: user, isAuthenticated: true);
        } else {
          state = AuthSessionState(
            user: user,
            isAuthenticated: false,
            requiresPinSetup: true,
          );
        }
        return true;
      },
    );
  }

  Future<void> registerEmployee({
    required String fullName,
    required String email,
    required String password,
    required String pin,
  }) async {
    final result = await ref.read(authRepositoryProvider).registerEmployee(
          fullName: fullName,
          email: email,
          password: password,
          pin: pin,
        );
    await result.fold(
      (failure) async {
        state = AuthSessionState(
          user: null,
          isAuthenticated: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) async {
        if (Validators.isValidUuid(user.id)) {
          await _migrateLegacySales(user.id);
        }
        state = AuthSessionState(user: user, isAuthenticated: true);
        return true;
      },
    );
  }

  Future<void> setupPin(String pin) async {
    final result = await ref.read(authRepositoryProvider).setupPin(pin: pin);
    result.fold(
      (failure) => state = AuthSessionState(
        user: state.user,
        isAuthenticated: false,
        errorMessage: failure.message,
      ),
      (user) => state = AuthSessionState(user: user, isAuthenticated: true),
    );
  }

  Future<void> loginWithPin(String username, String pin) async {
    final result = await ref.read(loginWithPinUseCaseProvider).call(
          LoginWithPinParams(username: username, pin: pin),
        );
    await result.fold(
      (failure) async {
        // Mantiene el usuario recordado: un PIN fallido no debe expulsar al
        // login, solo mostrar el error en la pantalla de PIN.
        state = AuthSessionState(
          user: state.user,
          isAuthenticated: false,
          errorMessage: failure.message,
        );
      },
      (user) async {
        if (Validators.isValidUuid(user.id)) {
          await _migrateLegacySales(user.id);
        }
        state = AuthSessionState(user: user, isAuthenticated: true);
      },
    );
  }

  Future<void> loginWithBiometrics(String userId) async {
    final result =
        await ref.read(loginWithBiometricsUseCaseProvider).call(userId);
    result.fold(
      (_) => state = const AuthSessionState(user: null, isAuthenticated: false),
      (user) => state = AuthSessionState(user: user, isAuthenticated: true),
    );
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).call(const NoParams());
    state = const AuthSessionState(user: null, isAuthenticated: false);
  }
}

final NotifierProvider<AuthSessionNotifier, AuthSessionState>
    authSessionProvider =
    NotifierProvider<AuthSessionNotifier, AuthSessionState>(
        AuthSessionNotifier.new);

/// Sincroniza el arranque: mientras sea [false] el router muestra /splash en
/// lugar de redirigir, para no parpadear la pantalla de login. Se pone en
/// [true] cuando la restauración de la sesión guardada termina.
final StateProvider<bool> sessionLoadedProvider = StateProvider<bool>((_) => false);

// ─────────────────────────────────────────────────────────────────────────────
// REMEMBERED USERNAME
// ─────────────────────────────────────────────────────────────────────────────

final Provider<String?> rememberedUsernameProvider = Provider<String?>((ref) {
  final Box<dynamic> box = ref.watch(preferencesBoxProvider);
  return box.get(PreferenceKeys.rememberedUsername) as String?;
});
