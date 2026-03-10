// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RunRecord _$RunRecordFromJson(Map<String, dynamic> json) {
  return _RunRecord.fromJson(json);
}

/// @nodoc
mixin _$RunRecord {
  String get id => throw _privateConstructorUsedError;
  String get checklistId => throw _privateConstructorUsedError;
  String get checklistName => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;
  int get taskCount => throw _privateConstructorUsedError;
  List<int> get taskActualSeconds => throw _privateConstructorUsedError;
  List<int> get taskPlannedSeconds => throw _privateConstructorUsedError;
  List<String> get taskNames => throw _privateConstructorUsedError;

  /// Serializes this RunRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RunRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RunRecordCopyWith<RunRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RunRecordCopyWith<$Res> {
  factory $RunRecordCopyWith(RunRecord value, $Res Function(RunRecord) then) =
      _$RunRecordCopyWithImpl<$Res, RunRecord>;
  @useResult
  $Res call({
    String id,
    String checklistId,
    String checklistName,
    DateTime startedAt,
    DateTime completedAt,
    int taskCount,
    List<int> taskActualSeconds,
    List<int> taskPlannedSeconds,
    List<String> taskNames,
  });
}

/// @nodoc
class _$RunRecordCopyWithImpl<$Res, $Val extends RunRecord>
    implements $RunRecordCopyWith<$Res> {
  _$RunRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RunRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? checklistId = null,
    Object? checklistName = null,
    Object? startedAt = null,
    Object? completedAt = null,
    Object? taskCount = null,
    Object? taskActualSeconds = null,
    Object? taskPlannedSeconds = null,
    Object? taskNames = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            checklistId:
                null == checklistId
                    ? _value.checklistId
                    : checklistId // ignore: cast_nullable_to_non_nullable
                        as String,
            checklistName:
                null == checklistName
                    ? _value.checklistName
                    : checklistName // ignore: cast_nullable_to_non_nullable
                        as String,
            startedAt:
                null == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            completedAt:
                null == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            taskCount:
                null == taskCount
                    ? _value.taskCount
                    : taskCount // ignore: cast_nullable_to_non_nullable
                        as int,
            taskActualSeconds:
                null == taskActualSeconds
                    ? _value.taskActualSeconds
                    : taskActualSeconds // ignore: cast_nullable_to_non_nullable
                        as List<int>,
            taskPlannedSeconds:
                null == taskPlannedSeconds
                    ? _value.taskPlannedSeconds
                    : taskPlannedSeconds // ignore: cast_nullable_to_non_nullable
                        as List<int>,
            taskNames:
                null == taskNames
                    ? _value.taskNames
                    : taskNames // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RunRecordImplCopyWith<$Res>
    implements $RunRecordCopyWith<$Res> {
  factory _$$RunRecordImplCopyWith(
    _$RunRecordImpl value,
    $Res Function(_$RunRecordImpl) then,
  ) = __$$RunRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String checklistId,
    String checklistName,
    DateTime startedAt,
    DateTime completedAt,
    int taskCount,
    List<int> taskActualSeconds,
    List<int> taskPlannedSeconds,
    List<String> taskNames,
  });
}

