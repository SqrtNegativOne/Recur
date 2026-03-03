import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:recur/features/checklist/data/models/task_model.dart';
import 'package:recur/features/checklist/presentation/widgets/duration_picker.dart';
import 'package:recur/features/checklist/providers/checklist_detail_provider.dart';
import 'package:recur/features/checklist/providers/checklist_list_provider.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final String checklistId;
  final String? taskId;

  const TaskFormScreen({
    super.key,
    required this.checklistId,
    this.taskId,
  });

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  int _durationSeconds = 120;
  bool _isLoading = false;
  bool _initialized = false;

  bool get _isEditing => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initFromTask(TaskModel task) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = task.name;
    _descriptionController.text = task.description;
    _durationSeconds = task.durationSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync =
        ref.watch(checklistDetailProvider(widget.checklistId));

    return detailAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
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

        TaskModel? existingTask;
        if (_isEditing) {
          try {
            existingTask =
                checklist.tasks.firstWhere((t) => t.id == widget.taskId);
            _initFromTask(existingTask);
          } catch (_) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Task not found')),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? 'Edit Task' : 'New Task'),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Task Name',
                    hintText: 'e.g. Brush teeth',
                  ),
                  autofocus: !_isEditing,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                Text('Duration',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                DurationPicker(
                  initialSeconds: _durationSeconds,
                  onChanged: (v) => _durationSeconds = v,
                ),
                const SizedBox(height: 8),
                // Quick presets
                Wrap(
                  spacing: 8,
                  children: [30, 60, 120, 300, 600].map((s) {
                    final label = s < 60 ? '${s}s' : '${s ~/ 60}m';
                    return ActionChip(
                      label: Text(label),
                      onPressed: () {
                        setState(() => _durationSeconds = s);
                        // Rebuild duration picker by reassigning key
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _isLoading
                  ? null
                  : () => _save(checklist, existingTask),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save Task' : 'Add Task'),
            ),
          ),
        );
      },
    );
  }

  Future<void> _save(dynamic checklist, TaskModel? existingTask) async {
    if (!_formKey.currentState!.validate()) return;
    if (_durationSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duration must be greater than 0')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = await ref.read(checklistRepositoryProvider.future);
      final tasks = List.of(checklist.tasks as List<TaskModel>);

      final task = TaskModel(
        id: existingTask?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        durationSeconds: _durationSeconds,
      );

      if (_isEditing) {
        final idx = tasks.indexWhere((t) => t.id == widget.taskId);
        if (idx >= 0) tasks[idx] = task;
      } else {
        tasks.add(task);
      }

      final updated = checklist.copyWith(tasks: tasks);
      await repo.save(updated);
      ref.invalidate(checklistListProvider);
      ref.invalidate(checklistDetailProvider(widget.checklistId));

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
