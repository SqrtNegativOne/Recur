// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RunRecordImpl _$$RunRecordImplFromJson(Map<String, dynamic> json) =>
    _$RunRecordImpl(
      id: json['id'] as String,
      checklistId: json['checklistId'] as String,
      checklistName: json['checklistName'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      taskCount: (json['taskCount'] as num).toInt(),
      taskActualSeconds:
          (json['taskActualSeconds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      taskPlannedSeconds:
          (json['taskPlannedSeconds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      taskNames:
          (json['taskNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RunRecordImplToJson(_$RunRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'checklistId': instance.checklistId,
      'checklistName': instance.checklistName,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt.toIso8601String(),
      'taskCount': instance.taskCount,
      'taskActualSeconds': instance.taskActualSeconds,
      'taskPlannedSeconds': instance.taskPlannedSeconds,
      'taskNames': instance.taskNames,
    };