/// @nodoc
class __$$RunRecordImplCopyWithImpl<$Res>
    extends _$RunRecordCopyWithImpl<$Res, _$RunRecordImpl>
    implements _$$RunRecordImplCopyWith<$Res> {
  __$$RunRecordImplCopyWithImpl(
    _$RunRecordImpl _value,
    $Res Function(_$RunRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RunRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? checklistId = null,
    Object? checklistName = null,
    Object? startedAt = null,
    Object? completedAt = null,
    Object? taskCount = null,
    Object? taskActualSeconds = null,
    Object? taskPlannedSeconds = null,
    Object? taskNames = null,
  }) {
    return _then(
      _$RunRecordImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        checklistId:
            null == checklistId
                ? _value.checklistId
                : checklistId // ignore: cast_nullable_to_non_nullable
                    as String,
        checklistName:
            null == checklistName
                ? _value.checklistName
                : checklistName // ignore: cast_nullable_to_non_nullable
                    as String,
        startedAt:
            null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        completedAt:
            null == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        taskCount:
            null == taskCount
                ? _value.taskCount
                : taskCount // ignore: cast_nullable_to_non_nullable
                    as int,
        taskActualSeconds:
            null == taskActualSeconds
                ? _value._taskActualSeconds
                : taskActualSeconds // ignore: cast_nullable_to_non_nullable
                    as List<int>,
        taskPlannedSeconds:
            null == taskPlannedSeconds
                ? _value._taskPlannedSeconds
                : taskPlannedSeconds // ignore: cast_nullable_to_non_nullable
                    as List<int>,
        taskNames:
            null == taskNames
                ? _value._taskNames
                : taskNames // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RunRecordImpl extends _RunRecord {
  const _$RunRecordImpl({
    required this.id,
    required this.checklistId,
    required this.checklistName,
    required this.startedAt,
    required this.completedAt,
    required this.taskCount,
    final List<int> taskActualSeconds = const [],
    final List<int> taskPlannedSeconds = const [],
    final List<String> taskNames = const [],
  }) : _taskActualSeconds = taskActualSeconds,
       _taskPlannedSeconds = taskPlannedSeconds,
       _taskNames = taskNames,
       super._();

  factory _$RunRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$RunRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String checklistId;
  @override
  final String checklistName;
  @override
  final DateTime startedAt;
  @override
  final DateTime completedAt;
  @override
  final int taskCount;
  final List<int> _taskActualSeconds;
  @override
  @JsonKey()
  List<int> get taskActualSeconds {
    if (_taskActualSeconds is EqualUnmodifiableListView)
      return _taskActualSeconds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taskActualSeconds);
  }

  final List<int> _taskPlannedSeconds;
  @override
  @JsonKey()
  List<int> get taskPlannedSeconds {
    if (_taskPlannedSeconds is EqualUnmodifiableListView)
      return _taskPlannedSeconds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taskPlannedSeconds);
  }

  final List<String> _taskNames;
  @override
  @JsonKey()
  List<String> get taskNames {
    if (_taskNames is EqualUnmodifiableListView) return _taskNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taskNames);
  }

  @override
  String toString() {
    return 'RunRecord(id: $id, checklistId: $checklistId, checklistName: $checklistName, startedAt: $startedAt, completedAt: $completedAt, taskCount: $taskCount, taskActualSeconds: $taskActualSeconds, taskPlannedSeconds: $taskPlannedSeconds, taskNames: $taskNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RunRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.checklistId, checklistId) ||
                other.checklistId == checklistId) &&
            (identical(other.checklistName, checklistName) ||
                other.checklistName == checklistName) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.taskCount, taskCount) ||
                other.taskCount == taskCount) &&
            const DeepCollectionEquality().equals(
              other._taskActualSeconds,
              _taskActualSeconds,
            ) &&
            const DeepCollectionEquality().equals(
              other._taskPlannedSeconds,
              _taskPlannedSeconds,
            ) &&
            const DeepCollectionEquality().equals(
              other._taskNames,
              _taskNames,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    checklistId,
    checklistName,
    startedAt,
    completedAt,
    taskCount,
    const DeepCollectionEquality().hash(_taskActualSeconds),
    const DeepCollectionEquality().hash(_taskPlannedSeconds),
    const DeepCollectionEquality().hash(_taskNames),
  );

  /// Create a copy of RunRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RunRecordImplCopyWith<_$RunRecordImpl> get copyWith =>
      __$$RunRecordImplCopyWithImpl<_$RunRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RunRecordImplToJson(this);
  }
}

abstract class _RunRecord extends RunRecord {
  const factory _RunRecord({
    required final String id,
    required final String checklistId,
    required final String checklistName,
    required final DateTime startedAt,
    required final DateTime completedAt,
    required final int taskCount,
    final List<int> taskActualSeconds,
    final List<int> taskPlannedSeconds,
    final List<String> taskNames,
  }) = _$RunRecordImpl;
  const _RunRecord._() : super._();

  factory _RunRecord.fromJson(Map<String, dynamic> json) =
      _$RunRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get checklistId;
  @override
  String get checklistName;
  @override
  DateTime get startedAt;
  @override
  DateTime get completedAt;
  @override
  int get taskCount;
  @override
  List<int> get taskActualSeconds;
  @override
  List<int> get taskPlannedSeconds;
  @override
  List<String> get taskNames;

  /// Create a copy of RunRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RunRecordImplCopyWith<_$RunRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
