import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:recur/core/services/overlay_service.dart';
import 'package:recur/features/checklist/providers/checklist_detail_provider.dart';
import 'package:recur/features/runner/data/models/run_state.dart';
import 'package:recur/features/runner/providers/run_session_provider.dart';
import 'package:recur/features/runner/presentation/widgets/countdown_ring.dart';
import 'package:recur/features/runner/presentation/widgets/task_progress_bar.dart';
import 'package:recur/features/runner/presentation/widgets/run_controls.dart';

class RunScreen extends ConsumerStatefulWidget {
  final String checklistId;

  const RunScreen({super.key, required this.checklistId});

  @override
  ConsumerState<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends ConsumerState<RunScreen>
    with WidgetsBindingObserver {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    WidgetsBinding.instance.addObserver(this);
    // Request the SYSTEM_ALERT_WINDOW permission early so the user grants it
    // before they background the app mid-run.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(overlayServiceProvider).requestPermissionIfNeeded();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Ensure the overlay is gone when the run screen is torn down.
    ref.read(overlayServiceProvider).hideOverlay();
    WakelockPlus.disable();
    super.dispose();
  }

  /// Show the overlay when the app moves to background; hide it on resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final overlay = ref.read(overlayServiceProvider);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        overlay.showOverlay();
      case AppLifecycleState.resumed:
        overlay.hideOverlay();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final runState = ref.watch(runSessionProvider);

    // Listen for allComplete and navigate
    ref.listen<RunState?>(runSessionProvider, (prev, next) {
      if (next != null && next.phase == RunPhase.allComplete) {
        context.go('/checklist/${widget.checklistId}/run/complete');
      }
    });

    // First build: load checklist and start
    if (!_started) {
      final detailAsync =
          ref.watch(checklistDetailProvider(widget.checklistId));
      return detailAsync.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('Error: $err')),
        ),
        data: (checklist) {
          if (checklist == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Checklist not found')),
            );
          }
          if (checklist.tasks.isEmpty) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('No tasks to run')),
            );
          }
          // Start the session on first frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_started) {
              _started = true;
              ref.read(runSessionProvider.notifier).start(checklist);
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      );
    }

    if (runState == null) {
      // Session was stopped
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/checklist/${widget.checklistId}');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentTask = runState.currentTask;
    if (currentTask == null) {
      return const Scaffold(body: Center(child: Text('Completing...')));
    }

    final isPaused = runState.phase == RunPhase.paused;
    final isTransitioning = runState.phase == RunPhase.transitioning;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _confirmStop(context);
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress dots
                  TaskProgressBar(
                    totalTasks: runState.totalTaskCount,
                    currentTaskIndex: runState.currentTaskIndex,
                  ),
                  const SizedBox(height: 32),
                  // Task name
                  Text(
                    currentTask.name,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (currentTask.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      currentTask.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 48),
                  // Countdown ring
                  if (isTransitioning)
                    Column(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 80, color: Colors.green),
                        const SizedBox(height: 16),
                        Text(
                          'Next task...',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    )
                  else
                    CountdownRing(
                      remainingSeconds: runState.remainingSeconds,
                      progress: runState.progress,
                      isOvertime: runState.isOvertime,
                      isPaused: isPaused,
                    ),
                  const SizedBox(height: 48),
                  // Controls
                  if (!isTransitioning)
                    RunControls(
                      isPaused: isPaused,
                      onPauseResume: () {
                        if (isPaused) {
                          ref.read(runSessionProvider.notifier).resume();
                        } else {
                          ref.read(runSessionProvider.notifier).pause();
                        }
                      },
                      onSkip: () =>
                          ref.read(runSessionProvider.notifier).skip(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmStop(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Stop routine?'),
        content: const Text('Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continue'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(runSessionProvider.notifier).stop();
            },
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
