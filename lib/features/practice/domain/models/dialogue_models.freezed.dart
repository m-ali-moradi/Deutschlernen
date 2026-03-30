// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialogue_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DialogueEntry {
  /// Unique identifier for the entry within the dialogue.
  int get id;

  /// Position of the sender: 'left' (AI/Tutor) or 'right' (User).
  String get sender;

  /// Display role name (e.g., "Kassierer", "Arzt").
  String get role;

  /// The dialogue content in German.
  String get german;

  /// The dialogue content translated to English.
  String get english;

  /// Optional URL for a pre-recorded audio file.
  /// If null, the app uses Text-to-Speech (TTS).
  String? get audioUrl;

  /// Create a copy of DialogueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DialogueEntryCopyWith<DialogueEntry> get copyWith =>
      _$DialogueEntryCopyWithImpl<DialogueEntry>(
          this as DialogueEntry, _$identity);

  /// Serializes this DialogueEntry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DialogueEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.german, german) || other.german == german) &&
            (identical(other.english, english) || other.english == english) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, sender, role, german, english, audioUrl);

  @override
  String toString() {
    return 'DialogueEntry(id: $id, sender: $sender, role: $role, german: $german, english: $english, audioUrl: $audioUrl)';
  }
}

/// @nodoc
abstract mixin class $DialogueEntryCopyWith<$Res> {
  factory $DialogueEntryCopyWith(
          DialogueEntry value, $Res Function(DialogueEntry) _then) =
      _$DialogueEntryCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String sender,
      String role,
      String german,
      String english,
      String? audioUrl});
}

/// @nodoc
class _$DialogueEntryCopyWithImpl<$Res>
    implements $DialogueEntryCopyWith<$Res> {
  _$DialogueEntryCopyWithImpl(this._self, this._then);

  final DialogueEntry _self;
  final $Res Function(DialogueEntry) _then;

  /// Create a copy of DialogueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sender = null,
    Object? role = null,
    Object? german = null,
    Object? english = null,
    Object? audioUrl = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sender: null == sender
          ? _self.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      german: null == german
          ? _self.german
          : german // ignore: cast_nullable_to_non_nullable
              as String,
      english: null == english
          ? _self.english
          : english // ignore: cast_nullable_to_non_nullable
              as String,
      audioUrl: freezed == audioUrl
          ? _self.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DialogueEntry].
extension DialogueEntryPatterns on DialogueEntry {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DialogueEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DialogueEntry() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DialogueEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DialogueEntry():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DialogueEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DialogueEntry() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String sender, String role, String german,
            String english, String? audioUrl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DialogueEntry() when $default != null:
        return $default(_that.id, _that.sender, _that.role, _that.german,
            _that.english, _that.audioUrl);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String sender, String role, String german,
            String english, String? audioUrl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DialogueEntry():
        return $default(_that.id, _that.sender, _that.role, _that.german,
            _that.english, _that.audioUrl);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String sender, String role, String german,
            String english, String? audioUrl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DialogueEntry() when $default != null:
        return $default(_that.id, _that.sender, _that.role, _that.german,
            _that.english, _that.audioUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DialogueEntry implements DialogueEntry {
  const _DialogueEntry(
      {required this.id,
      required this.sender,
      required this.role,
      required this.german,
      required this.english,
      this.audioUrl});
  factory _DialogueEntry.fromJson(Map<String, dynamic> json) =>
      _$DialogueEntryFromJson(json);

  /// Unique identifier for the entry within the dialogue.
  @override
  final int id;

  /// Position of the sender: 'left' (AI/Tutor) or 'right' (User).
  @override
  final String sender;

  /// Display role name (e.g., "Kassierer", "Arzt").
  @override
  final String role;

  /// The dialogue content in German.
  @override
  final String german;

  /// The dialogue content translated to English.
  @override
  final String english;

  /// Optional URL for a pre-recorded audio file.
  /// If null, the app uses Text-to-Speech (TTS).
  @override
  final String? audioUrl;

  /// Create a copy of DialogueEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DialogueEntryCopyWith<_DialogueEntry> get copyWith =>
      __$DialogueEntryCopyWithImpl<_DialogueEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DialogueEntryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DialogueEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.german, german) || other.german == german) &&
            (identical(other.english, english) || other.english == english) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, sender, role, german, english, audioUrl);

  @override
  String toString() {
    return 'DialogueEntry(id: $id, sender: $sender, role: $role, german: $german, english: $english, audioUrl: $audioUrl)';
  }
}

