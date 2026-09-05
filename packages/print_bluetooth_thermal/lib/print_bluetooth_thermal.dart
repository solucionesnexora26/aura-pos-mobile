import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PrintBluetoothThermal {
  static const MethodChannel _channel = MethodChannel('groons.web.app/print');

  static Future<bool> get isPermissionBluetoothGranted async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('ispermissionbluetoothgranted') ??
          false;
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('Bluetooth permission check failed: ${e.message}');
      return false;
    }
  }

  static Future<bool> get bluetoothEnabled async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('bluetoothenabled') ?? false;
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('Bluetooth state check failed: ${e.message}');
      return false;
    }
  }

  static Future<List<BluetoothInfo>> get pairedBluetooths async {
    if (!Platform.isAndroid) return <BluetoothInfo>[];
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('pairedbluetooths');
      return (result ?? const <dynamic>[]).map((item) {
        final parts = item.toString().split('#');
        return BluetoothInfo(
          name: parts.isEmpty ? 'Bluetooth' : parts.first,
          macAdress: parts.length > 1 ? parts.sublist(1).join('#') : '',
        );
      }).toList();
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('Paired Bluetooth lookup failed: ${e.message}');
      return <BluetoothInfo>[];
    }
  }

  static Future<bool> connect({required String macPrinterAddress}) async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('connect', macPrinterAddress) ??
          false;
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('Bluetooth connect failed: ${e.message}');
      return false;
    }
  }

  /// Sends exactly [bytes]. No LF, CR, framing byte, or text conversion is
  /// added by this Dart wrapper or by the Android implementation.
  static Future<bool> writeBytes(List<int> bytes) async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('writebytes', bytes) ?? false;
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('Bluetooth write failed: ${e.message}');
      return false;
    }
  }

  static Future<bool> get connectionStatus async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('connectionstatus') ?? false;
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('Bluetooth status failed: ${e.message}');
      return false;
    }
  }

  static Future<bool> get disconnect async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('disconnect') ?? false;
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('Bluetooth disconnect failed: ${e.message}');
      return false;
    }
  }
}

class BluetoothInfo {
  BluetoothInfo({required this.name, required this.macAdress});

  final String name;
  final String macAdress;
}
