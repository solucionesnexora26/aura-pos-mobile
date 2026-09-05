import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetActiveUsersUseCase implements UseCase<List<UserEntity>, NoParams> {
  const GetActiveUsersUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) {
    return _repository.getActiveUsers();
  }
}
