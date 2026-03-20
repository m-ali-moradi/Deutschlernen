// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VocabularyWordsTable extends VocabularyWords
    with TableInfo<$VocabularyWordsTable, VocabularyWord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _germanMeta = const VerificationMeta('german');
  @override
  late final GeneratedColumn<String> german = GeneratedColumn<String>(
      'german', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _englishMeta =
      const VerificationMeta('english');
  @override
  late final GeneratedColumn<String> english = GeneratedColumn<String>(
      'english', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dariMeta = const VerificationMeta('dari');
  @override
  late final GeneratedColumn<String> dari = GeneratedColumn<String>(
      'dari', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
      'tag', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exampleMeta =
      const VerificationMeta('example');
  @override
  late final GeneratedColumn<String> example = GeneratedColumn<String>(
      'example', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contextMeta =
      const VerificationMeta('context');
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
      'context', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contextDariMeta =
      const VerificationMeta('contextDari');
  @override
  late final GeneratedColumn<String> contextDari = GeneratedColumn<String>(
      'context_dari', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDifficultMeta =
      const VerificationMeta('isDifficult');
  @override
  late final GeneratedColumn<bool> isDifficult = GeneratedColumn<bool>(
      'is_difficult', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_difficult" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        german,
        english,
        dari,
        category,
        tag,
        example,
        context,
        contextDari,
        difficulty,
        isFavorite,
        isDifficult,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_words';
  @override
  VerificationContext validateIntegrity(Insertable<VocabularyWord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('german')) {
      context.handle(_germanMeta,
          german.isAcceptableOrUnknown(data['german']!, _germanMeta));
    } else if (isInserting) {
      context.missing(_germanMeta);
    }
    if (data.containsKey('english')) {
      context.handle(_englishMeta,
          english.isAcceptableOrUnknown(data['english']!, _englishMeta));
    } else if (isInserting) {
      context.missing(_englishMeta);
    }
    if (data.containsKey('dari')) {
      context.handle(
          _dariMeta, dari.isAcceptableOrUnknown(data['dari']!, _dariMeta));
    } else if (isInserting) {
      context.missing(_dariMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
          _tagMeta, tag.isAcceptableOrUnknown(data['tag']!, _tagMeta));
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    if (data.containsKey('example')) {
      context.handle(_exampleMeta,
          example.isAcceptableOrUnknown(data['example']!, _exampleMeta));
    } else if (isInserting) {
      context.missing(_exampleMeta);
    }
    if (data.containsKey('context')) {
      context.handle(_contextMeta,
          this.context.isAcceptableOrUnknown(data['context']!, _contextMeta));
    } else if (isInserting) {
      context.missing(_contextMeta);
    }
    if (data.containsKey('context_dari')) {
      context.handle(
          _contextDariMeta,
          contextDari.isAcceptableOrUnknown(
              data['context_dari']!, _contextDariMeta));
    } else if (isInserting) {
      context.missing(_contextDariMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('is_difficult')) {
      context.handle(
          _isDifficultMeta,
          isDifficult.isAcceptableOrUnknown(
              data['is_difficult']!, _isDifficultMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularyWord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyWord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      german: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}german'])!,
      english: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}english'])!,
      dari: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dari'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag'])!,
      example: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example'])!,
      context: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context'])!,
      contextDari: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context_dari'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      isDifficult: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_difficult'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $VocabularyWordsTable createAlias(String alias) {
    return $VocabularyWordsTable(attachedDatabase, alias);
  }
}

class VocabularyWord extends DataClass implements Insertable<VocabularyWord> {
  final String id;
  final String german;
  final String english;
  final String dari;
  final String category;
  final String tag;
  final String example;
  final String context;
  final String contextDari;
  final String difficulty;
  final bool isFavorite;
  final bool isDifficult;
  final DateTime updatedAt;
  const VocabularyWord(
      {required this.id,
      required this.german,
      required this.english,
      required this.dari,
      required this.category,
      required this.tag,
      required this.example,
      required this.context,
      required this.contextDari,
      required this.difficulty,
      required this.isFavorite,
      required this.isDifficult,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['german'] = Variable<String>(german);
    map['english'] = Variable<String>(english);
    map['dari'] = Variable<String>(dari);
    map['category'] = Variable<String>(category);
    map['tag'] = Variable<String>(tag);
    map['example'] = Variable<String>(example);
    map['context'] = Variable<String>(context);
    map['context_dari'] = Variable<String>(contextDari);
    map['difficulty'] = Variable<String>(difficulty);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_difficult'] = Variable<bool>(isDifficult);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularyWordsCompanion toCompanion(bool nullToAbsent) {
    return VocabularyWordsCompanion(
      id: Value(id),
      german: Value(german),
      english: Value(english),
      dari: Value(dari),
      category: Value(category),
      tag: Value(tag),
      example: Value(example),
      context: Value(context),
      contextDari: Value(contextDari),
      difficulty: Value(difficulty),
      isFavorite: Value(isFavorite),
      isDifficult: Value(isDifficult),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularyWord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyWord(
      id: serializer.fromJson<String>(json['id']),
      german: serializer.fromJson<String>(json['german']),
      english: serializer.fromJson<String>(json['english']),
      dari: serializer.fromJson<String>(json['dari']),
      category: serializer.fromJson<String>(json['category']),
      tag: serializer.fromJson<String>(json['tag']),
      example: serializer.fromJson<String>(json['example']),
      context: serializer.fromJson<String>(json['context']),
      contextDari: serializer.fromJson<String>(json['contextDari']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isDifficult: serializer.fromJson<bool>(json['isDifficult']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'german': serializer.toJson<String>(german),
      'english': serializer.toJson<String>(english),
      'dari': serializer.toJson<String>(dari),
      'category': serializer.toJson<String>(category),
      'tag': serializer.toJson<String>(tag),
      'example': serializer.toJson<String>(example),
      'context': serializer.toJson<String>(context),
      'contextDari': serializer.toJson<String>(contextDari),
      'difficulty': serializer.toJson<String>(difficulty),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isDifficult': serializer.toJson<bool>(isDifficult),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularyWord copyWith(
          {String? id,
          String? german,
          String? english,
          String? dari,
          String? category,
          String? tag,
          String? example,
          String? context,
          String? contextDari,
          String? difficulty,
          bool? isFavorite,
          bool? isDifficult,
          DateTime? updatedAt}) =>
      VocabularyWord(
        id: id ?? this.id,
        german: german ?? this.german,
        english: english ?? this.english,
        dari: dari ?? this.dari,
        category: category ?? this.category,
        tag: tag ?? this.tag,
        example: example ?? this.example,
        context: context ?? this.context,
        contextDari: contextDari ?? this.contextDari,
        difficulty: difficulty ?? this.difficulty,
        isFavorite: isFavorite ?? this.isFavorite,
        isDifficult: isDifficult ?? this.isDifficult,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  VocabularyWord copyWithCompanion(VocabularyWordsCompanion data) {
    return VocabularyWord(
      id: data.id.present ? data.id.value : this.id,
      german: data.german.present ? data.german.value : this.german,
      english: data.english.present ? data.english.value : this.english,
      dari: data.dari.present ? data.dari.value : this.dari,
      category: data.category.present ? data.category.value : this.category,
      tag: data.tag.present ? data.tag.value : this.tag,
      example: data.example.present ? data.example.value : this.example,
      context: data.context.present ? data.context.value : this.context,
      contextDari:
          data.contextDari.present ? data.contextDari.value : this.contextDari,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      isDifficult:
          data.isDifficult.present ? data.isDifficult.value : this.isDifficult,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyWord(')
          ..write('id: $id, ')
          ..write('german: $german, ')
          ..write('english: $english, ')
          ..write('dari: $dari, ')
          ..write('category: $category, ')
          ..write('tag: $tag, ')
          ..write('example: $example, ')
          ..write('context: $context, ')
          ..write('contextDari: $contextDari, ')
          ..write('difficulty: $difficulty, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isDifficult: $isDifficult, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      german,
      english,
      dari,
      category,
      tag,
      example,
      context,
      contextDari,
      difficulty,
      isFavorite,
      isDifficult,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyWord &&
          other.id == this.id &&
          other.german == this.german &&
          other.english == this.english &&
          other.dari == this.dari &&
          other.category == this.category &&
          other.tag == this.tag &&
          other.example == this.example &&
          other.context == this.context &&
          other.contextDari == this.contextDari &&
          other.difficulty == this.difficulty &&
          other.isFavorite == this.isFavorite &&
          other.isDifficult == this.isDifficult &&
          other.updatedAt == this.updatedAt);
}

class VocabularyWordsCompanion extends UpdateCompanion<VocabularyWord> {
  final Value<String> id;
  final Value<String> german;
  final Value<String> english;
  final Value<String> dari;
  final Value<String> category;
  final Value<String> tag;
  final Value<String> example;
  final Value<String> context;
  final Value<String> contextDari;
  final Value<String> difficulty;
  final Value<bool> isFavorite;
  final Value<bool> isDifficult;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VocabularyWordsCompanion({
    this.id = const Value.absent(),
    this.german = const Value.absent(),
    this.english = const Value.absent(),
    this.dari = const Value.absent(),
    this.category = const Value.absent(),
    this.tag = const Value.absent(),
    this.example = const Value.absent(),
    this.context = const Value.absent(),
    this.contextDari = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isDifficult = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyWordsCompanion.insert({
    required String id,
    required String german,
    required String english,
    required String dari,
    required String category,
    required String tag,
    required String example,
    required String context,
    required String contextDari,
    required String difficulty,
    this.isFavorite = const Value.absent(),
    this.isDifficult = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        german = Value(german),
        english = Value(english),
        dari = Value(dari),
        category = Value(category),
        tag = Value(tag),
        example = Value(example),
        context = Value(context),
        contextDari = Value(contextDari),
        difficulty = Value(difficulty);
  static Insertable<VocabularyWord> custom({
    Expression<String>? id,
    Expression<String>? german,
    Expression<String>? english,
    Expression<String>? dari,
    Expression<String>? category,
    Expression<String>? tag,
    Expression<String>? example,
    Expression<String>? context,
    Expression<String>? contextDari,
    Expression<String>? difficulty,
    Expression<bool>? isFavorite,
    Expression<bool>? isDifficult,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (german != null) 'german': german,
      if (english != null) 'english': english,
      if (dari != null) 'dari': dari,
      if (category != null) 'category': category,
      if (tag != null) 'tag': tag,
      if (example != null) 'example': example,
      if (context != null) 'context': context,
      if (contextDari != null) 'context_dari': contextDari,
      if (difficulty != null) 'difficulty': difficulty,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isDifficult != null) 'is_difficult': isDifficult,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyWordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? german,
      Value<String>? english,
      Value<String>? dari,
      Value<String>? category,
      Value<String>? tag,
      Value<String>? example,
      Value<String>? context,
      Value<String>? contextDari,
      Value<String>? difficulty,
      Value<bool>? isFavorite,
      Value<bool>? isDifficult,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return VocabularyWordsCompanion(
      id: id ?? this.id,
      german: german ?? this.german,
      english: english ?? this.english,
      dari: dari ?? this.dari,
      category: category ?? this.category,
      tag: tag ?? this.tag,
      example: example ?? this.example,
      context: context ?? this.context,
      contextDari: contextDari ?? this.contextDari,
      difficulty: difficulty ?? this.difficulty,
      isFavorite: isFavorite ?? this.isFavorite,
      isDifficult: isDifficult ?? this.isDifficult,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (german.present) {
      map['german'] = Variable<String>(german.value);
    }
    if (english.present) {
      map['english'] = Variable<String>(english.value);
    }
    if (dari.present) {
      map['dari'] = Variable<String>(dari.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (example.present) {
      map['example'] = Variable<String>(example.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (contextDari.present) {
      map['context_dari'] = Variable<String>(contextDari.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isDifficult.present) {
      map['is_difficult'] = Variable<bool>(isDifficult.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyWordsCompanion(')
          ..write('id: $id, ')
          ..write('german: $german, ')
          ..write('english: $english, ')
          ..write('dari: $dari, ')
          ..write('category: $category, ')
          ..write('tag: $tag, ')
          ..write('example: $example, ')
          ..write('context: $context, ')
          ..write('contextDari: $contextDari, ')
          ..write('difficulty: $difficulty, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isDifficult: $isDifficult, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VocabularyProgressTable extends VocabularyProgress
    with TableInfo<$VocabularyProgressTable, VocabularyProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
      'word_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _leitnerBoxMeta =
      const VerificationMeta('leitnerBox');
  @override
  late final GeneratedColumn<int> leitnerBox = GeneratedColumn<int>(
      'leitner_box', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('new'));
  static const VerificationMeta _lastResultMeta =
      const VerificationMeta('lastResult');
  @override
  late final GeneratedColumn<String> lastResult = GeneratedColumn<String>(
      'last_result', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reviewCountMeta =
      const VerificationMeta('reviewCount');
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
      'review_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lapseCountMeta =
      const VerificationMeta('lapseCount');
  @override
  late final GeneratedColumn<int> lapseCount = GeneratedColumn<int>(
      'lapse_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _nextReviewAtMeta =
      const VerificationMeta('nextReviewAt');
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
      'next_review_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _masteredAtMeta =
      const VerificationMeta('masteredAt');
  @override
  late final GeneratedColumn<DateTime> masteredAt = GeneratedColumn<DateTime>(
      'mastered_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        wordId,
        leitnerBox,
        status,
        lastResult,
        reviewCount,
        lapseCount,
        lastReviewedAt,
        nextReviewAt,
        masteredAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_progress';
  @override
  VerificationContext validateIntegrity(
      Insertable<VocabularyProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('leitner_box')) {
      context.handle(
          _leitnerBoxMeta,
          leitnerBox.isAcceptableOrUnknown(
              data['leitner_box']!, _leitnerBoxMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('last_result')) {
      context.handle(
          _lastResultMeta,
          lastResult.isAcceptableOrUnknown(
              data['last_result']!, _lastResultMeta));
    }
    if (data.containsKey('review_count')) {
      context.handle(
          _reviewCountMeta,
          reviewCount.isAcceptableOrUnknown(
              data['review_count']!, _reviewCountMeta));
    }
    if (data.containsKey('lapse_count')) {
      context.handle(
          _lapseCountMeta,
          lapseCount.isAcceptableOrUnknown(
              data['lapse_count']!, _lapseCountMeta));
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
          _nextReviewAtMeta,
          nextReviewAt.isAcceptableOrUnknown(
              data['next_review_at']!, _nextReviewAtMeta));
    }
    if (data.containsKey('mastered_at')) {
      context.handle(
          _masteredAtMeta,
          masteredAt.isAcceptableOrUnknown(
              data['mastered_at']!, _masteredAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  VocabularyProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyProgressData(
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_id'])!,
      leitnerBox: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}leitner_box'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      lastResult: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_result']),
      reviewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_count'])!,
      lapseCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lapse_count'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
      nextReviewAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_review_at']),
      masteredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}mastered_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $VocabularyProgressTable createAlias(String alias) {
    return $VocabularyProgressTable(attachedDatabase, alias);
  }
}

class VocabularyProgressData extends DataClass
    implements Insertable<VocabularyProgressData> {
  final String wordId;
  final int leitnerBox;
  final String status;
  final String? lastResult;
  final int reviewCount;
  final int lapseCount;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;
  final DateTime? masteredAt;
  final DateTime updatedAt;
  const VocabularyProgressData(
      {required this.wordId,
      required this.leitnerBox,
      required this.status,
      this.lastResult,
      required this.reviewCount,
      required this.lapseCount,
      this.lastReviewedAt,
      this.nextReviewAt,
      this.masteredAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['leitner_box'] = Variable<int>(leitnerBox);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastResult != null) {
      map['last_result'] = Variable<String>(lastResult);
    }
    map['review_count'] = Variable<int>(reviewCount);
    map['lapse_count'] = Variable<int>(lapseCount);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    if (!nullToAbsent || nextReviewAt != null) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    }
    if (!nullToAbsent || masteredAt != null) {
      map['mastered_at'] = Variable<DateTime>(masteredAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularyProgressCompanion toCompanion(bool nullToAbsent) {
    return VocabularyProgressCompanion(
      wordId: Value(wordId),
      leitnerBox: Value(leitnerBox),
      status: Value(status),
      lastResult: lastResult == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResult),
      reviewCount: Value(reviewCount),
      lapseCount: Value(lapseCount),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      nextReviewAt: nextReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewAt),
      masteredAt: masteredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(masteredAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularyProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyProgressData(
      wordId: serializer.fromJson<String>(json['wordId']),
      leitnerBox: serializer.fromJson<int>(json['leitnerBox']),
      status: serializer.fromJson<String>(json['status']),
      lastResult: serializer.fromJson<String?>(json['lastResult']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      lapseCount: serializer.fromJson<int>(json['lapseCount']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      nextReviewAt: serializer.fromJson<DateTime?>(json['nextReviewAt']),
      masteredAt: serializer.fromJson<DateTime?>(json['masteredAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'leitnerBox': serializer.toJson<int>(leitnerBox),
      'status': serializer.toJson<String>(status),
      'lastResult': serializer.toJson<String?>(lastResult),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'lapseCount': serializer.toJson<int>(lapseCount),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'nextReviewAt': serializer.toJson<DateTime?>(nextReviewAt),
      'masteredAt': serializer.toJson<DateTime?>(masteredAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularyProgressData copyWith(
          {String? wordId,
          int? leitnerBox,
          String? status,
          Value<String?> lastResult = const Value.absent(),
          int? reviewCount,
          int? lapseCount,
          Value<DateTime?> lastReviewedAt = const Value.absent(),
          Value<DateTime?> nextReviewAt = const Value.absent(),
          Value<DateTime?> masteredAt = const Value.absent(),
          DateTime? updatedAt}) =>
      VocabularyProgressData(
        wordId: wordId ?? this.wordId,
        leitnerBox: leitnerBox ?? this.leitnerBox,
        status: status ?? this.status,
        lastResult: lastResult.present ? lastResult.value : this.lastResult,
        reviewCount: reviewCount ?? this.reviewCount,
        lapseCount: lapseCount ?? this.lapseCount,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
        nextReviewAt:
            nextReviewAt.present ? nextReviewAt.value : this.nextReviewAt,
        masteredAt: masteredAt.present ? masteredAt.value : this.masteredAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  VocabularyProgressData copyWithCompanion(VocabularyProgressCompanion data) {
    return VocabularyProgressData(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      leitnerBox:
          data.leitnerBox.present ? data.leitnerBox.value : this.leitnerBox,
      status: data.status.present ? data.status.value : this.status,
      lastResult:
          data.lastResult.present ? data.lastResult.value : this.lastResult,
      reviewCount:
          data.reviewCount.present ? data.reviewCount.value : this.reviewCount,
      lapseCount:
          data.lapseCount.present ? data.lapseCount.value : this.lapseCount,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      masteredAt:
          data.masteredAt.present ? data.masteredAt.value : this.masteredAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyProgressData(')
          ..write('wordId: $wordId, ')
          ..write('leitnerBox: $leitnerBox, ')
          ..write('status: $status, ')
          ..write('lastResult: $lastResult, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('lapseCount: $lapseCount, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('masteredAt: $masteredAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      wordId,
      leitnerBox,
      status,
      lastResult,
      reviewCount,
      lapseCount,
      lastReviewedAt,
      nextReviewAt,
      masteredAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyProgressData &&
          other.wordId == this.wordId &&
          other.leitnerBox == this.leitnerBox &&
          other.status == this.status &&
          other.lastResult == this.lastResult &&
          other.reviewCount == this.reviewCount &&
          other.lapseCount == this.lapseCount &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.nextReviewAt == this.nextReviewAt &&
          other.masteredAt == this.masteredAt &&
          other.updatedAt == this.updatedAt);
}

class VocabularyProgressCompanion
    extends UpdateCompanion<VocabularyProgressData> {
  final Value<String> wordId;
  final Value<int> leitnerBox;
  final Value<String> status;
  final Value<String?> lastResult;
  final Value<int> reviewCount;
  final Value<int> lapseCount;
  final Value<DateTime?> lastReviewedAt;
  final Value<DateTime?> nextReviewAt;
  final Value<DateTime?> masteredAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VocabularyProgressCompanion({
    this.wordId = const Value.absent(),
    this.leitnerBox = const Value.absent(),
    this.status = const Value.absent(),
    this.lastResult = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.lapseCount = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.masteredAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyProgressCompanion.insert({
    required String wordId,
    this.leitnerBox = const Value.absent(),
    this.status = const Value.absent(),
    this.lastResult = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.lapseCount = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.masteredAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId);
  static Insertable<VocabularyProgressData> custom({
    Expression<String>? wordId,
    Expression<int>? leitnerBox,
    Expression<String>? status,
    Expression<String>? lastResult,
    Expression<int>? reviewCount,
    Expression<int>? lapseCount,
    Expression<DateTime>? lastReviewedAt,
    Expression<DateTime>? nextReviewAt,
    Expression<DateTime>? masteredAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (leitnerBox != null) 'leitner_box': leitnerBox,
      if (status != null) 'status': status,
      if (lastResult != null) 'last_result': lastResult,
      if (reviewCount != null) 'review_count': reviewCount,
      if (lapseCount != null) 'lapse_count': lapseCount,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (masteredAt != null) 'mastered_at': masteredAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyProgressCompanion copyWith(
      {Value<String>? wordId,
      Value<int>? leitnerBox,
      Value<String>? status,
      Value<String?>? lastResult,
      Value<int>? reviewCount,
      Value<int>? lapseCount,
      Value<DateTime?>? lastReviewedAt,
      Value<DateTime?>? nextReviewAt,
      Value<DateTime?>? masteredAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return VocabularyProgressCompanion(
      wordId: wordId ?? this.wordId,
      leitnerBox: leitnerBox ?? this.leitnerBox,
      status: status ?? this.status,
      lastResult: lastResult ?? this.lastResult,
      reviewCount: reviewCount ?? this.reviewCount,
      lapseCount: lapseCount ?? this.lapseCount,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      masteredAt: masteredAt ?? this.masteredAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (leitnerBox.present) {
      map['leitner_box'] = Variable<int>(leitnerBox.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastResult.present) {
      map['last_result'] = Variable<String>(lastResult.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (lapseCount.present) {
      map['lapse_count'] = Variable<int>(lapseCount.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (masteredAt.present) {
      map['mastered_at'] = Variable<DateTime>(masteredAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyProgressCompanion(')
          ..write('wordId: $wordId, ')
          ..write('leitnerBox: $leitnerBox, ')
          ..write('status: $status, ')
          ..write('lastResult: $lastResult, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('lapseCount: $lapseCount, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('masteredAt: $masteredAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarTopicsTable extends GrammarTopics
    with TableInfo<$GrammarTopicsTable, GrammarTopic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarTopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ruleMeta = const VerificationMeta('rule');
  @override
  late final GeneratedColumn<String> rule = GeneratedColumn<String>(
      'rule', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _examplesJsonMeta =
      const VerificationMeta('examplesJson');
  @override
  late final GeneratedColumn<String> examplesJson = GeneratedColumn<String>(
      'examples_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        level,
        category,
        icon,
        rule,
        explanation,
        examplesJson,
        progress,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_topics';
  @override
  VerificationContext validateIntegrity(Insertable<GrammarTopic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('rule')) {
      context.handle(
          _ruleMeta, rule.isAcceptableOrUnknown(data['rule']!, _ruleMeta));
    } else if (isInserting) {
      context.missing(_ruleMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('examples_json')) {
      context.handle(
          _examplesJsonMeta,
          examplesJson.isAcceptableOrUnknown(
              data['examples_json']!, _examplesJsonMeta));
    } else if (isInserting) {
      context.missing(_examplesJsonMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarTopic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarTopic(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      rule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rule'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      examplesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}examples_json'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $GrammarTopicsTable createAlias(String alias) {
    return $GrammarTopicsTable(attachedDatabase, alias);
  }
}

class GrammarTopic extends DataClass implements Insertable<GrammarTopic> {
  final String id;
  final String title;
  final String level;
  final String category;
  final String icon;
  final String rule;
  final String explanation;
  final String examplesJson;
  final int progress;
  final DateTime updatedAt;
  const GrammarTopic(
      {required this.id,
      required this.title,
      required this.level,
      required this.category,
      required this.icon,
      required this.rule,
      required this.explanation,
      required this.examplesJson,
      required this.progress,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['level'] = Variable<String>(level);
    map['category'] = Variable<String>(category);
    map['icon'] = Variable<String>(icon);
    map['rule'] = Variable<String>(rule);
    map['explanation'] = Variable<String>(explanation);
    map['examples_json'] = Variable<String>(examplesJson);
    map['progress'] = Variable<int>(progress);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GrammarTopicsCompanion toCompanion(bool nullToAbsent) {
    return GrammarTopicsCompanion(
      id: Value(id),
      title: Value(title),
      level: Value(level),
      category: Value(category),
      icon: Value(icon),
      rule: Value(rule),
      explanation: Value(explanation),
      examplesJson: Value(examplesJson),
      progress: Value(progress),
      updatedAt: Value(updatedAt),
    );
  }

  factory GrammarTopic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarTopic(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      level: serializer.fromJson<String>(json['level']),
      category: serializer.fromJson<String>(json['category']),
      icon: serializer.fromJson<String>(json['icon']),
      rule: serializer.fromJson<String>(json['rule']),
      explanation: serializer.fromJson<String>(json['explanation']),
      examplesJson: serializer.fromJson<String>(json['examplesJson']),
      progress: serializer.fromJson<int>(json['progress']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'level': serializer.toJson<String>(level),
      'category': serializer.toJson<String>(category),
      'icon': serializer.toJson<String>(icon),
      'rule': serializer.toJson<String>(rule),
      'explanation': serializer.toJson<String>(explanation),
      'examplesJson': serializer.toJson<String>(examplesJson),
      'progress': serializer.toJson<int>(progress),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GrammarTopic copyWith(
          {String? id,
          String? title,
          String? level,
          String? category,
          String? icon,
          String? rule,
          String? explanation,
          String? examplesJson,
          int? progress,
          DateTime? updatedAt}) =>
      GrammarTopic(
        id: id ?? this.id,
        title: title ?? this.title,
        level: level ?? this.level,
        category: category ?? this.category,
        icon: icon ?? this.icon,
        rule: rule ?? this.rule,
        explanation: explanation ?? this.explanation,
        examplesJson: examplesJson ?? this.examplesJson,
        progress: progress ?? this.progress,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  GrammarTopic copyWithCompanion(GrammarTopicsCompanion data) {
    return GrammarTopic(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      level: data.level.present ? data.level.value : this.level,
      category: data.category.present ? data.category.value : this.category,
      icon: data.icon.present ? data.icon.value : this.icon,
      rule: data.rule.present ? data.rule.value : this.rule,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      examplesJson: data.examplesJson.present
          ? data.examplesJson.value
          : this.examplesJson,
      progress: data.progress.present ? data.progress.value : this.progress,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarTopic(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('category: $category, ')
          ..write('icon: $icon, ')
          ..write('rule: $rule, ')
          ..write('explanation: $explanation, ')
          ..write('examplesJson: $examplesJson, ')
          ..write('progress: $progress, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, level, category, icon, rule,
      explanation, examplesJson, progress, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarTopic &&
          other.id == this.id &&
          other.title == this.title &&
          other.level == this.level &&
          other.category == this.category &&
          other.icon == this.icon &&
          other.rule == this.rule &&
          other.explanation == this.explanation &&
          other.examplesJson == this.examplesJson &&
          other.progress == this.progress &&
          other.updatedAt == this.updatedAt);
}

class GrammarTopicsCompanion extends UpdateCompanion<GrammarTopic> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> level;
  final Value<String> category;
  final Value<String> icon;
  final Value<String> rule;
  final Value<String> explanation;
  final Value<String> examplesJson;
  final Value<int> progress;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GrammarTopicsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.level = const Value.absent(),
    this.category = const Value.absent(),
    this.icon = const Value.absent(),
    this.rule = const Value.absent(),
    this.explanation = const Value.absent(),
    this.examplesJson = const Value.absent(),
    this.progress = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarTopicsCompanion.insert({
    required String id,
    required String title,
    required String level,
    required String category,
    required String icon,
    required String rule,
    required String explanation,
    required String examplesJson,
    this.progress = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        level = Value(level),
        category = Value(category),
        icon = Value(icon),
        rule = Value(rule),
        explanation = Value(explanation),
        examplesJson = Value(examplesJson);
  static Insertable<GrammarTopic> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? level,
    Expression<String>? category,
    Expression<String>? icon,
    Expression<String>? rule,
    Expression<String>? explanation,
    Expression<String>? examplesJson,
    Expression<int>? progress,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (level != null) 'level': level,
      if (category != null) 'category': category,
      if (icon != null) 'icon': icon,
      if (rule != null) 'rule': rule,
      if (explanation != null) 'explanation': explanation,
      if (examplesJson != null) 'examples_json': examplesJson,
      if (progress != null) 'progress': progress,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarTopicsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? level,
      Value<String>? category,
      Value<String>? icon,
      Value<String>? rule,
      Value<String>? explanation,
      Value<String>? examplesJson,
      Value<int>? progress,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return GrammarTopicsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      rule: rule ?? this.rule,
      explanation: explanation ?? this.explanation,
      examplesJson: examplesJson ?? this.examplesJson,
      progress: progress ?? this.progress,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (rule.present) {
      map['rule'] = Variable<String>(rule.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (examplesJson.present) {
      map['examples_json'] = Variable<String>(examplesJson.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarTopicsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('category: $category, ')
          ..write('icon: $icon, ')
          ..write('rule: $rule, ')
          ..write('explanation: $explanation, ')
          ..write('examplesJson: $examplesJson, ')
          ..write('progress: $progress, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionsJsonMeta =
      const VerificationMeta('optionsJson');
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
      'options_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswerMeta =
      const VerificationMeta('correctAnswer');
  @override
  late final GeneratedColumn<int> correctAnswer = GeneratedColumn<int>(
      'correct_answer', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
      'topic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, question, optionsJson, correctAnswer, topic, level, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('options_json')) {
      context.handle(
          _optionsJsonMeta,
          optionsJson.isAcceptableOrUnknown(
              data['options_json']!, _optionsJsonMeta));
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
          _correctAnswerMeta,
          correctAnswer.isAcceptableOrUnknown(
              data['correct_answer']!, _correctAnswerMeta));
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
          _topicMeta, topic.isAcceptableOrUnknown(data['topic']!, _topicMeta));
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      optionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}options_json'])!,
      correctAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_answer'])!,
      topic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final String type;
  final String question;
  final String optionsJson;
  final int correctAnswer;
  final String topic;
  final String level;
  final DateTime updatedAt;
  const Exercise(
      {required this.id,
      required this.type,
      required this.question,
      required this.optionsJson,
      required this.correctAnswer,
      required this.topic,
      required this.level,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['question'] = Variable<String>(question);
    map['options_json'] = Variable<String>(optionsJson);
    map['correct_answer'] = Variable<int>(correctAnswer);
    map['topic'] = Variable<String>(topic);
    map['level'] = Variable<String>(level);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      type: Value(type),
      question: Value(question),
      optionsJson: Value(optionsJson),
      correctAnswer: Value(correctAnswer),
      topic: Value(topic),
      level: Value(level),
      updatedAt: Value(updatedAt),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      question: serializer.fromJson<String>(json['question']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      correctAnswer: serializer.fromJson<int>(json['correctAnswer']),
      topic: serializer.fromJson<String>(json['topic']),
      level: serializer.fromJson<String>(json['level']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'question': serializer.toJson<String>(question),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'correctAnswer': serializer.toJson<int>(correctAnswer),
      'topic': serializer.toJson<String>(topic),
      'level': serializer.toJson<String>(level),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Exercise copyWith(
          {String? id,
          String? type,
          String? question,
          String? optionsJson,
          int? correctAnswer,
          String? topic,
          String? level,
          DateTime? updatedAt}) =>
      Exercise(
        id: id ?? this.id,
        type: type ?? this.type,
        question: question ?? this.question,
        optionsJson: optionsJson ?? this.optionsJson,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        topic: topic ?? this.topic,
        level: level ?? this.level,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      question: data.question.present ? data.question.value : this.question,
      optionsJson:
          data.optionsJson.present ? data.optionsJson.value : this.optionsJson,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      topic: data.topic.present ? data.topic.value : this.topic,
      level: data.level.present ? data.level.value : this.level,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('question: $question, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('topic: $topic, ')
          ..write('level: $level, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, type, question, optionsJson, correctAnswer, topic, level, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.type == this.type &&
          other.question == this.question &&
          other.optionsJson == this.optionsJson &&
          other.correctAnswer == this.correctAnswer &&
          other.topic == this.topic &&
          other.level == this.level &&
          other.updatedAt == this.updatedAt);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> question;
  final Value<String> optionsJson;
  final Value<int> correctAnswer;
  final Value<String> topic;
  final Value<String> level;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.topic = const Value.absent(),
    this.level = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String type,
    required String question,
    required String optionsJson,
    required int correctAnswer,
    required String topic,
    required String level,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        question = Value(question),
        optionsJson = Value(optionsJson),
        correctAnswer = Value(correctAnswer),
        topic = Value(topic),
        level = Value(level);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? question,
    Expression<String>? optionsJson,
    Expression<int>? correctAnswer,
    Expression<String>? topic,
    Expression<String>? level,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (question != null) 'question': question,
      if (optionsJson != null) 'options_json': optionsJson,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (topic != null) 'topic': topic,
      if (level != null) 'level': level,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? question,
      Value<String>? optionsJson,
      Value<int>? correctAnswer,
      Value<String>? topic,
      Value<String>? level,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      question: question ?? this.question,
      optionsJson: optionsJson ?? this.optionsJson,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      topic: topic ?? this.topic,
      level: level ?? this.level,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<int>(correctAnswer.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('question: $question, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('topic: $topic, ')
          ..write('level: $level, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseAttemptsTable extends ExerciseAttempts
    with TableInfo<$ExerciseAttemptsTable, ExerciseAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
      'topic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'));
  static const VerificationMeta _answeredAtMeta =
      const VerificationMeta('answeredAt');
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
      'answered_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, exerciseId, topic, level, isCorrect, answeredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<ExerciseAttempt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
          _topicMeta, topic.isAcceptableOrUnknown(data['topic']!, _topicMeta));
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
          _answeredAtMeta,
          answeredAt.isAcceptableOrUnknown(
              data['answered_at']!, _answeredAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseAttempt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      topic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
      answeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}answered_at'])!,
    );
  }

  @override
  $ExerciseAttemptsTable createAlias(String alias) {
    return $ExerciseAttemptsTable(attachedDatabase, alias);
  }
}

class ExerciseAttempt extends DataClass implements Insertable<ExerciseAttempt> {
  final int id;
  final String exerciseId;
  final String topic;
  final String level;
  final bool isCorrect;
  final DateTime answeredAt;
  const ExerciseAttempt(
      {required this.id,
      required this.exerciseId,
      required this.topic,
      required this.level,
      required this.isCorrect,
      required this.answeredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['topic'] = Variable<String>(topic);
    map['level'] = Variable<String>(level);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    return map;
  }

  ExerciseAttemptsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseAttemptsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      topic: Value(topic),
      level: Value(level),
      isCorrect: Value(isCorrect),
      answeredAt: Value(answeredAt),
    );
  }

  factory ExerciseAttempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseAttempt(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      topic: serializer.fromJson<String>(json['topic']),
      level: serializer.fromJson<String>(json['level']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'topic': serializer.toJson<String>(topic),
      'level': serializer.toJson<String>(level),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
    };
  }

  ExerciseAttempt copyWith(
          {int? id,
          String? exerciseId,
          String? topic,
          String? level,
          bool? isCorrect,
          DateTime? answeredAt}) =>
      ExerciseAttempt(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        topic: topic ?? this.topic,
        level: level ?? this.level,
        isCorrect: isCorrect ?? this.isCorrect,
        answeredAt: answeredAt ?? this.answeredAt,
      );
  ExerciseAttempt copyWithCompanion(ExerciseAttemptsCompanion data) {
    return ExerciseAttempt(
      id: data.id.present ? data.id.value : this.id,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      topic: data.topic.present ? data.topic.value : this.topic,
      level: data.level.present ? data.level.value : this.level,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      answeredAt:
          data.answeredAt.present ? data.answeredAt.value : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseAttempt(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('topic: $topic, ')
          ..write('level: $level, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, exerciseId, topic, level, isCorrect, answeredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseAttempt &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.topic == this.topic &&
          other.level == this.level &&
          other.isCorrect == this.isCorrect &&
          other.answeredAt == this.answeredAt);
}

class ExerciseAttemptsCompanion extends UpdateCompanion<ExerciseAttempt> {
  final Value<int> id;
  final Value<String> exerciseId;
  final Value<String> topic;
  final Value<String> level;
  final Value<bool> isCorrect;
  final Value<DateTime> answeredAt;
  const ExerciseAttemptsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.topic = const Value.absent(),
    this.level = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.answeredAt = const Value.absent(),
  });
  ExerciseAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseId,
    required String topic,
    required String level,
    required bool isCorrect,
    this.answeredAt = const Value.absent(),
  })  : exerciseId = Value(exerciseId),
        topic = Value(topic),
        level = Value(level),
        isCorrect = Value(isCorrect);
  static Insertable<ExerciseAttempt> custom({
    Expression<int>? id,
    Expression<String>? exerciseId,
    Expression<String>? topic,
    Expression<String>? level,
    Expression<bool>? isCorrect,
    Expression<DateTime>? answeredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (topic != null) 'topic': topic,
      if (level != null) 'level': level,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (answeredAt != null) 'answered_at': answeredAt,
    });
  }

  ExerciseAttemptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? exerciseId,
      Value<String>? topic,
      Value<String>? level,
      Value<bool>? isCorrect,
      Value<DateTime>? answeredAt}) {
    return ExerciseAttemptsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      topic: topic ?? this.topic,
      level: level ?? this.level,
      isCorrect: isCorrect ?? this.isCorrect,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('topic: $topic, ')
          ..write('level: $level, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedMeta =
      const VerificationMeta('unlocked');
  @override
  late final GeneratedColumn<bool> unlocked = GeneratedColumn<bool>(
      'unlocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("unlocked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, icon, unlocked, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(Insertable<Achievement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('unlocked')) {
      context.handle(_unlockedMeta,
          unlocked.isAcceptableOrUnknown(data['unlocked']!, _unlockedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      unlocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}unlocked'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool unlocked;
  final DateTime updatedAt;
  const Achievement(
      {required this.id,
      required this.title,
      required this.description,
      required this.icon,
      required this.unlocked,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['icon'] = Variable<String>(icon);
    map['unlocked'] = Variable<bool>(unlocked);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      icon: Value(icon),
      unlocked: Value(unlocked),
      updatedAt: Value(updatedAt),
    );
  }

  factory Achievement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      unlocked: serializer.fromJson<bool>(json['unlocked']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'icon': serializer.toJson<String>(icon),
      'unlocked': serializer.toJson<bool>(unlocked),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Achievement copyWith(
          {String? id,
          String? title,
          String? description,
          String? icon,
          bool? unlocked,
          DateTime? updatedAt}) =>
      Achievement(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        unlocked: unlocked ?? this.unlocked,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      unlocked: data.unlocked.present ? data.unlocked.value : this.unlocked,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('unlocked: $unlocked, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, icon, unlocked, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.unlocked == this.unlocked &&
          other.updatedAt == this.updatedAt);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> icon;
  final Value<bool> unlocked;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.unlocked = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String icon,
    this.unlocked = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        icon = Value(icon);
  static Insertable<Achievement> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<bool>? unlocked,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (unlocked != null) 'unlocked': unlocked,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? icon,
      Value<bool>? unlocked,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AchievementsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      unlocked: unlocked ?? this.unlocked,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (unlocked.present) {
      map['unlocked'] = Variable<bool>(unlocked.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('unlocked: $unlocked, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTable extends UserStats
    with TableInfo<$UserStatsTable, UserStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
      'xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wordsLearnedMeta =
      const VerificationMeta('wordsLearned');
  @override
  late final GeneratedColumn<int> wordsLearned = GeneratedColumn<int>(
      'words_learned', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _exercisesCompletedMeta =
      const VerificationMeta('exercisesCompleted');
  @override
  late final GeneratedColumn<int> exercisesCompleted = GeneratedColumn<int>(
      'exercises_completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _grammarTopicsCompletedMeta =
      const VerificationMeta('grammarTopicsCompleted');
  @override
  late final GeneratedColumn<int> grammarTopicsCompleted = GeneratedColumn<int>(
      'grammar_topics_completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _weeklyProgressMeta =
      const VerificationMeta('weeklyProgress');
  @override
  late final GeneratedColumn<int> weeklyProgress = GeneratedColumn<int>(
      'weekly_progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A1'));
  static const VerificationMeta _weakAreasJsonMeta =
      const VerificationMeta('weakAreasJson');
  @override
  late final GeneratedColumn<String> weakAreasJson = GeneratedColumn<String>(
      'weak_areas_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        xp,
        streak,
        wordsLearned,
        exercisesCompleted,
        grammarTopicsCompleted,
        weeklyProgress,
        level,
        weakAreasJson,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats';
  @override
  VerificationContext validateIntegrity(Insertable<UserStat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    }
    if (data.containsKey('words_learned')) {
      context.handle(
          _wordsLearnedMeta,
          wordsLearned.isAcceptableOrUnknown(
              data['words_learned']!, _wordsLearnedMeta));
    }
    if (data.containsKey('exercises_completed')) {
      context.handle(
          _exercisesCompletedMeta,
          exercisesCompleted.isAcceptableOrUnknown(
              data['exercises_completed']!, _exercisesCompletedMeta));
    }
    if (data.containsKey('grammar_topics_completed')) {
      context.handle(
          _grammarTopicsCompletedMeta,
          grammarTopicsCompleted.isAcceptableOrUnknown(
              data['grammar_topics_completed']!, _grammarTopicsCompletedMeta));
    }
    if (data.containsKey('weekly_progress')) {
      context.handle(
          _weeklyProgressMeta,
          weeklyProgress.isAcceptableOrUnknown(
              data['weekly_progress']!, _weeklyProgressMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('weak_areas_json')) {
      context.handle(
          _weakAreasJsonMeta,
          weakAreasJson.isAcceptableOrUnknown(
              data['weak_areas_json']!, _weakAreasJsonMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      xp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      wordsLearned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}words_learned'])!,
      exercisesCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}exercises_completed'])!,
      grammarTopicsCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}grammar_topics_completed'])!,
      weeklyProgress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekly_progress'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      weakAreasJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}weak_areas_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserStatsTable createAlias(String alias) {
    return $UserStatsTable(attachedDatabase, alias);
  }
}

class UserStat extends DataClass implements Insertable<UserStat> {
  final int id;
  final int xp;
  final int streak;
  final int wordsLearned;
  final int exercisesCompleted;
  final int grammarTopicsCompleted;
  final int weeklyProgress;
  final String level;
  final String weakAreasJson;
  final DateTime updatedAt;
  const UserStat(
      {required this.id,
      required this.xp,
      required this.streak,
      required this.wordsLearned,
      required this.exercisesCompleted,
      required this.grammarTopicsCompleted,
      required this.weeklyProgress,
      required this.level,
      required this.weakAreasJson,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['xp'] = Variable<int>(xp);
    map['streak'] = Variable<int>(streak);
    map['words_learned'] = Variable<int>(wordsLearned);
    map['exercises_completed'] = Variable<int>(exercisesCompleted);
    map['grammar_topics_completed'] = Variable<int>(grammarTopicsCompleted);
    map['weekly_progress'] = Variable<int>(weeklyProgress);
    map['level'] = Variable<String>(level);
    map['weak_areas_json'] = Variable<String>(weakAreasJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserStatsCompanion toCompanion(bool nullToAbsent) {
    return UserStatsCompanion(
      id: Value(id),
      xp: Value(xp),
      streak: Value(streak),
      wordsLearned: Value(wordsLearned),
      exercisesCompleted: Value(exercisesCompleted),
      grammarTopicsCompleted: Value(grammarTopicsCompleted),
      weeklyProgress: Value(weeklyProgress),
      level: Value(level),
      weakAreasJson: Value(weakAreasJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserStat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStat(
      id: serializer.fromJson<int>(json['id']),
      xp: serializer.fromJson<int>(json['xp']),
      streak: serializer.fromJson<int>(json['streak']),
      wordsLearned: serializer.fromJson<int>(json['wordsLearned']),
      exercisesCompleted: serializer.fromJson<int>(json['exercisesCompleted']),
      grammarTopicsCompleted:
          serializer.fromJson<int>(json['grammarTopicsCompleted']),
      weeklyProgress: serializer.fromJson<int>(json['weeklyProgress']),
      level: serializer.fromJson<String>(json['level']),
      weakAreasJson: serializer.fromJson<String>(json['weakAreasJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'xp': serializer.toJson<int>(xp),
      'streak': serializer.toJson<int>(streak),
      'wordsLearned': serializer.toJson<int>(wordsLearned),
      'exercisesCompleted': serializer.toJson<int>(exercisesCompleted),
      'grammarTopicsCompleted': serializer.toJson<int>(grammarTopicsCompleted),
      'weeklyProgress': serializer.toJson<int>(weeklyProgress),
      'level': serializer.toJson<String>(level),
      'weakAreasJson': serializer.toJson<String>(weakAreasJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserStat copyWith(
          {int? id,
          int? xp,
          int? streak,
          int? wordsLearned,
          int? exercisesCompleted,
          int? grammarTopicsCompleted,
          int? weeklyProgress,
          String? level,
          String? weakAreasJson,
          DateTime? updatedAt}) =>
      UserStat(
        id: id ?? this.id,
        xp: xp ?? this.xp,
        streak: streak ?? this.streak,
        wordsLearned: wordsLearned ?? this.wordsLearned,
        exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
        grammarTopicsCompleted:
            grammarTopicsCompleted ?? this.grammarTopicsCompleted,
        weeklyProgress: weeklyProgress ?? this.weeklyProgress,
        level: level ?? this.level,
        weakAreasJson: weakAreasJson ?? this.weakAreasJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserStat copyWithCompanion(UserStatsCompanion data) {
    return UserStat(
      id: data.id.present ? data.id.value : this.id,
      xp: data.xp.present ? data.xp.value : this.xp,
      streak: data.streak.present ? data.streak.value : this.streak,
      wordsLearned: data.wordsLearned.present
          ? data.wordsLearned.value
          : this.wordsLearned,
      exercisesCompleted: data.exercisesCompleted.present
          ? data.exercisesCompleted.value
          : this.exercisesCompleted,
      grammarTopicsCompleted: data.grammarTopicsCompleted.present
          ? data.grammarTopicsCompleted.value
          : this.grammarTopicsCompleted,
      weeklyProgress: data.weeklyProgress.present
          ? data.weeklyProgress.value
          : this.weeklyProgress,
      level: data.level.present ? data.level.value : this.level,
      weakAreasJson: data.weakAreasJson.present
          ? data.weakAreasJson.value
          : this.weakAreasJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStat(')
          ..write('id: $id, ')
          ..write('xp: $xp, ')
          ..write('streak: $streak, ')
          ..write('wordsLearned: $wordsLearned, ')
          ..write('exercisesCompleted: $exercisesCompleted, ')
          ..write('grammarTopicsCompleted: $grammarTopicsCompleted, ')
          ..write('weeklyProgress: $weeklyProgress, ')
          ..write('level: $level, ')
          ..write('weakAreasJson: $weakAreasJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      xp,
      streak,
      wordsLearned,
      exercisesCompleted,
      grammarTopicsCompleted,
      weeklyProgress,
      level,
      weakAreasJson,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStat &&
          other.id == this.id &&
          other.xp == this.xp &&
          other.streak == this.streak &&
          other.wordsLearned == this.wordsLearned &&
          other.exercisesCompleted == this.exercisesCompleted &&
          other.grammarTopicsCompleted == this.grammarTopicsCompleted &&
          other.weeklyProgress == this.weeklyProgress &&
          other.level == this.level &&
          other.weakAreasJson == this.weakAreasJson &&
          other.updatedAt == this.updatedAt);
}

class UserStatsCompanion extends UpdateCompanion<UserStat> {
  final Value<int> id;
  final Value<int> xp;
  final Value<int> streak;
  final Value<int> wordsLearned;
  final Value<int> exercisesCompleted;
  final Value<int> grammarTopicsCompleted;
  final Value<int> weeklyProgress;
  final Value<String> level;
  final Value<String> weakAreasJson;
  final Value<DateTime> updatedAt;
  const UserStatsCompanion({
    this.id = const Value.absent(),
    this.xp = const Value.absent(),
    this.streak = const Value.absent(),
    this.wordsLearned = const Value.absent(),
    this.exercisesCompleted = const Value.absent(),
    this.grammarTopicsCompleted = const Value.absent(),
    this.weeklyProgress = const Value.absent(),
    this.level = const Value.absent(),
    this.weakAreasJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserStatsCompanion.insert({
    this.id = const Value.absent(),
    this.xp = const Value.absent(),
    this.streak = const Value.absent(),
    this.wordsLearned = const Value.absent(),
    this.exercisesCompleted = const Value.absent(),
    this.grammarTopicsCompleted = const Value.absent(),
    this.weeklyProgress = const Value.absent(),
    this.level = const Value.absent(),
    this.weakAreasJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserStat> custom({
    Expression<int>? id,
    Expression<int>? xp,
    Expression<int>? streak,
    Expression<int>? wordsLearned,
    Expression<int>? exercisesCompleted,
    Expression<int>? grammarTopicsCompleted,
    Expression<int>? weeklyProgress,
    Expression<String>? level,
    Expression<String>? weakAreasJson,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (xp != null) 'xp': xp,
      if (streak != null) 'streak': streak,
      if (wordsLearned != null) 'words_learned': wordsLearned,
      if (exercisesCompleted != null) 'exercises_completed': exercisesCompleted,
      if (grammarTopicsCompleted != null)
        'grammar_topics_completed': grammarTopicsCompleted,
      if (weeklyProgress != null) 'weekly_progress': weeklyProgress,
      if (level != null) 'level': level,
      if (weakAreasJson != null) 'weak_areas_json': weakAreasJson,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserStatsCompanion copyWith(
      {Value<int>? id,
      Value<int>? xp,
      Value<int>? streak,
      Value<int>? wordsLearned,
      Value<int>? exercisesCompleted,
      Value<int>? grammarTopicsCompleted,
      Value<int>? weeklyProgress,
      Value<String>? level,
      Value<String>? weakAreasJson,
      Value<DateTime>? updatedAt}) {
    return UserStatsCompanion(
      id: id ?? this.id,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      grammarTopicsCompleted:
          grammarTopicsCompleted ?? this.grammarTopicsCompleted,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      level: level ?? this.level,
      weakAreasJson: weakAreasJson ?? this.weakAreasJson,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (wordsLearned.present) {
      map['words_learned'] = Variable<int>(wordsLearned.value);
    }
    if (exercisesCompleted.present) {
      map['exercises_completed'] = Variable<int>(exercisesCompleted.value);
    }
    if (grammarTopicsCompleted.present) {
      map['grammar_topics_completed'] =
          Variable<int>(grammarTopicsCompleted.value);
    }
    if (weeklyProgress.present) {
      map['weekly_progress'] = Variable<int>(weeklyProgress.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (weakAreasJson.present) {
      map['weak_areas_json'] = Variable<String>(weakAreasJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsCompanion(')
          ..write('id: $id, ')
          ..write('xp: $xp, ')
          ..write('streak: $streak, ')
          ..write('wordsLearned: $wordsLearned, ')
          ..write('exercisesCompleted: $exercisesCompleted, ')
          ..write('grammarTopicsCompleted: $grammarTopicsCompleted, ')
          ..write('weeklyProgress: $weeklyProgress, ')
          ..write('level: $level, ')
          ..write('weakAreasJson: $weakAreasJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _darkModeMeta =
      const VerificationMeta('darkMode');
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
      'dark_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dark_mode" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _nativeLanguageMeta =
      const VerificationMeta('nativeLanguage');
  @override
  late final GeneratedColumn<String> nativeLanguage = GeneratedColumn<String>(
      'native_language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _displayLanguageMeta =
      const VerificationMeta('displayLanguage');
  @override
  late final GeneratedColumn<String> displayLanguage = GeneratedColumn<String>(
      'display_language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _hasSeenOnboardingMeta =
      const VerificationMeta('hasSeenOnboarding');
  @override
  late final GeneratedColumn<bool> hasSeenOnboarding = GeneratedColumn<bool>(
      'has_seen_onboarding', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_seen_onboarding" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        darkMode,
        nativeLanguage,
        displayLanguage,
        hasSeenOnboarding,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(Insertable<UserPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dark_mode')) {
      context.handle(_darkModeMeta,
          darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta));
    }
    if (data.containsKey('native_language')) {
      context.handle(
          _nativeLanguageMeta,
          nativeLanguage.isAcceptableOrUnknown(
              data['native_language']!, _nativeLanguageMeta));
    }
    if (data.containsKey('display_language')) {
      context.handle(
          _displayLanguageMeta,
          displayLanguage.isAcceptableOrUnknown(
              data['display_language']!, _displayLanguageMeta));
    }
    if (data.containsKey('has_seen_onboarding')) {
      context.handle(
          _hasSeenOnboardingMeta,
          hasSeenOnboarding.isAcceptableOrUnknown(
              data['has_seen_onboarding']!, _hasSeenOnboardingMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      darkMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dark_mode'])!,
      nativeLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}native_language'])!,
      displayLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}display_language'])!,
      hasSeenOnboarding: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_seen_onboarding'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  final int id;
  final bool darkMode;
  final String nativeLanguage;
  final String displayLanguage;
  final bool hasSeenOnboarding;
  final DateTime updatedAt;
  const UserPreference(
      {required this.id,
      required this.darkMode,
      required this.nativeLanguage,
      required this.displayLanguage,
      required this.hasSeenOnboarding,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dark_mode'] = Variable<bool>(darkMode);
    map['native_language'] = Variable<String>(nativeLanguage);
    map['display_language'] = Variable<String>(displayLanguage);
    map['has_seen_onboarding'] = Variable<bool>(hasSeenOnboarding);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      id: Value(id),
      darkMode: Value(darkMode),
      nativeLanguage: Value(nativeLanguage),
      displayLanguage: Value(displayLanguage),
      hasSeenOnboarding: Value(hasSeenOnboarding),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      id: serializer.fromJson<int>(json['id']),
      darkMode: serializer.fromJson<bool>(json['darkMode']),
      nativeLanguage: serializer.fromJson<String>(json['nativeLanguage']),
      displayLanguage: serializer.fromJson<String>(json['displayLanguage']),
      hasSeenOnboarding: serializer.fromJson<bool>(json['hasSeenOnboarding']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'darkMode': serializer.toJson<bool>(darkMode),
      'nativeLanguage': serializer.toJson<String>(nativeLanguage),
      'displayLanguage': serializer.toJson<String>(displayLanguage),
      'hasSeenOnboarding': serializer.toJson<bool>(hasSeenOnboarding),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreference copyWith(
          {int? id,
          bool? darkMode,
          String? nativeLanguage,
          String? displayLanguage,
          bool? hasSeenOnboarding,
          DateTime? updatedAt}) =>
      UserPreference(
        id: id ?? this.id,
        darkMode: darkMode ?? this.darkMode,
        nativeLanguage: nativeLanguage ?? this.nativeLanguage,
        displayLanguage: displayLanguage ?? this.displayLanguage,
        hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreference(
      id: data.id.present ? data.id.value : this.id,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
      nativeLanguage: data.nativeLanguage.present
          ? data.nativeLanguage.value
          : this.nativeLanguage,
      displayLanguage: data.displayLanguage.present
          ? data.displayLanguage.value
          : this.displayLanguage,
      hasSeenOnboarding: data.hasSeenOnboarding.present
          ? data.hasSeenOnboarding.value
          : this.hasSeenOnboarding,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('id: $id, ')
          ..write('darkMode: $darkMode, ')
          ..write('nativeLanguage: $nativeLanguage, ')
          ..write('displayLanguage: $displayLanguage, ')
          ..write('hasSeenOnboarding: $hasSeenOnboarding, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, darkMode, nativeLanguage, displayLanguage,
      hasSeenOnboarding, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.id == this.id &&
          other.darkMode == this.darkMode &&
          other.nativeLanguage == this.nativeLanguage &&
          other.displayLanguage == this.displayLanguage &&
          other.hasSeenOnboarding == this.hasSeenOnboarding &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<int> id;
  final Value<bool> darkMode;
  final Value<String> nativeLanguage;
  final Value<String> displayLanguage;
  final Value<bool> hasSeenOnboarding;
  final Value<DateTime> updatedAt;
  const UserPreferencesCompanion({
    this.id = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.nativeLanguage = const Value.absent(),
    this.displayLanguage = const Value.absent(),
    this.hasSeenOnboarding = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.nativeLanguage = const Value.absent(),
    this.displayLanguage = const Value.absent(),
    this.hasSeenOnboarding = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserPreference> custom({
    Expression<int>? id,
    Expression<bool>? darkMode,
    Expression<String>? nativeLanguage,
    Expression<String>? displayLanguage,
    Expression<bool>? hasSeenOnboarding,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (darkMode != null) 'dark_mode': darkMode,
      if (nativeLanguage != null) 'native_language': nativeLanguage,
      if (displayLanguage != null) 'display_language': displayLanguage,
      if (hasSeenOnboarding != null) 'has_seen_onboarding': hasSeenOnboarding,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserPreferencesCompanion copyWith(
      {Value<int>? id,
      Value<bool>? darkMode,
      Value<String>? nativeLanguage,
      Value<String>? displayLanguage,
      Value<bool>? hasSeenOnboarding,
      Value<DateTime>? updatedAt}) {
    return UserPreferencesCompanion(
      id: id ?? this.id,
      darkMode: darkMode ?? this.darkMode,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      displayLanguage: displayLanguage ?? this.displayLanguage,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    if (nativeLanguage.present) {
      map['native_language'] = Variable<String>(nativeLanguage.value);
    }
    if (displayLanguage.present) {
      map['display_language'] = Variable<String>(displayLanguage.value);
    }
    if (hasSeenOnboarding.present) {
      map['has_seen_onboarding'] = Variable<bool>(hasSeenOnboarding.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('darkMode: $darkMode, ')
          ..write('nativeLanguage: $nativeLanguage, ')
          ..write('displayLanguage: $displayLanguage, ')
          ..write('hasSeenOnboarding: $hasSeenOnboarding, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VocabularyWordsTable vocabularyWords =
      $VocabularyWordsTable(this);
  late final $VocabularyProgressTable vocabularyProgress =
      $VocabularyProgressTable(this);
  late final $GrammarTopicsTable grammarTopics = $GrammarTopicsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $ExerciseAttemptsTable exerciseAttempts =
      $ExerciseAttemptsTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $UserStatsTable userStats = $UserStatsTable(this);
  late final $UserPreferencesTable userPreferences =
      $UserPreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        vocabularyWords,
        vocabularyProgress,
        grammarTopics,
        exercises,
        exerciseAttempts,
        achievements,
        userStats,
        userPreferences
      ];
}

typedef $$VocabularyWordsTableCreateCompanionBuilder = VocabularyWordsCompanion
    Function({
  required String id,
  required String german,
  required String english,
  required String dari,
  required String category,
  required String tag,
  required String example,
  required String context,
  required String contextDari,
  required String difficulty,
  Value<bool> isFavorite,
  Value<bool> isDifficult,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$VocabularyWordsTableUpdateCompanionBuilder = VocabularyWordsCompanion
    Function({
  Value<String> id,
  Value<String> german,
  Value<String> english,
  Value<String> dari,
  Value<String> category,
  Value<String> tag,
  Value<String> example,
  Value<String> context,
  Value<String> contextDari,
  Value<String> difficulty,
  Value<bool> isFavorite,
  Value<bool> isDifficult,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$VocabularyWordsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyWordsTable> {
  $$VocabularyWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get german => $composableBuilder(
      column: $table.german, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get english => $composableBuilder(
      column: $table.english, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dari => $composableBuilder(
      column: $table.dari, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get example => $composableBuilder(
      column: $table.example, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contextDari => $composableBuilder(
      column: $table.contextDari, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDifficult => $composableBuilder(
      column: $table.isDifficult, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$VocabularyWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyWordsTable> {
  $$VocabularyWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get german => $composableBuilder(
      column: $table.german, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get english => $composableBuilder(
      column: $table.english, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dari => $composableBuilder(
      column: $table.dari, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get example => $composableBuilder(
      column: $table.example, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contextDari => $composableBuilder(
      column: $table.contextDari, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDifficult => $composableBuilder(
      column: $table.isDifficult, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$VocabularyWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyWordsTable> {
  $$VocabularyWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get german =>
      $composableBuilder(column: $table.german, builder: (column) => column);

  GeneratedColumn<String> get english =>
      $composableBuilder(column: $table.english, builder: (column) => column);

  GeneratedColumn<String> get dari =>
      $composableBuilder(column: $table.dari, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  GeneratedColumn<String> get example =>
      $composableBuilder(column: $table.example, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<String> get contextDari => $composableBuilder(
      column: $table.contextDari, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<bool> get isDifficult => $composableBuilder(
      column: $table.isDifficult, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VocabularyWordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabularyWordsTable,
    VocabularyWord,
    $$VocabularyWordsTableFilterComposer,
    $$VocabularyWordsTableOrderingComposer,
    $$VocabularyWordsTableAnnotationComposer,
    $$VocabularyWordsTableCreateCompanionBuilder,
    $$VocabularyWordsTableUpdateCompanionBuilder,
    (
      VocabularyWord,
      BaseReferences<_$AppDatabase, $VocabularyWordsTable, VocabularyWord>
    ),
    VocabularyWord,
    PrefetchHooks Function()> {
  $$VocabularyWordsTableTableManager(
      _$AppDatabase db, $VocabularyWordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> german = const Value.absent(),
            Value<String> english = const Value.absent(),
            Value<String> dari = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> tag = const Value.absent(),
            Value<String> example = const Value.absent(),
            Value<String> context = const Value.absent(),
            Value<String> contextDari = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isDifficult = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabularyWordsCompanion(
            id: id,
            german: german,
            english: english,
            dari: dari,
            category: category,
            tag: tag,
            example: example,
            context: context,
            contextDari: contextDari,
            difficulty: difficulty,
            isFavorite: isFavorite,
            isDifficult: isDifficult,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String german,
            required String english,
            required String dari,
            required String category,
            required String tag,
            required String example,
            required String context,
            required String contextDari,
            required String difficulty,
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isDifficult = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabularyWordsCompanion.insert(
            id: id,
            german: german,
            english: english,
            dari: dari,
            category: category,
            tag: tag,
            example: example,
            context: context,
            contextDari: contextDari,
            difficulty: difficulty,
            isFavorite: isFavorite,
            isDifficult: isDifficult,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VocabularyWordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabularyWordsTable,
    VocabularyWord,
    $$VocabularyWordsTableFilterComposer,
    $$VocabularyWordsTableOrderingComposer,
    $$VocabularyWordsTableAnnotationComposer,
    $$VocabularyWordsTableCreateCompanionBuilder,
    $$VocabularyWordsTableUpdateCompanionBuilder,
    (
      VocabularyWord,
      BaseReferences<_$AppDatabase, $VocabularyWordsTable, VocabularyWord>
    ),
    VocabularyWord,
    PrefetchHooks Function()>;
typedef $$VocabularyProgressTableCreateCompanionBuilder
    = VocabularyProgressCompanion Function({
  required String wordId,
  Value<int> leitnerBox,
  Value<String> status,
  Value<String?> lastResult,
  Value<int> reviewCount,
  Value<int> lapseCount,
  Value<DateTime?> lastReviewedAt,
  Value<DateTime?> nextReviewAt,
  Value<DateTime?> masteredAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$VocabularyProgressTableUpdateCompanionBuilder
    = VocabularyProgressCompanion Function({
  Value<String> wordId,
  Value<int> leitnerBox,
  Value<String> status,
  Value<String?> lastResult,
  Value<int> reviewCount,
  Value<int> lapseCount,
  Value<DateTime?> lastReviewedAt,
  Value<DateTime?> nextReviewAt,
  Value<DateTime?> masteredAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$VocabularyProgressTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyProgressTable> {
  $$VocabularyProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get leitnerBox => $composableBuilder(
      column: $table.leitnerBox, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lapseCount => $composableBuilder(
      column: $table.lapseCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get masteredAt => $composableBuilder(
      column: $table.masteredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$VocabularyProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyProgressTable> {
  $$VocabularyProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get leitnerBox => $composableBuilder(
      column: $table.leitnerBox, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lapseCount => $composableBuilder(
      column: $table.lapseCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get masteredAt => $composableBuilder(
      column: $table.masteredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$VocabularyProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyProgressTable> {
  $$VocabularyProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<int> get leitnerBox => $composableBuilder(
      column: $table.leitnerBox, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => column);

  GeneratedColumn<int> get lapseCount => $composableBuilder(
      column: $table.lapseCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => column);

  GeneratedColumn<DateTime> get masteredAt => $composableBuilder(
      column: $table.masteredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VocabularyProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabularyProgressTable,
    VocabularyProgressData,
    $$VocabularyProgressTableFilterComposer,
    $$VocabularyProgressTableOrderingComposer,
    $$VocabularyProgressTableAnnotationComposer,
    $$VocabularyProgressTableCreateCompanionBuilder,
    $$VocabularyProgressTableUpdateCompanionBuilder,
    (
      VocabularyProgressData,
      BaseReferences<_$AppDatabase, $VocabularyProgressTable,
          VocabularyProgressData>
    ),
    VocabularyProgressData,
    PrefetchHooks Function()> {
  $$VocabularyProgressTableTableManager(
      _$AppDatabase db, $VocabularyProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyProgressTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> wordId = const Value.absent(),
            Value<int> leitnerBox = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> lastResult = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> lapseCount = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<DateTime?> masteredAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabularyProgressCompanion(
            wordId: wordId,
            leitnerBox: leitnerBox,
            status: status,
            lastResult: lastResult,
            reviewCount: reviewCount,
            lapseCount: lapseCount,
            lastReviewedAt: lastReviewedAt,
            nextReviewAt: nextReviewAt,
            masteredAt: masteredAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String wordId,
            Value<int> leitnerBox = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> lastResult = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> lapseCount = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<DateTime?> masteredAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabularyProgressCompanion.insert(
            wordId: wordId,
            leitnerBox: leitnerBox,
            status: status,
            lastResult: lastResult,
            reviewCount: reviewCount,
            lapseCount: lapseCount,
            lastReviewedAt: lastReviewedAt,
            nextReviewAt: nextReviewAt,
            masteredAt: masteredAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VocabularyProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabularyProgressTable,
    VocabularyProgressData,
    $$VocabularyProgressTableFilterComposer,
    $$VocabularyProgressTableOrderingComposer,
    $$VocabularyProgressTableAnnotationComposer,
    $$VocabularyProgressTableCreateCompanionBuilder,
    $$VocabularyProgressTableUpdateCompanionBuilder,
    (
      VocabularyProgressData,
      BaseReferences<_$AppDatabase, $VocabularyProgressTable,
          VocabularyProgressData>
    ),
    VocabularyProgressData,
    PrefetchHooks Function()>;
typedef $$GrammarTopicsTableCreateCompanionBuilder = GrammarTopicsCompanion
    Function({
  required String id,
  required String title,
  required String level,
  required String category,
  required String icon,
  required String rule,
  required String explanation,
  required String examplesJson,
  Value<int> progress,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$GrammarTopicsTableUpdateCompanionBuilder = GrammarTopicsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> level,
  Value<String> category,
  Value<String> icon,
  Value<String> rule,
  Value<String> explanation,
  Value<String> examplesJson,
  Value<int> progress,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$GrammarTopicsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarTopicsTable> {
  $$GrammarTopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rule => $composableBuilder(
      column: $table.rule, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$GrammarTopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarTopicsTable> {
  $$GrammarTopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rule => $composableBuilder(
      column: $table.rule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$GrammarTopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarTopicsTable> {
  $$GrammarTopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get rule =>
      $composableBuilder(column: $table.rule, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GrammarTopicsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarTopicsTable,
    GrammarTopic,
    $$GrammarTopicsTableFilterComposer,
    $$GrammarTopicsTableOrderingComposer,
    $$GrammarTopicsTableAnnotationComposer,
    $$GrammarTopicsTableCreateCompanionBuilder,
    $$GrammarTopicsTableUpdateCompanionBuilder,
    (
      GrammarTopic,
      BaseReferences<_$AppDatabase, $GrammarTopicsTable, GrammarTopic>
    ),
    GrammarTopic,
    PrefetchHooks Function()> {
  $$GrammarTopicsTableTableManager(_$AppDatabase db, $GrammarTopicsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarTopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarTopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarTopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> rule = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<String> examplesJson = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GrammarTopicsCompanion(
            id: id,
            title: title,
            level: level,
            category: category,
            icon: icon,
            rule: rule,
            explanation: explanation,
            examplesJson: examplesJson,
            progress: progress,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String level,
            required String category,
            required String icon,
            required String rule,
            required String explanation,
            required String examplesJson,
            Value<int> progress = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GrammarTopicsCompanion.insert(
            id: id,
            title: title,
            level: level,
            category: category,
            icon: icon,
            rule: rule,
            explanation: explanation,
            examplesJson: examplesJson,
            progress: progress,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarTopicsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarTopicsTable,
    GrammarTopic,
    $$GrammarTopicsTableFilterComposer,
    $$GrammarTopicsTableOrderingComposer,
    $$GrammarTopicsTableAnnotationComposer,
    $$GrammarTopicsTableCreateCompanionBuilder,
    $$GrammarTopicsTableUpdateCompanionBuilder,
    (
      GrammarTopic,
      BaseReferences<_$AppDatabase, $GrammarTopicsTable, GrammarTopic>
    ),
    GrammarTopic,
    PrefetchHooks Function()>;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  required String id,
  required String type,
  required String question,
  required String optionsJson,
  required int correctAnswer,
  required String topic,
  required String level,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> question,
  Value<String> optionsJson,
  Value<int> correctAnswer,
  Value<String> topic,
  Value<String> level,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => column);

  GeneratedColumn<int> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
    Exercise,
    PrefetchHooks Function()> {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> optionsJson = const Value.absent(),
            Value<int> correctAnswer = const Value.absent(),
            Value<String> topic = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            type: type,
            question: question,
            optionsJson: optionsJson,
            correctAnswer: correctAnswer,
            topic: topic,
            level: level,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String question,
            required String optionsJson,
            required int correctAnswer,
            required String topic,
            required String level,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion.insert(
            id: id,
            type: type,
            question: question,
            optionsJson: optionsJson,
            correctAnswer: correctAnswer,
            topic: topic,
            level: level,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
    Exercise,
    PrefetchHooks Function()>;
typedef $$ExerciseAttemptsTableCreateCompanionBuilder
    = ExerciseAttemptsCompanion Function({
  Value<int> id,
  required String exerciseId,
  required String topic,
  required String level,
  required bool isCorrect,
  Value<DateTime> answeredAt,
});
typedef $$ExerciseAttemptsTableUpdateCompanionBuilder
    = ExerciseAttemptsCompanion Function({
  Value<int> id,
  Value<String> exerciseId,
  Value<String> topic,
  Value<String> level,
  Value<bool> isCorrect,
  Value<DateTime> answeredAt,
});

class $$ExerciseAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseAttemptsTable> {
  $$ExerciseAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnFilters(column));
}

class $$ExerciseAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseAttemptsTable> {
  $$ExerciseAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnOrderings(column));
}

class $$ExerciseAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseAttemptsTable> {
  $$ExerciseAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => column);
}

class $$ExerciseAttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseAttemptsTable,
    ExerciseAttempt,
    $$ExerciseAttemptsTableFilterComposer,
    $$ExerciseAttemptsTableOrderingComposer,
    $$ExerciseAttemptsTableAnnotationComposer,
    $$ExerciseAttemptsTableCreateCompanionBuilder,
    $$ExerciseAttemptsTableUpdateCompanionBuilder,
    (
      ExerciseAttempt,
      BaseReferences<_$AppDatabase, $ExerciseAttemptsTable, ExerciseAttempt>
    ),
    ExerciseAttempt,
    PrefetchHooks Function()> {
  $$ExerciseAttemptsTableTableManager(
      _$AppDatabase db, $ExerciseAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<String> topic = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<DateTime> answeredAt = const Value.absent(),
          }) =>
              ExerciseAttemptsCompanion(
            id: id,
            exerciseId: exerciseId,
            topic: topic,
            level: level,
            isCorrect: isCorrect,
            answeredAt: answeredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String exerciseId,
            required String topic,
            required String level,
            required bool isCorrect,
            Value<DateTime> answeredAt = const Value.absent(),
          }) =>
              ExerciseAttemptsCompanion.insert(
            id: id,
            exerciseId: exerciseId,
            topic: topic,
            level: level,
            isCorrect: isCorrect,
            answeredAt: answeredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExerciseAttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExerciseAttemptsTable,
    ExerciseAttempt,
    $$ExerciseAttemptsTableFilterComposer,
    $$ExerciseAttemptsTableOrderingComposer,
    $$ExerciseAttemptsTableAnnotationComposer,
    $$ExerciseAttemptsTableCreateCompanionBuilder,
    $$ExerciseAttemptsTableUpdateCompanionBuilder,
    (
      ExerciseAttempt,
      BaseReferences<_$AppDatabase, $ExerciseAttemptsTable, ExerciseAttempt>
    ),
    ExerciseAttempt,
    PrefetchHooks Function()>;
typedef $$AchievementsTableCreateCompanionBuilder = AchievementsCompanion
    Function({
  required String id,
  required String title,
  required String description,
  required String icon,
  Value<bool> unlocked,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$AchievementsTableUpdateCompanionBuilder = AchievementsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<String> icon,
  Value<bool> unlocked,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get unlocked => $composableBuilder(
      column: $table.unlocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get unlocked => $composableBuilder(
      column: $table.unlocked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get unlocked =>
      $composableBuilder(column: $table.unlocked, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementsTable,
    Achievement,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (
      Achievement,
      BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>
    ),
    Achievement,
    PrefetchHooks Function()> {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<bool> unlocked = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsCompanion(
            id: id,
            title: title,
            description: description,
            icon: icon,
            unlocked: unlocked,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String description,
            required String icon,
            Value<bool> unlocked = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsCompanion.insert(
            id: id,
            title: title,
            description: description,
            icon: icon,
            unlocked: unlocked,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementsTable,
    Achievement,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (
      Achievement,
      BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>
    ),
    Achievement,
    PrefetchHooks Function()>;
typedef $$UserStatsTableCreateCompanionBuilder = UserStatsCompanion Function({
  Value<int> id,
  Value<int> xp,
  Value<int> streak,
  Value<int> wordsLearned,
  Value<int> exercisesCompleted,
  Value<int> grammarTopicsCompleted,
  Value<int> weeklyProgress,
  Value<String> level,
  Value<String> weakAreasJson,
  Value<DateTime> updatedAt,
});
typedef $$UserStatsTableUpdateCompanionBuilder = UserStatsCompanion Function({
  Value<int> id,
  Value<int> xp,
  Value<int> streak,
  Value<int> wordsLearned,
  Value<int> exercisesCompleted,
  Value<int> grammarTopicsCompleted,
  Value<int> weeklyProgress,
  Value<String> level,
  Value<String> weakAreasJson,
  Value<DateTime> updatedAt,
});

class $$UserStatsTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordsLearned => $composableBuilder(
      column: $table.wordsLearned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exercisesCompleted => $composableBuilder(
      column: $table.exercisesCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grammarTopicsCompleted => $composableBuilder(
      column: $table.grammarTopicsCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weeklyProgress => $composableBuilder(
      column: $table.weeklyProgress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weakAreasJson => $composableBuilder(
      column: $table.weakAreasJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordsLearned => $composableBuilder(
      column: $table.wordsLearned,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exercisesCompleted => $composableBuilder(
      column: $table.exercisesCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grammarTopicsCompleted => $composableBuilder(
      column: $table.grammarTopicsCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeklyProgress => $composableBuilder(
      column: $table.weeklyProgress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weakAreasJson => $composableBuilder(
      column: $table.weakAreasJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<int> get wordsLearned => $composableBuilder(
      column: $table.wordsLearned, builder: (column) => column);

  GeneratedColumn<int> get exercisesCompleted => $composableBuilder(
      column: $table.exercisesCompleted, builder: (column) => column);

  GeneratedColumn<int> get grammarTopicsCompleted => $composableBuilder(
      column: $table.grammarTopicsCompleted, builder: (column) => column);

  GeneratedColumn<int> get weeklyProgress => $composableBuilder(
      column: $table.weeklyProgress, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get weakAreasJson => $composableBuilder(
      column: $table.weakAreasJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserStatsTable,
    UserStat,
    $$UserStatsTableFilterComposer,
    $$UserStatsTableOrderingComposer,
    $$UserStatsTableAnnotationComposer,
    $$UserStatsTableCreateCompanionBuilder,
    $$UserStatsTableUpdateCompanionBuilder,
    (UserStat, BaseReferences<_$AppDatabase, $UserStatsTable, UserStat>),
    UserStat,
    PrefetchHooks Function()> {
  $$UserStatsTableTableManager(_$AppDatabase db, $UserStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<int> wordsLearned = const Value.absent(),
            Value<int> exercisesCompleted = const Value.absent(),
            Value<int> grammarTopicsCompleted = const Value.absent(),
            Value<int> weeklyProgress = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> weakAreasJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserStatsCompanion(
            id: id,
            xp: xp,
            streak: streak,
            wordsLearned: wordsLearned,
            exercisesCompleted: exercisesCompleted,
            grammarTopicsCompleted: grammarTopicsCompleted,
            weeklyProgress: weeklyProgress,
            level: level,
            weakAreasJson: weakAreasJson,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<int> wordsLearned = const Value.absent(),
            Value<int> exercisesCompleted = const Value.absent(),
            Value<int> grammarTopicsCompleted = const Value.absent(),
            Value<int> weeklyProgress = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> weakAreasJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserStatsCompanion.insert(
            id: id,
            xp: xp,
            streak: streak,
            wordsLearned: wordsLearned,
            exercisesCompleted: exercisesCompleted,
            grammarTopicsCompleted: grammarTopicsCompleted,
            weeklyProgress: weeklyProgress,
            level: level,
            weakAreasJson: weakAreasJson,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserStatsTable,
    UserStat,
    $$UserStatsTableFilterComposer,
    $$UserStatsTableOrderingComposer,
    $$UserStatsTableAnnotationComposer,
    $$UserStatsTableCreateCompanionBuilder,
    $$UserStatsTableUpdateCompanionBuilder,
    (UserStat, BaseReferences<_$AppDatabase, $UserStatsTable, UserStat>),
    UserStat,
    PrefetchHooks Function()>;
typedef $$UserPreferencesTableCreateCompanionBuilder = UserPreferencesCompanion
    Function({
  Value<int> id,
  Value<bool> darkMode,
  Value<String> nativeLanguage,
  Value<String> displayLanguage,
  Value<bool> hasSeenOnboarding,
  Value<DateTime> updatedAt,
});
typedef $$UserPreferencesTableUpdateCompanionBuilder = UserPreferencesCompanion
    Function({
  Value<int> id,
  Value<bool> darkMode,
  Value<String> nativeLanguage,
  Value<String> displayLanguage,
  Value<bool> hasSeenOnboarding,
  Value<DateTime> updatedAt,
});

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get darkMode => $composableBuilder(
      column: $table.darkMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nativeLanguage => $composableBuilder(
      column: $table.nativeLanguage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayLanguage => $composableBuilder(
      column: $table.displayLanguage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasSeenOnboarding => $composableBuilder(
      column: $table.hasSeenOnboarding,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get darkMode => $composableBuilder(
      column: $table.darkMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nativeLanguage => $composableBuilder(
      column: $table.nativeLanguage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayLanguage => $composableBuilder(
      column: $table.displayLanguage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasSeenOnboarding => $composableBuilder(
      column: $table.hasSeenOnboarding,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);

  GeneratedColumn<String> get nativeLanguage => $composableBuilder(
      column: $table.nativeLanguage, builder: (column) => column);

  GeneratedColumn<String> get displayLanguage => $composableBuilder(
      column: $table.displayLanguage, builder: (column) => column);

  GeneratedColumn<bool> get hasSeenOnboarding => $composableBuilder(
      column: $table.hasSeenOnboarding, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPreferencesTable,
    UserPreference,
    $$UserPreferencesTableFilterComposer,
    $$UserPreferencesTableOrderingComposer,
    $$UserPreferencesTableAnnotationComposer,
    $$UserPreferencesTableCreateCompanionBuilder,
    $$UserPreferencesTableUpdateCompanionBuilder,
    (
      UserPreference,
      BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>
    ),
    UserPreference,
    PrefetchHooks Function()> {
  $$UserPreferencesTableTableManager(
      _$AppDatabase db, $UserPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> darkMode = const Value.absent(),
            Value<String> nativeLanguage = const Value.absent(),
            Value<String> displayLanguage = const Value.absent(),
            Value<bool> hasSeenOnboarding = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserPreferencesCompanion(
            id: id,
            darkMode: darkMode,
            nativeLanguage: nativeLanguage,
            displayLanguage: displayLanguage,
            hasSeenOnboarding: hasSeenOnboarding,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> darkMode = const Value.absent(),
            Value<String> nativeLanguage = const Value.absent(),
            Value<String> displayLanguage = const Value.absent(),
            Value<bool> hasSeenOnboarding = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserPreferencesCompanion.insert(
            id: id,
            darkMode: darkMode,
            nativeLanguage: nativeLanguage,
            displayLanguage: displayLanguage,
            hasSeenOnboarding: hasSeenOnboarding,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserPreferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserPreferencesTable,
    UserPreference,
    $$UserPreferencesTableFilterComposer,
    $$UserPreferencesTableOrderingComposer,
    $$UserPreferencesTableAnnotationComposer,
    $$UserPreferencesTableCreateCompanionBuilder,
    $$UserPreferencesTableUpdateCompanionBuilder,
    (
      UserPreference,
      BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>
    ),
    UserPreference,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VocabularyWordsTableTableManager get vocabularyWords =>
      $$VocabularyWordsTableTableManager(_db, _db.vocabularyWords);
  $$VocabularyProgressTableTableManager get vocabularyProgress =>
      $$VocabularyProgressTableTableManager(_db, _db.vocabularyProgress);
  $$GrammarTopicsTableTableManager get grammarTopics =>
      $$GrammarTopicsTableTableManager(_db, _db.grammarTopics);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$ExerciseAttemptsTableTableManager get exerciseAttempts =>
      $$ExerciseAttemptsTableTableManager(_db, _db.exerciseAttempts);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$UserStatsTableTableManager get userStats =>
      $$UserStatsTableTableManager(_db, _db.userStats);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
}
