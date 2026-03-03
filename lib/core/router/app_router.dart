import 'package:go_router/go_router.dart';
import 'package:recur/features/checklist/presentation/screens/checklist_list_screen.dart';
import 'package:recur/features/checklist/presentation/screens/checklist_detail_screen.dart';
import 'package:recur/features/checklist/presentation/screens/checklist_form_screen.dart';
import 'package:recur/features/checklist/presentation/screens/task_form_screen.dart';
import 'package:recur/features/runner/presentation/screens/run_screen.dart';
import 'package:recur/features/runner/presentation/screens/run_complete_screen.dart';
import 'package:recur/features/settings/presentation/screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ChecklistListScreen(),
    ),
    GoRoute(
      path: '/checklist/new',
      builder: (context, state) => const ChecklistFormScreen(),
    ),
    GoRoute(
      path: '/checklist/:id',
      builder: (context, state) => ChecklistDetailScreen(
        checklistId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/checklist/:id/edit',
      builder: (context, state) => ChecklistFormScreen(
        checklistId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/checklist/:id/task/new',
      builder: (context, state) => TaskFormScreen(
        checklistId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/checklist/:id/task/:tid/edit',
      builder: (context, state) => TaskFormScreen(
        checklistId: state.pathParameters['id']!,
        taskId: state.pathParameters['tid'],
      ),
    ),
    GoRoute(
      path: '/checklist/:id/run',
      builder: (context, state) => RunScreen(
        checklistId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/checklist/:id/run/complete',
      builder: (context, state) => RunCompleteScreen(
        checklistId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
