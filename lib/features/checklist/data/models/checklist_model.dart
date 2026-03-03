import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recur/core/utils/slug_utils.dart';
import 'package:recur/features/checklist/data/models/task_model.dart';
import 'package:recur/features/checklist/data/models/checklist_settings.dart';

part 'checklist_model.freezed.dart';
part 'checklist_model.g.dart';

@freezed
class ChecklistModel with _$ChecklistModel {
  const ChecklistModel._();

  const factory ChecklistModel({
    required String id,
    @Default(1) int version,
    required String name,
    @Default('') String description,
    @Default('checklist') String icon,
    @Default('#6750A4') String color,
    @Default([]) List<TaskModel> tasks,
    @Default(ChecklistSettings()) ChecklistSettings settings,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChecklistModel;

  factory ChecklistModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistModelFromJson(json);

  /// Generates the filename for this checklist's JSON file.
  String get fileName => buildFileName(name, id);

  /// Total duration of all tasks in seconds.
  int get totalDuration =>
      tasks.fold(0, (sum, task) => sum + task.durationSeconds);
}
