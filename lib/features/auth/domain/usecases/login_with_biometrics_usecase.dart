import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithBiometricsUseCase implements UseCase<UserEntity, String> {
  const LoginWithBiometricsUseCase(this._repository);
  final AuthRepository _repository;

  /// [params] es el userId del usuario recordado.
  @override
  Future<Either<Failure, UserEntity>> call(String params) async {
    final Either<Failure, UserEntity> result =
        await _repository.loginWithBiometrics(userId: params);

    if (result.isLeft()) {
      return result;
    }
    final UserEntity user = (result as Right<Failure, UserEntity>).value;
    await _repository.persistSession(user);
    return Right(user);
  }
}
