// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChecklistSettings _$ChecklistSettingsFromJson(Map<String, dynamic> json) {
  return _ChecklistSettings.fromJson(json);
}

/// @nodoc
mixin _$ChecklistSettings {
  bool get autoAdvance => throw _privateConstructorUsedError;
  int get autoAdvanceDelaySeconds => throw _privateConstructorUsedError;

  /// Serializes this ChecklistSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistSettingsCopyWith<ChecklistSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistSettingsCopyWith<$Res> {
  factory $ChecklistSettingsCopyWith(
    ChecklistSettings value,
    $Res Function(ChecklistSettings) then,
  ) = _$ChecklistSettingsCopyWithImpl<$Res, ChecklistSettings>;
  @useResult
  $Res call({bool autoAdvance, int autoAdvanceDelaySeconds});
}

/// @nodoc
class _$ChecklistSettingsCopyWithImpl<$Res, $Val extends ChecklistSettings>
    implements $ChecklistSettingsCopyWith<$Res> {
  _$ChecklistSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoAdvance = null,
    Object? autoAdvanceDelaySeconds = null,
  }) {
    return _then(
      _value.copyWith(
            autoAdvance:
                null == autoAdvance
                    ? _value.autoAdvance
                    : autoAdvance // ignore: cast_nullable_to_non_nullable
                        as bool,
            autoAdvanceDelaySeconds:
                null == autoAdvanceDelaySeconds
                    ? _value.autoAdvanceDelaySeconds
                    : autoAdvanceDelaySeconds // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChecklistSettingsImplCopyWith<$Res>
    implements $ChecklistSettingsCopyWith<$Res> {
  factory _$$ChecklistSettingsImplCopyWith(
    _$ChecklistSettingsImpl value,
    $Res Function(_$ChecklistSettingsImpl) then,
  ) = __$$ChecklistSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool autoAdvance, int autoAdvanceDelaySeconds});
}

/// @nodoc
class __$$ChecklistSettingsImplCopyWithImpl<$Res>
    extends _$ChecklistSettingsCopyWithImpl<$Res, _$ChecklistSettingsImpl>
    implements _$$ChecklistSettingsImplCopyWith<$Res> {
  __$$ChecklistSettingsImplCopyWithImpl(
    _$ChecklistSettingsImpl _value,
    $Res Function(_$ChecklistSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChecklistSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoAdvance = null,
    Object? autoAdvanceDelaySeconds = null,
  }) {
    return _then(
      _$ChecklistSettingsImpl(
        autoAdvance:
            null == autoAdvance
                ? _value.autoAdvance
                : autoAdvance // ignore: cast_nullable_to_non_nullable
                    as bool,
        autoAdvanceDelaySeconds:
            null == autoAdvanceDelaySeconds
                ? _value.autoAdvanceDelaySeconds
                : autoAdvanceDelaySeconds // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecklistSettingsImpl implements _ChecklistSettings {
  const _$ChecklistSettingsImpl({
    this.autoAdvance = true,
    this.autoAdvanceDelaySeconds = 3,
  });

  factory _$ChecklistSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool autoAdvance;
  @override
  @JsonKey()
  final int autoAdvanceDelaySeconds;

  @override
  String toString() {
    return 'ChecklistSettings(autoAdvance: $autoAdvance, autoAdvanceDelaySeconds: $autoAdvanceDelaySeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistSettingsImpl &&
            (identical(other.autoAdvance, autoAdvance) ||
                other.autoAdvance == autoAdvance) &&
            (identical(
                  other.autoAdvanceDelaySeconds,
                  autoAdvanceDelaySeconds,
                ) ||
                other.autoAdvanceDelaySeconds == autoAdvanceDelaySeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, autoAdvance, autoAdvanceDelaySeconds);

  /// Create a copy of ChecklistSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistSettingsImplCopyWith<_$ChecklistSettingsImpl> get copyWith =>
      __$$ChecklistSettingsImplCopyWithImpl<_$ChecklistSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistSettingsImplToJson(this);
  }
}

abstract class _ChecklistSettings implements ChecklistSettings {
  const factory _ChecklistSettings({
    final bool autoAdvance,
    final int autoAdvanceDelaySeconds,
  }) = _$ChecklistSettingsImpl;

  factory _ChecklistSettings.fromJson(Map<String, dynamic> json) =
      _$ChecklistSettingsImpl.fromJson;

  @override
  bool get autoAdvance;
  @override
  int get autoAdvanceDelaySeconds;

  /// Create a copy of ChecklistSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistSettingsImplCopyWith<_$ChecklistSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
