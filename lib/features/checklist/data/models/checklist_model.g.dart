// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChecklistModelImpl _$$ChecklistModelImplFromJson(Map<String, dynamic> json) =>
    _$ChecklistModelImpl(
      id: json['id'] as String,
      version: (json['version'] as num?)?.toInt() ?? 1,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? 'checklist',
      color: json['color'] as String? ?? '#6750A4',
      tasks:
          (json['tasks'] as List<dynamic>?)
              ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      settings:
          json['settings'] == null
              ? const ChecklistSettings()
              : ChecklistSettings.fromJson(
                json['settings'] as Map<String, dynamic>,
              ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChecklistModelImplToJson(
  _$ChecklistModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'version': instance.version,
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'color': instance.color,
  'tasks': instance.tasks,
  'settings': instance.settings,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
