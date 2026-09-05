import '../constants/app_constants.dart';

/// Validadores puros y reutilizables para formularios de la aplicación.
/// Devuelven `null` si el valor es válido, o un mensaje de error legible.
abstract class Validators {
  Validators._();

  static String? required(String? value, {String field = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field es obligatorio.';
    }
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.length != AppConstants.pinLength) {
      return 'El PIN debe tener ${AppConstants.pinLength} dígitos.';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'El PIN solo debe contener números.';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // el email suele ser opcional
    }
    final RegExp regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Correo electrónico inválido.';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final RegExp regex = RegExp(r'^\+?[0-9\s-]{7,15}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Número de teléfono inválido.';
    }
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'El valor'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field es obligatorio.';
    }
    final double? parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) {
      return '$field debe ser un número válido.';
    }
    if (parsed < 0) {
      return '$field no puede ser negativo.';
    }
    return null;
  }

  static String? nonEmptyPrice(String? value) => positiveNumber(value, field: 'El precio');

  /// Expresión regular para UUID v4 (con variantes de mayúsculas/minúsculas).
  static final RegExp _uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  /// Devuelve `true` si [value] es un UUID válido o `null`/vacío cuando
  /// [allowEmpty] es `true`.
  static bool isValidUuid(String? value, {bool allowEmpty = false}) {
    if (value == null || value.isEmpty) return allowEmpty;
    return _uuidRegex.hasMatch(value);
  }

  static String? uuid(String? value, {String field = 'El identificador'}) {
    if (value == null || value.isEmpty) return null;
    if (!isValidUuid(value)) return '$field no es un UUID válido.';
    return null;
  }
}
