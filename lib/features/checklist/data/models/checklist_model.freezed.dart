// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChecklistModel _$ChecklistModelFromJson(Map<String, dynamic> json) {
  return _ChecklistModel.fromJson(json);
}

/// @nodoc
mixin _$ChecklistModel {
  String get id => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  List<TaskModel> get tasks => throw _privateConstructorUsedError;
  ChecklistSettings get settings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChecklistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistModelCopyWith<ChecklistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistModelCopyWith<$Res> {
  factory $ChecklistModelCopyWith(
    ChecklistModel value,
    $Res Function(ChecklistModel) then,
  ) = _$ChecklistModelCopyWithImpl<$Res, ChecklistModel>;
  @useResult
  $Res call({
    String id,
    int version,
    String name,
    String description,
    String icon,
    String color,
    List<TaskModel> tasks,
    ChecklistSettings settings,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $ChecklistSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$ChecklistModelCopyWithImpl<$Res, $Val extends ChecklistModel>
    implements $ChecklistModelCopyWith<$Res> {
  _$ChecklistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? version = null,
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? color = null,
    Object? tasks = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            version:
                null == version
                    ? _value.version
                    : version // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            icon:
                null == icon
                    ? _value.icon
                    : icon // ignore: cast_nullable_to_non_nullable
                        as String,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as String,
            tasks:
                null == tasks
                    ? _value.tasks
                    : tasks // ignore: cast_nullable_to_non_nullable
                        as List<TaskModel>,
            settings:
                null == settings
                    ? _value.settings
                    : settings // ignore: cast_nullable_to_non_nullable
                        as ChecklistSettings,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChecklistSettingsCopyWith<$Res> get settings {
    return $ChecklistSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChecklistModelImplCopyWith<$Res>
    implements $ChecklistModelCopyWith<$Res> {
  factory _$$ChecklistModelImplCopyWith(
    _$ChecklistModelImpl value,
    $Res Function(_$ChecklistModelImpl) then,
  ) = __$$ChecklistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int version,
    String name,
    String description,
    String icon,
    String color,
    List<TaskModel> tasks,
    ChecklistSettings settings,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $ChecklistSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$ChecklistModelImplCopyWithImpl<$Res>
    extends _$ChecklistModelCopyWithImpl<$Res, _$ChecklistModelImpl>
    implements _$$ChecklistModelImplCopyWith<$Res> {
  __$$ChecklistModelImplCopyWithImpl(
    _$ChecklistModelImpl _value,
    $Res Function(_$ChecklistModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? version = null,
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? color = null,
    Object? tasks = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ChecklistModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        version:
            null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        icon:
            null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                    as String,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as String,
        tasks:
            null == tasks
                ? _value._tasks
                : tasks // ignore: cast_nullable_to_non_nullable
                    as List<TaskModel>,
        settings:
            null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                    as ChecklistSettings,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecklistModelImpl extends _ChecklistModel {
  const _$ChecklistModelImpl({
    required this.id,
    this.version = 1,
    required this.name,
    this.description = '',
    this.icon = 'checklist',
    this.color = '#6750A4',
    final List<TaskModel> tasks = const [],
    this.settings = const ChecklistSettings(),
    required this.createdAt,
    required this.updatedAt,
  }) : _tasks = tasks,
       super._();

  factory _$ChecklistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final int version;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final String color;
  final List<TaskModel> _tasks;
  @override
  @JsonKey()
  List<TaskModel> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  @JsonKey()
  final ChecklistSettings settings;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChecklistModel(id: $id, version: $version, name: $name, description: $description, icon: $icon, color: $color, tasks: $tasks, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    version,
    name,
    description,
    icon,
    color,
    const DeepCollectionEquality().hash(_tasks),
    settings,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistModelImplCopyWith<_$ChecklistModelImpl> get copyWith =>
      __$$ChecklistModelImplCopyWithImpl<_$ChecklistModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistModelImplToJson(this);
  }
}

abstract class _ChecklistModel extends ChecklistModel {
  const factory _ChecklistModel({
    required final String id,
    final int version,
    required final String name,
    final String description,
    final String icon,
    final String color,
    final List<TaskModel> tasks,
    final ChecklistSettings settings,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ChecklistModelImpl;
  const _ChecklistModel._() : super._();

  factory _ChecklistModel.fromJson(Map<String, dynamic> json) =
      _$ChecklistModelImpl.fromJson;

  @override
  String get id;
  @override
  int get version;
  @override
  String get name;
  @override
  String get description;
  @override
  String get icon;
  @override
  String get color;
  @override
  List<TaskModel> get tasks;
  @override
  ChecklistSettings get settings;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistModelImplCopyWith<_$ChecklistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