/// @nodoc
abstract mixin class _$DialogueEntryCopyWith<$Res>
    implements $DialogueEntryCopyWith<$Res> {
  factory _$DialogueEntryCopyWith(
          _DialogueEntry value, $Res Function(_DialogueEntry) _then) =
      __$DialogueEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String sender,
      String role,
      String german,
      String english,
      String? audioUrl});
}

/// @nodoc
class __$DialogueEntryCopyWithImpl<$Res>
    implements _$DialogueEntryCopyWith<$Res> {
  __$DialogueEntryCopyWithImpl(this._self, this._then);

  final _DialogueEntry _self;
  final $Res Function(_DialogueEntry) _then;

  /// Create a copy of DialogueEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sender = null,
    Object? role = null,
    Object? german = null,
    Object? english = null,
    Object? audioUrl = freezed,
  }) {
    return _then(_DialogueEntry(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sender: null == sender
          ? _self.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      german: null == german
          ? _self.german
          : german // ignore: cast_nullable_to_non_nullable
              as String,
      english: null == english
          ? _self.english
          : english // ignore: cast_nullable_to_non_nullable
              as String,
      audioUrl: freezed == audioUrl
          ? _self.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$DialogueInfo {
  /// Unique identifier for the dialogue scenario (e.g., "supermarket").
  String get id;

  /// Primary title in German.
  String get title;

  /// Secondary title in English.
  String get englishTitle;

  /// Brief pedagogical description or scenario context.
  String get description;

  /// CEFR level (A1, A2, B1, etc.).
  String get level;

  /// Category for filtering (e.g., "Einkaufen", "Arbeit").
  String get category;

  /// Icon identifier used for visual mapping in the list UI.
  String get icon;

  /// Optional URL/Path for a scenario illustration image.
  String get imageUrl;

  /// The sequence of messages forming the dialogue.
  List<DialogueEntry> get entries;

  /// Create a copy of DialogueInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DialogueInfoCopyWith<DialogueInfo> get copyWith =>
      _$DialogueInfoCopyWithImpl<DialogueInfo>(
          this as DialogueInfo, _$identity);

  /// Serializes this DialogueInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DialogueInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.englishTitle, englishTitle) ||
                other.englishTitle == englishTitle) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other.entries, entries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      englishTitle,
      description,
      level,
      category,
      icon,
      imageUrl,
      const DeepCollectionEquality().hash(entries));

  @override
  String toString() {
    return 'DialogueInfo(id: $id, title: $title, englishTitle: $englishTitle, description: $description, level: $level, category: $category, icon: $icon, imageUrl: $imageUrl, entries: $entries)';
  }
}

/// @nodoc
abstract mixin class $DialogueInfoCopyWith<$Res> {
  factory $DialogueInfoCopyWith(
          DialogueInfo value, $Res Function(DialogueInfo) _then) =
      _$DialogueInfoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String englishTitle,
      String description,
      String level,
      String category,
      String icon,
      String imageUrl,
      List<DialogueEntry> entries});
}

/// @nodoc
class _$DialogueInfoCopyWithImpl<$Res> implements $DialogueInfoCopyWith<$Res> {
  _$DialogueInfoCopyWithImpl(this._self, this._then);

  final DialogueInfo _self;
  final $Res Function(DialogueInfo) _then;

  /// Create a copy of DialogueInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? englishTitle = null,
    Object? description = null,
    Object? level = null,
    Object? category = null,
    Object? icon = null,
    Object? imageUrl = null,
    Object? entries = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      englishTitle: null == englishTitle
          ? _self.englishTitle
          : englishTitle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      entries: null == entries
          ? _self.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<DialogueEntry>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DialogueInfo].
