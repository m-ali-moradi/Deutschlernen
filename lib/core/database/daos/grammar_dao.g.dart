// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_dao.dart';

// ignore_for_file: type=lint
mixin _$GrammarDaoMixin on DatabaseAccessor<AppDatabase> {
  $GrammarTopicsTable get grammarTopics => attachedDatabase.grammarTopics;
  $GrammarDetailsTable get grammarDetails => attachedDatabase.grammarDetails;
  GrammarDaoManager get managers => GrammarDaoManager(this);
}

class GrammarDaoManager {
  final _$GrammarDaoMixin _db;
  GrammarDaoManager(this._db);
  $$GrammarTopicsTableTableManager get grammarTopics =>
      $$GrammarTopicsTableTableManager(_db.attachedDatabase, _db.grammarTopics);
  $$GrammarDetailsTableTableManager get grammarDetails =>
      $$GrammarDetailsTableTableManager(
          _db.attachedDatabase, _db.grammarDetails);
}
