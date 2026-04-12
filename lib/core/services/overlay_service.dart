import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final overlayServiceProvider = Provider<OverlayService>((ref) {
  final service = OverlayService();
  service._init();
  ref.onDispose(service.dispose);
  return service;
});

/// Manages the floating timer overlay on Android.
///
/// On non-Android platforms all methods are no-ops.
/// The overlay widget ([overlayMain]) runs in a separate Dart isolate;
/// this service is the main isolate's end of that bridge.
class OverlayService {
  static const _channel = MethodChannel('com.recur.recur/main');

  bool _isActive = false;
  StreamSubscription<dynamic>? _subscription;

  bool get isActive => _isActive;

  void _init() {
    if (!Platform.isAndroid) return;
    // Listen for the 'open_app' tap from the overlay isolate.
    _subscription = FlutterOverlayWindow.overlayListener.listen((data) {
      if (data is Map && data['action'] == 'open_app') {
        _bringToFront();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<bool> requestPermissionIfNeeded() async {
    if (!Platform.isAndroid) return false;
    final granted = await FlutterOverlayWindow.isPermissionGranted();
    if (granted != true) {
      await FlutterOverlayWindow.requestPermission();
      return await FlutterOverlayWindow.isPermissionGranted() == true;
    }
    return true;
  }

  Future<void> showOverlay() async {
    if (!Platform.isAndroid) return;
    final granted = await FlutterOverlayWindow.isPermissionGranted();
    if (granted != true) return;
    _isActive = true;
    await FlutterOverlayWindow.showOverlay(
      height: 130,
      width: 210,
      alignment: OverlayAlignment.centerRight,
      flag: OverlayFlag.defaultFlag,
      enableDrag: true,
      positionGravity: PositionGravity.auto,
    );
  }

  Future<void> hideOverlay() async {
    if (!Platform.isAndroid || !_isActive) return;
    _isActive = false;
    // Tell the overlay isolate to close itself, then close at the window level.
    await FlutterOverlayWindow.shareData({'action': 'close'});
    await FlutterOverlayWindow.closeOverlay();
  }

  /// Relays the current timer state to the floating overlay widget.
  void sendTimerData({
    required String taskName,
    required int remainingSeconds,
    required bool isOvertime,
    required int taskIndex,
    required int totalTasks,
  }) {
    if (!Platform.isAndroid || !_isActive) return;
    FlutterOverlayWindow.shareData({
      'taskName': taskName,
      'remainingSeconds': remainingSeconds,
      'isOvertime': isOvertime,
      'taskIndex': taskIndex,
      'totalTasks': totalTasks,
    });
  }

  Future<void> _bringToFront() async {
    try {
      await _channel.invokeMethod<void>('bringToFront');
    } on PlatformException {
      // If native side is unavailable, do nothing.
    }
  }
}