extension DialogueInfoPatterns on DialogueInfo {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DialogueInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DialogueInfo() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DialogueInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DialogueInfo():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DialogueInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DialogueInfo() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String title,
            String englishTitle,
            String description,
            String level,
            String category,
            String icon,
            String imageUrl,
            List<DialogueEntry> entries)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DialogueInfo() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.englishTitle,
            _that.description,
            _that.level,
            _that.category,
            _that.icon,
            _that.imageUrl,
            _that.entries);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String title,
            String englishTitle,
            String description,
            String level,
            String category,
            String icon,
            String imageUrl,
            List<DialogueEntry> entries)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DialogueInfo():
        return $default(
            _that.id,
            _that.title,
            _that.englishTitle,
            _that.description,
            _that.level,
            _that.category,
            _that.icon,
            _that.imageUrl,
            _that.entries);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String title,
            String englishTitle,
            String description,
            String level,
            String category,
            String icon,
            String imageUrl,
            List<DialogueEntry> entries)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DialogueInfo() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.englishTitle,
            _that.description,
            _that.level,
            _that.category,
            _that.icon,
            _that.imageUrl,
            _that.entries);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DialogueInfo implements DialogueInfo {
  const _DialogueInfo(
      {required this.id,
      required this.title,
      this.englishTitle = '',
      this.description = '',
      required this.level,
      required this.category,
      this.icon = '',
      this.imageUrl = '',
      required final List<DialogueEntry> entries})
      : _entries = entries;
  factory _DialogueInfo.fromJson(Map<String, dynamic> json) =>
      _$DialogueInfoFromJson(json);

  /// Unique identifier for the dialogue scenario (e.g., "supermarket").
  @override
  final String id;

  /// Primary title in German.
  @override
  final String title;

  /// Secondary title in English.
  @override
  @JsonKey()
  final String englishTitle;

  /// Brief pedagogical description or scenario context.
  @override
  @JsonKey()
  final String description;

  /// CEFR level (A1, A2, B1, etc.).
  @override
  final String level;

  /// Category for filtering (e.g., "Einkaufen", "Arbeit").
  @override
  final String category;

  /// Icon identifier used for visual mapping in the list UI.
  @override
  @JsonKey()
  final String icon;

  /// Optional URL/Path for a scenario illustration image.
  @override
  @JsonKey()
  final String imageUrl;

  /// The sequence of messages forming the dialogue.
  final List<DialogueEntry> _entries;

  /// The sequence of messages forming the dialogue.
  @override
  List<DialogueEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  /// Create a copy of DialogueInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DialogueInfoCopyWith<_DialogueInfo> get copyWith =>
      __$DialogueInfoCopyWithImpl<_DialogueInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DialogueInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DialogueInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.englishTitle, englishTitle) ||
                other.englishTitle == englishTitle) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      englishTitle,
      description,
      level,
      category,
      icon,
      imageUrl,
      const DeepCollectionEquality().hash(_entries));

  @override
  String toString() {
    return 'DialogueInfo(id: $id, title: $title, englishTitle: $englishTitle, description: $description, level: $level, category: $category, icon: $icon, imageUrl: $imageUrl, entries: $entries)';
  }
}

/// @nodoc
abstract mixin class _$DialogueInfoCopyWith<$Res>
    implements $DialogueInfoCopyWith<$Res> {
  factory _$DialogueInfoCopyWith(
          _DialogueInfo value, $Res Function(_DialogueInfo) _then) =
      __$DialogueInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String englishTitle,
      String description,
      String level,
      String category,
      String icon,
      String imageUrl,
      List<DialogueEntry> entries});
}

/// @nodoc
class __$DialogueInfoCopyWithImpl<$Res>
    implements _$DialogueInfoCopyWith<$Res> {
  __$DialogueInfoCopyWithImpl(this._self, this._then);

  final _DialogueInfo _self;
  final $Res Function(_DialogueInfo) _then;

  /// Create a copy of DialogueInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? englishTitle = null,
    Object? description = null,
    Object? level = null,
    Object? category = null,
    Object? icon = null,
    Object? imageUrl = null,
    Object? entries = null,
  }) {
    return _then(_DialogueInfo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      englishTitle: null == englishTitle
          ? _self.englishTitle
          : englishTitle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      entries: null == entries
          ? _self._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<DialogueEntry>,
    ));
  }
}

// dart format on
