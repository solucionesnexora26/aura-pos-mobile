import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ChangePinParams {
  const ChangePinParams({required this.userId, required this.currentPin, required this.newPin});
  final String userId;
  final String currentPin;
  final String newPin;
}

class ChangePinUseCase implements UseCase<Unit, ChangePinParams> {
  const ChangePinUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ChangePinParams params) async {
    if (params.newPin.length != 6) {
      return const Left(ValidationFailure('El nuevo PIN debe tener 6 dígitos.'));
    }
    if (params.newPin == params.currentPin) {
      return const Left(ValidationFailure('El nuevo PIN debe ser diferente al actual.'));
    }
    return _repository.changePin(
      userId: params.userId,
      currentPin: params.currentPin,
      newPin: params.newPin,
    );
  }
}
