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
  static const VerificationMeta _phoneticMeta =
      const VerificationMeta('phonetic');
  @override
  late final GeneratedColumn<String> phonetic = GeneratedColumn<String>(
      'phonetic', aliasedName, false,
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
        phonetic,
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
    if (data.containsKey('phonetic')) {
      context.handle(_phoneticMeta,
          phonetic.isAcceptableOrUnknown(data['phonetic']!, _phoneticMeta));
    } else if (isInserting) {
      context.missing(_phoneticMeta);
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
      phonetic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phonetic'])!,
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
  final String phonetic;
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
      required this.phonetic,
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
    map['phonetic'] = Variable<String>(phonetic);
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
      phonetic: Value(phonetic),
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
      phonetic: serializer.fromJson<String>(json['phonetic']),
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
      'phonetic': serializer.toJson<String>(phonetic),
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
          String? phonetic,
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
        phonetic: phonetic ?? this.phonetic,
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
      phonetic: data.phonetic.present ? data.phonetic.value : this.phonetic,
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
          ..write('phonetic: $phonetic, ')
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
      phonetic,
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
          other.phonetic == this.phonetic &&
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
  final Value<String> phonetic;
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
    this.phonetic = const Value.absent(),
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
    required String phonetic,
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
        phonetic = Value(phonetic),
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
    Expression<String>? phonetic,
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
      if (phonetic != null) 'phonetic': phonetic,
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
      Value<String>? phonetic,
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
      phonetic: phonetic ?? this.phonetic,
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
    if (phonetic.present) {
      map['phonetic'] = Variable<String>(phonetic.value);
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
          ..write('phonetic: $phonetic, ')
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
      [id, darkMode, nativeLanguage, displayLanguage, updatedAt];
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
  final DateTime updatedAt;
  const UserPreference(
      {required this.id,
      required this.darkMode,
      required this.nativeLanguage,
      required this.displayLanguage,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dark_mode'] = Variable<bool>(darkMode);
    map['native_language'] = Variable<String>(nativeLanguage);
    map['display_language'] = Variable<String>(displayLanguage);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      id: Value(id),
      darkMode: Value(darkMode),
      nativeLanguage: Value(nativeLanguage),
      displayLanguage: Value(displayLanguage),
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
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreference copyWith(
          {int? id,
          bool? darkMode,
          String? nativeLanguage,
          String? displayLanguage,
          DateTime? updatedAt}) =>
      UserPreference(
        id: id ?? this.id,
        darkMode: darkMode ?? this.darkMode,
        nativeLanguage: nativeLanguage ?? this.nativeLanguage,
        displayLanguage: displayLanguage ?? this.displayLanguage,
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
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, darkMode, nativeLanguage, displayLanguage, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.id == this.id &&
          other.darkMode == this.darkMode &&
          other.nativeLanguage == this.nativeLanguage &&
          other.displayLanguage == this.displayLanguage &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<int> id;
  final Value<bool> darkMode;
  final Value<String> nativeLanguage;
  final Value<String> displayLanguage;
  final Value<DateTime> updatedAt;
  const UserPreferencesCompanion({
    this.id = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.nativeLanguage = const Value.absent(),
    this.displayLanguage = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.nativeLanguage = const Value.absent(),
    this.displayLanguage = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserPreference> custom({
    Expression<int>? id,
    Expression<bool>? darkMode,
    Expression<String>? nativeLanguage,
    Expression<String>? displayLanguage,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (darkMode != null) 'dark_mode': darkMode,
      if (nativeLanguage != null) 'native_language': nativeLanguage,
      if (displayLanguage != null) 'display_language': displayLanguage,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserPreferencesCompanion copyWith(
      {Value<int>? id,
      Value<bool>? darkMode,
      Value<String>? nativeLanguage,
      Value<String>? displayLanguage,
      Value<DateTime>? updatedAt}) {
    return UserPreferencesCompanion(
      id: id ?? this.id,
      darkMode: darkMode ?? this.darkMode,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      displayLanguage: displayLanguage ?? this.displayLanguage,
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
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ContentManifestTable extends ContentManifest
    with TableInfo<$ContentManifestTable, ContentManifestData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentManifestTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _contentVersionMeta =
      const VerificationMeta('contentVersion');
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
      'content_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _checksumMeta =
      const VerificationMeta('checksum');
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
      'checksum', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, contentVersion, checksum, lastSyncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_manifest';
  @override
  VerificationContext validateIntegrity(
      Insertable<ContentManifestData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content_version')) {
      context.handle(
          _contentVersionMeta,
          contentVersion.isAcceptableOrUnknown(
              data['content_version']!, _contentVersionMeta));
    }
    if (data.containsKey('checksum')) {
      context.handle(_checksumMeta,
          checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentManifestData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentManifestData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      contentVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}content_version'])!,
      checksum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checksum'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
    );
  }

  @override
  $ContentManifestTable createAlias(String alias) {
    return $ContentManifestTable(attachedDatabase, alias);
  }
}

class ContentManifestData extends DataClass
    implements Insertable<ContentManifestData> {
  final int id;
  final int contentVersion;
  final String checksum;
  final DateTime? lastSyncedAt;
  const ContentManifestData(
      {required this.id,
      required this.contentVersion,
      required this.checksum,
      this.lastSyncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content_version'] = Variable<int>(contentVersion);
    map['checksum'] = Variable<String>(checksum);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  ContentManifestCompanion toCompanion(bool nullToAbsent) {
    return ContentManifestCompanion(
      id: Value(id),
      contentVersion: Value(contentVersion),
      checksum: Value(checksum),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory ContentManifestData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentManifestData(
      id: serializer.fromJson<int>(json['id']),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
      checksum: serializer.fromJson<String>(json['checksum']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contentVersion': serializer.toJson<int>(contentVersion),
      'checksum': serializer.toJson<String>(checksum),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  ContentManifestData copyWith(
          {int? id,
          int? contentVersion,
          String? checksum,
          Value<DateTime?> lastSyncedAt = const Value.absent()}) =>
      ContentManifestData(
        id: id ?? this.id,
        contentVersion: contentVersion ?? this.contentVersion,
        checksum: checksum ?? this.checksum,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
      );
  ContentManifestData copyWithCompanion(ContentManifestCompanion data) {
    return ContentManifestData(
      id: data.id.present ? data.id.value : this.id,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentManifestData(')
          ..write('id: $id, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('checksum: $checksum, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, contentVersion, checksum, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentManifestData &&
          other.id == this.id &&
          other.contentVersion == this.contentVersion &&
          other.checksum == this.checksum &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class ContentManifestCompanion extends UpdateCompanion<ContentManifestData> {
  final Value<int> id;
  final Value<int> contentVersion;
  final Value<String> checksum;
  final Value<DateTime?> lastSyncedAt;
  const ContentManifestCompanion({
    this.id = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.checksum = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  ContentManifestCompanion.insert({
    this.id = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.checksum = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  static Insertable<ContentManifestData> custom({
    Expression<int>? id,
    Expression<int>? contentVersion,
    Expression<String>? checksum,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contentVersion != null) 'content_version': contentVersion,
      if (checksum != null) 'checksum': checksum,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  ContentManifestCompanion copyWith(
      {Value<int>? id,
      Value<int>? contentVersion,
      Value<String>? checksum,
      Value<DateTime?>? lastSyncedAt}) {
    return ContentManifestCompanion(
      id: id ?? this.id,
      contentVersion: contentVersion ?? this.contentVersion,
      checksum: checksum ?? this.checksum,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentManifestCompanion(')
          ..write('id: $id, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('checksum: $checksum, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $MutationQueueTable extends MutationQueue
    with TableInfo<$MutationQueueTable, MutationQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MutationQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        operation,
        entityType,
        entityId,
        payloadJson,
        idempotencyKey,
        createdAt,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mutation_queue';
  @override
  VerificationContext validateIntegrity(Insertable<MutationQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MutationQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MutationQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $MutationQueueTable createAlias(String alias) {
    return $MutationQueueTable(attachedDatabase, alias);
  }
}

class MutationQueueData extends DataClass
    implements Insertable<MutationQueueData> {
  final int id;
  final String operation;
  final String entityType;
  final String entityId;
  final String payloadJson;
  final String idempotencyKey;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const MutationQueueData(
      {required this.id,
      required this.operation,
      required this.entityType,
      required this.entityId,
      required this.payloadJson,
      required this.idempotencyKey,
      required this.createdAt,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation'] = Variable<String>(operation);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  MutationQueueCompanion toCompanion(bool nullToAbsent) {
    return MutationQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      entityType: Value(entityType),
      entityId: Value(entityId),
      payloadJson: Value(payloadJson),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory MutationQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MutationQueueData(
      id: serializer.fromJson<int>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(operation),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  MutationQueueData copyWith(
          {int? id,
          String? operation,
          String? entityType,
          String? entityId,
          String? payloadJson,
          String? idempotencyKey,
          DateTime? createdAt,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      MutationQueueData(
        id: id ?? this.id,
        operation: operation ?? this.operation,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        payloadJson: payloadJson ?? this.payloadJson,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        createdAt: createdAt ?? this.createdAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  MutationQueueData copyWithCompanion(MutationQueueCompanion data) {
    return MutationQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MutationQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, operation, entityType, entityId,
      payloadJson, idempotencyKey, createdAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MutationQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payloadJson == this.payloadJson &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class MutationQueueCompanion extends UpdateCompanion<MutationQueueData> {
  final Value<int> id;
  final Value<String> operation;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> payloadJson;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  const MutationQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  MutationQueueCompanion.insert({
    this.id = const Value.absent(),
    required String operation,
    required String entityType,
    required String entityId,
    required String payloadJson,
    required String idempotencyKey,
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  })  : operation = Value(operation),
        entityType = Value(entityType),
        entityId = Value(entityId),
        payloadJson = Value(payloadJson),
        idempotencyKey = Value(idempotencyKey);
  static Insertable<MutationQueueData> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payloadJson,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  MutationQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? operation,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? payloadJson,
      Value<String>? idempotencyKey,
      Value<DateTime>? createdAt,
      Value<DateTime?>? syncedAt}) {
    return MutationQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payloadJson: payloadJson ?? this.payloadJson,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MutationQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VocabularyWordsTable vocabularyWords =
      $VocabularyWordsTable(this);
  late final $GrammarTopicsTable grammarTopics = $GrammarTopicsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $UserStatsTable userStats = $UserStatsTable(this);
  late final $UserPreferencesTable userPreferences =
      $UserPreferencesTable(this);
  late final $ContentManifestTable contentManifest =
      $ContentManifestTable(this);
  late final $MutationQueueTable mutationQueue = $MutationQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        vocabularyWords,
        grammarTopics,
        exercises,
        achievements,
        userStats,
        userPreferences,
        contentManifest,
        mutationQueue
      ];
}

typedef $$VocabularyWordsTableCreateCompanionBuilder = VocabularyWordsCompanion
    Function({
  required String id,
  required String german,
  required String phonetic,
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
  Value<String> phonetic,
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

  ColumnFilters<String> get phonetic => $composableBuilder(
      column: $table.phonetic, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get phonetic => $composableBuilder(
      column: $table.phonetic, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get phonetic =>
      $composableBuilder(column: $table.phonetic, builder: (column) => column);

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
            Value<String> phonetic = const Value.absent(),
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
            phonetic: phonetic,
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
            required String phonetic,
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
            phonetic: phonetic,
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
  Value<DateTime> updatedAt,
});
typedef $$UserPreferencesTableUpdateCompanionBuilder = UserPreferencesCompanion
    Function({
  Value<int> id,
  Value<bool> darkMode,
  Value<String> nativeLanguage,
  Value<String> displayLanguage,
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
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserPreferencesCompanion(
            id: id,
            darkMode: darkMode,
            nativeLanguage: nativeLanguage,
            displayLanguage: displayLanguage,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> darkMode = const Value.absent(),
            Value<String> nativeLanguage = const Value.absent(),
            Value<String> displayLanguage = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserPreferencesCompanion.insert(
            id: id,
            darkMode: darkMode,
            nativeLanguage: nativeLanguage,
            displayLanguage: displayLanguage,
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
typedef $$ContentManifestTableCreateCompanionBuilder = ContentManifestCompanion
    Function({
  Value<int> id,
  Value<int> contentVersion,
  Value<String> checksum,
  Value<DateTime?> lastSyncedAt,
});
typedef $$ContentManifestTableUpdateCompanionBuilder = ContentManifestCompanion
    Function({
  Value<int> id,
  Value<int> contentVersion,
  Value<String> checksum,
  Value<DateTime?> lastSyncedAt,
});

class $$ContentManifestTableFilterComposer
    extends Composer<_$AppDatabase, $ContentManifestTable> {
  $$ContentManifestTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get contentVersion => $composableBuilder(
      column: $table.contentVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));
}

class $$ContentManifestTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentManifestTable> {
  $$ContentManifestTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get contentVersion => $composableBuilder(
      column: $table.contentVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ContentManifestTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentManifestTable> {
  $$ContentManifestTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get contentVersion => $composableBuilder(
      column: $table.contentVersion, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);
}

class $$ContentManifestTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContentManifestTable,
    ContentManifestData,
    $$ContentManifestTableFilterComposer,
    $$ContentManifestTableOrderingComposer,
    $$ContentManifestTableAnnotationComposer,
    $$ContentManifestTableCreateCompanionBuilder,
    $$ContentManifestTableUpdateCompanionBuilder,
    (
      ContentManifestData,
      BaseReferences<_$AppDatabase, $ContentManifestTable, ContentManifestData>
    ),
    ContentManifestData,
    PrefetchHooks Function()> {
  $$ContentManifestTableTableManager(
      _$AppDatabase db, $ContentManifestTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentManifestTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentManifestTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentManifestTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> contentVersion = const Value.absent(),
            Value<String> checksum = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
          }) =>
              ContentManifestCompanion(
            id: id,
            contentVersion: contentVersion,
            checksum: checksum,
            lastSyncedAt: lastSyncedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> contentVersion = const Value.absent(),
            Value<String> checksum = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
          }) =>
              ContentManifestCompanion.insert(
            id: id,
            contentVersion: contentVersion,
            checksum: checksum,
            lastSyncedAt: lastSyncedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContentManifestTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContentManifestTable,
    ContentManifestData,
    $$ContentManifestTableFilterComposer,
    $$ContentManifestTableOrderingComposer,
    $$ContentManifestTableAnnotationComposer,
    $$ContentManifestTableCreateCompanionBuilder,
    $$ContentManifestTableUpdateCompanionBuilder,
    (
      ContentManifestData,
      BaseReferences<_$AppDatabase, $ContentManifestTable, ContentManifestData>
    ),
    ContentManifestData,
    PrefetchHooks Function()>;
typedef $$MutationQueueTableCreateCompanionBuilder = MutationQueueCompanion
    Function({
  Value<int> id,
  required String operation,
  required String entityType,
  required String entityId,
  required String payloadJson,
  required String idempotencyKey,
  Value<DateTime> createdAt,
  Value<DateTime?> syncedAt,
});
typedef $$MutationQueueTableUpdateCompanionBuilder = MutationQueueCompanion
    Function({
  Value<int> id,
  Value<String> operation,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> payloadJson,
  Value<String> idempotencyKey,
  Value<DateTime> createdAt,
  Value<DateTime?> syncedAt,
});

class $$MutationQueueTableFilterComposer
    extends Composer<_$AppDatabase, $MutationQueueTable> {
  $$MutationQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$MutationQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $MutationQueueTable> {
  $$MutationQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$MutationQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $MutationQueueTable> {
  $$MutationQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$MutationQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MutationQueueTable,
    MutationQueueData,
    $$MutationQueueTableFilterComposer,
    $$MutationQueueTableOrderingComposer,
    $$MutationQueueTableAnnotationComposer,
    $$MutationQueueTableCreateCompanionBuilder,
    $$MutationQueueTableUpdateCompanionBuilder,
    (
      MutationQueueData,
      BaseReferences<_$AppDatabase, $MutationQueueTable, MutationQueueData>
    ),
    MutationQueueData,
    PrefetchHooks Function()> {
  $$MutationQueueTableTableManager(_$AppDatabase db, $MutationQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MutationQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MutationQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MutationQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              MutationQueueCompanion(
            id: id,
            operation: operation,
            entityType: entityType,
            entityId: entityId,
            payloadJson: payloadJson,
            idempotencyKey: idempotencyKey,
            createdAt: createdAt,
            syncedAt: syncedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String operation,
            required String entityType,
            required String entityId,
            required String payloadJson,
            required String idempotencyKey,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              MutationQueueCompanion.insert(
            id: id,
            operation: operation,
            entityType: entityType,
            entityId: entityId,
            payloadJson: payloadJson,
            idempotencyKey: idempotencyKey,
            createdAt: createdAt,
            syncedAt: syncedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MutationQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MutationQueueTable,
    MutationQueueData,
    $$MutationQueueTableFilterComposer,
    $$MutationQueueTableOrderingComposer,
    $$MutationQueueTableAnnotationComposer,
    $$MutationQueueTableCreateCompanionBuilder,
    $$MutationQueueTableUpdateCompanionBuilder,
    (
      MutationQueueData,
      BaseReferences<_$AppDatabase, $MutationQueueTable, MutationQueueData>
    ),
    MutationQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VocabularyWordsTableTableManager get vocabularyWords =>
      $$VocabularyWordsTableTableManager(_db, _db.vocabularyWords);
  $$GrammarTopicsTableTableManager get grammarTopics =>
      $$GrammarTopicsTableTableManager(_db, _db.grammarTopics);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$UserStatsTableTableManager get userStats =>
      $$UserStatsTableTableManager(_db, _db.userStats);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$ContentManifestTableTableManager get contentManifest =>
      $$ContentManifestTableTableManager(_db, _db.contentManifest);
  $$MutationQueueTableTableManager get mutationQueue =>
      $$MutationQueueTableTableManager(_db, _db.mutationQueue);
}
