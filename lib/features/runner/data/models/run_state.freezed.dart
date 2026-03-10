// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RunState {
  ChecklistModel get checklist => throw _privateConstructorUsedError;
  int get currentTaskIndex => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  RunPhase get phase => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  List<int> get taskElapsedTimes => throw _privateConstructorUsedError;

  /// Create a copy of RunState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RunStateCopyWith<RunState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RunStateCopyWith<$Res> {
  factory $RunStateCopyWith(RunState value, $Res Function(RunState) then) =
      _$RunStateCopyWithImpl<$Res, RunState>;
  @useResult
  $Res call({
    ChecklistModel checklist,
    int currentTaskIndex,
    int elapsedSeconds,
    RunPhase phase,
    DateTime? startedAt,
    List<int> taskElapsedTimes,
  });

  $ChecklistModelCopyWith<$Res> get checklist;
}

/// @nodoc
class _$RunStateCopyWithImpl<$Res, $Val extends RunState>
    implements $RunStateCopyWith<$Res> {
  _$RunStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RunState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checklist = null,
    Object? currentTaskIndex = null,
    Object? elapsedSeconds = null,
    Object? phase = null,
    Object? startedAt = freezed,
    Object? taskElapsedTimes = null,
  }) {
    return _then(
      _value.copyWith(
            checklist:
                null == checklist
                    ? _value.checklist
                    : checklist // ignore: cast_nullable_to_non_nullable
                        as ChecklistModel,
            currentTaskIndex:
                null == currentTaskIndex
                    ? _value.currentTaskIndex
                    : currentTaskIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            elapsedSeconds:
                null == elapsedSeconds
                    ? _value.elapsedSeconds
                    : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                        as int,
            phase:
                null == phase
                    ? _value.phase
                    : phase // ignore: cast_nullable_to_non_nullable
                        as RunPhase,
            startedAt:
                freezed == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            taskElapsedTimes:
                null == taskElapsedTimes
                    ? _value.taskElapsedTimes
                    : taskElapsedTimes // ignore: cast_nullable_to_non_nullable
                        as List<int>,
          )
          as $Val,
    );
  }

  /// Create a copy of RunState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChecklistModelCopyWith<$Res> get checklist {
    return $ChecklistModelCopyWith<$Res>(_value.checklist, (value) {
      return _then(_value.copyWith(checklist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RunStateImplCopyWith<$Res>
    implements $RunStateCopyWith<$Res> {
  factory _$$RunStateImplCopyWith(
    _$RunStateImpl value,
    $Res Function(_$RunStateImpl) then,
  ) = __$$RunStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ChecklistModel checklist,
    int currentTaskIndex,
    int elapsedSeconds,
    RunPhase phase,
    DateTime? startedAt,
    List<int> taskElapsedTimes,
  });

  @override
  $ChecklistModelCopyWith<$Res> get checklist;
}

/// @nodoc
class __$$RunStateImplCopyWithImpl<$Res>
    extends _$RunStateCopyWithImpl<$Res, _$RunStateImpl>
    implements _$$RunStateImplCopyWith<$Res> {
  __$$RunStateImplCopyWithImpl(
    _$RunStateImpl _value,
    $Res Function(_$RunStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RunState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checklist = null,
    Object? currentTaskIndex = null,
    Object? elapsedSeconds = null,
    Object? phase = null,
    Object? startedAt = freezed,
    Object? taskElapsedTimes = null,
  }) {
    return _then(
      _$RunStateImpl(
        checklist:
            null == checklist
                ? _value.checklist
                : checklist // ignore: cast_nullable_to_non_nullable
                    as ChecklistModel,
        currentTaskIndex:
            null == currentTaskIndex
                ? _value.currentTaskIndex
                : currentTaskIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        elapsedSeconds:
            null == elapsedSeconds
                ? _value.elapsedSeconds
                : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                    as int,
        phase:
            null == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                    as RunPhase,
        startedAt:
            freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        taskElapsedTimes:
            null == taskElapsedTimes
                ? _value._taskElapsedTimes
                : taskElapsedTimes // ignore: cast_nullable_to_non_nullable
                    as List<int>,
      ),
    );
  }
}

/// @nodoc

class _$RunStateImpl extends _RunState {
  const _$RunStateImpl({
    required this.checklist,
    this.currentTaskIndex = 0,
    this.elapsedSeconds = 0,
    this.phase = RunPhase.idle,
    this.startedAt,
    final List<int> taskElapsedTimes = const [],
  }) : _taskElapsedTimes = taskElapsedTimes,
       super._();

  @override
  final ChecklistModel checklist;
  @override
  @JsonKey()
  final int currentTaskIndex;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final RunPhase phase;
  @override
  final DateTime? startedAt;
  final List<int> _taskElapsedTimes;
  @override
  @JsonKey()
  List<int> get taskElapsedTimes {
    if (_taskElapsedTimes is EqualUnmodifiableListView)
      return _taskElapsedTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taskElapsedTimes);
  }

  @override
  String toString() {
    return 'RunState(checklist: $checklist, currentTaskIndex: $currentTaskIndex, elapsedSeconds: $elapsedSeconds, phase: $phase, startedAt: $startedAt, taskElapsedTimes: $taskElapsedTimes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RunStateImpl &&
            (identical(other.checklist, checklist) ||
                other.checklist == checklist) &&
            (identical(other.currentTaskIndex, currentTaskIndex) ||
                other.currentTaskIndex == currentTaskIndex) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            const DeepCollectionEquality().equals(
              other._taskElapsedTimes,
              _taskElapsedTimes,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    checklist,
    currentTaskIndex,
    elapsedSeconds,
    phase,
    startedAt,
    const DeepCollectionEquality().hash(_taskElapsedTimes),
  );

  /// Create a copy of RunState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RunStateImplCopyWith<_$RunStateImpl> get copyWith =>
      __$$RunStateImplCopyWithImpl<_$RunStateImpl>(this, _$identity);
}

abstract class _RunState extends RunState {
  const factory _RunState({
    required final ChecklistModel checklist,
    final int currentTaskIndex,
    final int elapsedSeconds,
    final RunPhase phase,
    final DateTime? startedAt,
    final List<int> taskElapsedTimes,
  }) = _$RunStateImpl;
  const _RunState._() : super._();

  @override
  ChecklistModel get checklist;
  @override
  int get currentTaskIndex;
  @override
  int get elapsedSeconds;
  @override
  RunPhase get phase;
  @override
  DateTime? get startedAt;
  @override
  List<int> get taskElapsedTimes;

  /// Create a copy of RunState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RunStateImplCopyWith<_$RunStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
