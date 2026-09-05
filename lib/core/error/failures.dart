import 'package:equatable/equatable.dart';

/// Representación de fallos en la capa de dominio/presentación. Los
/// repositorios devuelven `Either<Failure, T>` (fpdart) en lugar de lanzar
/// excepciones, para forzar el manejo explícito de errores en la UI.
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Error al acceder a la base de datos local.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'El recurso solicitado no existe.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Error de autenticación.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Error de conexión de red.']);
}

class PrinterFailure extends Failure {
  const PrinterFailure([super.message = 'Error al comunicarse con la impresora.']);
}

class InsufficientStockFailure extends Failure {
  const InsufficientStockFailure([super.message = 'Stock insuficiente para completar la operación.']);
}

class CashRegisterClosedFailure extends Failure {
  const CashRegisterClosedFailure([super.message = 'La caja está cerrada. Debe abrirla antes de vender.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Ocurrió un error inesperado.']);
}

/// Traduce una [AppException] capturada en el repositorio a su [Failure]
/// correspondiente. Se usa dentro de los `try/catch` de cada RepositoryImpl.
Failure mapExceptionToFailure(Object error) {
  final String msg = error.toString();
  return switch (error.runtimeType.toString()) {
    'DatabaseException' => DatabaseFailure(msg),
    'NotFoundException' => NotFoundFailure(msg),
    'ValidationException' => ValidationFailure(msg),
    'AuthException' => AuthFailure(msg),
    'NetworkException' => NetworkFailure(msg),
    'PrinterException' => PrinterFailure(msg),
    'InsufficientStockException' => InsufficientStockFailure(msg),
    'CashRegisterClosedException' => CashRegisterClosedFailure(msg),
    _ => UnexpectedFailure(msg),
  };
}
