import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Formateadores centralizados para evitar instanciar [NumberFormat] /
/// [DateFormat] repetidamente en cada widget.
abstract class AppFormatters {
  AppFormatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    locale: AppConstants.defaultLocale,
    symbol: AppConstants.defaultCurrencySymbol,
    decimalDigits: 0,
  );

  static final NumberFormat _quantity = NumberFormat.decimalPattern(AppConstants.defaultLocale);

  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy hh:mm a', AppConstants.defaultLocale);
  static final DateFormat _date = DateFormat('dd/MM/yyyy', AppConstants.defaultLocale);
  static final DateFormat _time = DateFormat('hh:mm a', AppConstants.defaultLocale);

  static String currency(num value) => _currency.format(value);

  static String quantity(num value) {
    // Muestra decimales solo si son relevantes (ej. productos por peso).
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return _quantity.format(value);
  }

  static String dateTime(DateTime value) => _dateTime.format(value);
  static String date(DateTime value) => _date.format(value);
  static String time(DateTime value) => _time.format(value);

  static String percent(num value) => '${value.toStringAsFixed(1)}%';
}
