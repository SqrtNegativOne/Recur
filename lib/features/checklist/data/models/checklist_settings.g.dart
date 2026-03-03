// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChecklistSettingsImpl _$$ChecklistSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$ChecklistSettingsImpl(
  autoAdvance: json['autoAdvance'] as bool? ?? true,
  autoAdvanceDelaySeconds:
      (json['autoAdvanceDelaySeconds'] as num?)?.toInt() ?? 3,
);

Map<String, dynamic> _$$ChecklistSettingsImplToJson(
  _$ChecklistSettingsImpl instance,
) => <String, dynamic>{
  'autoAdvance': instance.autoAdvance,
  'autoAdvanceDelaySeconds': instance.autoAdvanceDelaySeconds,
};
