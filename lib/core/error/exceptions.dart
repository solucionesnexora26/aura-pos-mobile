/// Excepciones lanzadas por datasources (capa data). Los repositorios
/// las capturan y las traducen a [Failure] antes de exponerlas al dominio.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class DatabaseException extends AppException {
  const DatabaseException([super.message = 'Error al acceder a la base de datos local.']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'El recurso solicitado no existe.']);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Error de autenticación.']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Error de conexión de red.']);
}

class PrinterException extends AppException {
  const PrinterException([super.message = 'Error al comunicarse con la impresora.']);
}

class InsufficientStockException extends AppException {
  const InsufficientStockException([super.message = 'Stock insuficiente para completar la operación.']);
}

class CashRegisterClosedException extends AppException {
  const CashRegisterClosedException([super.message = 'La caja está cerrada. Debe abrirla antes de vender.']);
}
