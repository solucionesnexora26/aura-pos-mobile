import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithPinParams {
  const LoginWithPinParams({required this.username, required this.pin});
  final String username;
  final String pin;
}

class LoginWithPinUseCase implements UseCase<UserEntity, LoginWithPinParams> {
  const LoginWithPinUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithPinParams params) async {
    if (params.username.trim().isEmpty) {
      return const Left(ValidationFailure('El usuario es obligatorio.'));
    }
    if (params.pin.length != AppConstants.pinLength) {
      return const Left(
        ValidationFailure('El PIN debe tener ${AppConstants.pinLength} dígitos.'),
      );
    }

    final Either<Failure, UserEntity> result = await _repository.loginWithPin(
      username: params.username.trim(),
      pin: params.pin,
    );

    if (result.isLeft()) {
      return result;
    }

    final UserEntity user = (result as Right<Failure, UserEntity>).value;
    await _repository.persistSession(user);
    return Right(user);
  }
}
