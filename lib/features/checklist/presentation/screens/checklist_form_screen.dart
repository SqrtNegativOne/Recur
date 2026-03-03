import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';
import 'package:recur/features/checklist/data/models/checklist_settings.dart';
import 'package:recur/features/checklist/providers/checklist_detail_provider.dart';
import 'package:recur/features/checklist/providers/checklist_list_provider.dart';

/// Available colors for checklist cards.
const _colorOptions = [
  '#6750A4', // Purple (default)
  '#B3261E', // Red
  '#E8A000', // Amber
  '#386A20', // Green
  '#006399', // Blue
  '#6E5D00', // Yellow-brown
  '#7D5260', // Rose
  '#00696C', // Teal
];

class ChecklistFormScreen extends ConsumerStatefulWidget {
  final String? checklistId;

  const ChecklistFormScreen({super.key, this.checklistId});

  @override
  ConsumerState<ChecklistFormScreen> createState() =>
      _ChecklistFormScreenState();
}

class _ChecklistFormScreenState extends ConsumerState<ChecklistFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedColor = _colorOptions.first;
  bool _autoAdvance = true;
  int _autoAdvanceDelay = 3;
  bool _isLoading = false;
  bool _initialized = false;

  bool get _isEditing => widget.checklistId != null;

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

  void _initFromChecklist(ChecklistModel checklist) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = checklist.name;
    _descriptionController.text = checklist.description;
    _selectedColor = checklist.color;
    _autoAdvance = checklist.settings.autoAdvance;
    _autoAdvanceDelay = checklist.settings.autoAdvanceDelaySeconds;
  }

  @override
  Widget build(BuildContext context) {
    // If editing, load existing data
    if (_isEditing) {
      final detailAsync =
          ref.watch(checklistDetailProvider(widget.checklistId!));
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
          _initFromChecklist(checklist);
          return _buildForm(context, checklist);
        },
      );
    }

    return _buildForm(context, null);
  }

  Widget _buildForm(BuildContext context, ChecklistModel? existing) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Checklist' : 'New Checklist'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g. Morning Routine',
              ),
              autofocus: !_isEditing,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Brief description of this routine',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Text('Color', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colorOptions.map((hex) {
                final color = _parseColor(hex);
                final isSelected = hex == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = hex),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Auto-advance'),
              subtitle:
                  const Text('Automatically move to next task when timer ends'),
              value: _autoAdvance,
              onChanged: (v) => setState(() => _autoAdvance = v),
            ),
            if (_autoAdvance)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    const Text('Delay: '),
                    DropdownButton<int>(
                      value: _autoAdvanceDelay,
                      items: [1, 2, 3, 5, 10]
                          .map((s) => DropdownMenuItem(
                              value: s, child: Text('${s}s')))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _autoAdvanceDelay = v);
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: _isLoading ? null : () => _save(existing),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? 'Save Changes' : 'Create Checklist'),
        ),
      ),
    );
  }

  Future<void> _save(ChecklistModel? existing) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = await ref.read(checklistRepositoryProvider.future);
      final now = DateTime.now();

      final checklist = (existing ?? ChecklistModel(
        id: const Uuid().v4(),
        name: '',
        createdAt: now,
        updatedAt: now,
      )).copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        color: _selectedColor,
        settings: ChecklistSettings(
          autoAdvance: _autoAdvance,
          autoAdvanceDelaySeconds: _autoAdvanceDelay,
        ),
      );

      await repo.save(checklist);
      ref.invalidate(checklistListProvider);
      ref.invalidate(checklistDetailProvider(checklist.id));

      if (mounted) {
        if (_isEditing) {
          context.pop();
        } else {
          context.go('/checklist/${checklist.id}');
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF6750A4);
    }
  }
}
