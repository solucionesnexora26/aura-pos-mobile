import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class RecoverPinParams {
  const RecoverPinParams({
    required this.username,
    required this.ownerMasterPin,
    required this.newPin,
  });
  final String username;
  final String ownerMasterPin;
  final String newPin;
}

/// Restablece el PIN de un usuario usando el PIN maestro de un propietario
/// o administrador como verificación de identidad, sin depender de red
/// (correo, SMS, etc.), acorde al requisito Offline First.
class RecoverPinUseCase implements UseCase<Unit, RecoverPinParams> {
  const RecoverPinUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RecoverPinParams params) async {
    if (params.newPin.length != 6) {
      return const Left(ValidationFailure('El nuevo PIN debe tener 6 dígitos.'));
    }
    return _repository.recoverPin(
      username: params.username,
      ownerMasterPin: params.ownerMasterPin,
      newPin: params.newPin,
    );
  }
}
