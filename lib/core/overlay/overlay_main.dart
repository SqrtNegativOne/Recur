import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

/// Entry point for the floating overlay widget.
///
/// This runs in a SEPARATE Dart isolate from the main app — it has no access
/// to Riverpod, GoRouter, or any main-app state. All data arrives via
/// [FlutterOverlayWindow.overlayListener] and taps are relayed back via
/// [FlutterOverlayWindow.shareData].
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _OverlayApp());
}

class _OverlayApp extends StatefulWidget {
  const _OverlayApp();

  @override
  State<_OverlayApp> createState() => _OverlayAppState();
}

class _OverlayAppState extends State<_OverlayApp> {
  String _taskName = '';
  int _remainingSeconds = 0;
  bool _isOvertime = false;
  int _taskIndex = 0;
  int _totalTasks = 0;

  @override
  void initState() {
    super.initState();
    // Receive timer updates and "close" commands from the main isolate.
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data is! Map) return;
      if (data['action'] == 'close') {
        FlutterOverlayWindow.closeOverlay();
        return;
      }
      setState(() {
        _taskName = (data['taskName'] as String?) ?? _taskName;
        _remainingSeconds = (data['remainingSeconds'] as int?) ?? _remainingSeconds;
        _isOvertime = (data['isOvertime'] as bool?) ?? _isOvertime;
        _taskIndex = (data['taskIndex'] as int?) ?? _taskIndex;
        _totalTasks = (data['totalTasks'] as int?) ?? _totalTasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        // Tapping the bubble tells the main isolate to bring the app forward.
        onTap: () => FlutterOverlayWindow.shareData({'action': 'open_app'}),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xEE1A1A2E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$_taskIndex / $_totalTasks',
                  style: const TextStyle(
                    color: Color(0x99FFFFFF),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _taskName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    color: _isOvertime ? Colors.orange : Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'tap to return',
                  style: TextStyle(
                    color: Color(0x66FFFFFF),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final isNegative = totalSeconds < 0;
    final abs = totalSeconds.abs();
    final m = abs ~/ 60;
    final s = abs % 60;
    final prefix = isNegative ? '+' : '';
    return '$prefix${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
