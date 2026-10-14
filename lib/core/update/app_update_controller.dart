import 'dart:async';

import 'package:flutter/foundation.dart';

import 'app_update_service.dart';

const _tag = '[AURA-UPDATE]';

class AppUpdateController {
  AppUpdateController({AppUpdateService? service})
      : _service = service ?? AppUpdateService();

  final AppUpdateService _service;

  static const _debounce = Duration(minutes: 5);
  static const checkInterval = Duration(minutes: 30);

  DateTime? _lastCheck;
  Timer? _periodicTimer;
  bool _isChecking = false;
  RemoteVersion? _cachedVersion;
  UpdateCheckResult? _lastResult;

  RemoteVersion? get cachedVersion => _cachedVersion;

  void startPeriodicChecks(VoidCallback onCheckNeeded) {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(checkInterval, (_) {
      print('$_tag [CONTROLLER] periodic tick');
      onCheckNeeded();
    });
    print('$_tag [CONTROLLER] periodic checks started (${checkInterval.inMinutes}min)');
  }

  void dispose() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  bool _shouldCheck() {
    if (_lastCheck == null) return true;
    final elapsed = DateTime.now().difference(_lastCheck!);
    return elapsed >= _debounce;
  }

  Future<UpdateCheckResult> silentCheck() async {
    if (_isChecking) {
      print('$_tag [CONTROLLER] silentCheck: SKIP (already checking), returning cached');
      return _lastResult ?? UpdateCheckResult.upToDate();
    }

    if (!_shouldCheck()) {
      print('$_tag [CONTROLLER] silentCheck: SKIP (debounced), returning cached');
      return _lastResult ?? UpdateCheckResult.upToDate();
    }

    _isChecking = true;
    try {
      final result = await _service.checkForUpdate();
      _lastCheck = DateTime.now();
      _lastResult = result;

      if (result.hasUpdate && result.remote != null) {
        _cachedVersion = result.remote;
      } else {
        _cachedVersion = null;
      }

      return result;
    } catch (e) {
      print('$_tag [CONTROLLER] silentCheck ERROR: $e');
      return UpdateCheckResult.error(e.toString());
    } finally {
      _isChecking = false;
    }
  }

  Future<UpdateCheckResult> forceCheck() async {
    print('$_tag [CONTROLLER] forceCheck: resetting _lastCheck');
    _lastCheck = null;
    return silentCheck();
  }
}
