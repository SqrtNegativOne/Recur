import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recur/core/providers/time_theme_provider.dart';
import 'package:recur/features/checklist/presentation/widgets/checklist_card.dart';
import 'package:recur/features/checklist/providers/checklist_list_provider.dart';

class ChecklistListScreen extends ConsumerWidget {
  const ChecklistListScreen({super.key});

  Future<void> _importJson(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: true,
    );
    if (result == null || result.files.isEmpty) return;

    int imported = 0;
    final errors = <String>[];

    for (final file in result.files) {
      final path = file.path;
      if (path == null) continue;
      try {
        await ref.read(checklistListProvider.notifier).importChecklist(path);
        imported++;
      } catch (_) {
        errors.add(file.name);
      }
    }

    if (!context.mounted) return;

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            imported > 0
                ? 'Imported $imported checklist${imported == 1 ? '' : 's'}. Failed: ${errors.join(', ')}'
                : 'Failed to import: ${errors.join(', ')}',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Imported $imported checklist${imported == 1 ? '' : 's'} successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistsAsync = ref.watch(checklistListProvider);
    final greeting = greetingForHour(DateTime.now().hour);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recur'),
            Text(
              greeting,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => _importJson(context, ref),
            tooltip: 'Import JSON',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
            tooltip: 'Run History',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: checklistsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('Error loading checklists:\n$err',
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(checklistListProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (checklists) {
          if (checklists.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.checklist,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'No checklists yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create your first routine',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Responsive grid: 1 column on narrow, 2 on medium, 3 on wide
              final crossAxisCount = constraints.maxWidth > 900
                  ? 3
                  : constraints.maxWidth > 500
                      ? 2
                      : 1;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.0,
                ),
                itemCount: checklists.length,
                itemBuilder: (context, index) {
                  final checklist = checklists[index];
                  return ChecklistCard(
                    checklist: checklist,
                    onTap: () => context.push('/checklist/${checklist.id}'),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/checklist/new'),
        tooltip: 'New Checklist',
        child: const Icon(Icons.add),
      ),
    );
  }
}
