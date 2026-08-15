import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';
import 'package:recur/features/checklist/providers/checklist_list_provider.dart';

/// Provider family that loads a single checklist by ID.
/// Depends on the checklist list provider so it stays in sync.
// ignore: specify_nonobvious_property_types
final checklistDetailProvider = FutureProvider.family<ChecklistModel?, String>((
  ref,
  id,
) async {
  final repo = await ref.watch(checklistRepositoryProvider.future);
  return repo.loadById(id);
});
