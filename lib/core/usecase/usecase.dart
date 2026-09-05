import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

/// Contrato base para todos los casos de uso de la aplicación.
///
/// [Type] es el tipo de retorno exitoso, [Params] es el parámetro de
/// entrada. Para casos de uso sin parámetros, usar [NoParams].
abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Variante síncrona, útil para casos de uso que solo leen streams o
/// exponen datos reactivos sin operación asíncrona de por medio.
abstract interface class SyncUseCase<Type, Params> {
  Either<Failure, Type> call(Params params);
}

/// Marcador para casos de uso que no reciben parámetros.
final class NoParams {
  const NoParams();
}
