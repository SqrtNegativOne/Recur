import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_settings.freezed.dart';
part 'checklist_settings.g.dart';

@freezed
class ChecklistSettings with _$ChecklistSettings {
  const factory ChecklistSettings({
    @Default(true) bool autoAdvance,
    @Default(3) int autoAdvanceDelaySeconds,
  }) = _ChecklistSettings;

  factory ChecklistSettings.fromJson(Map<String, dynamic> json) =>
      _$ChecklistSettingsFromJson(json);
}
