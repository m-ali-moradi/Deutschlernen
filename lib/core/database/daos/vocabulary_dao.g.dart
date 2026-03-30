// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_dao.dart';

// ignore_for_file: type=lint
mixin _$VocabularyDaoMixin on DatabaseAccessor<AppDatabase> {
  $VocabularyWordsTable get vocabularyWords => attachedDatabase.vocabularyWords;
  $VocabularyProgressTable get vocabularyProgress =>
      attachedDatabase.vocabularyProgress;
  $VocabularyGroupsTable get vocabularyGroups =>
      attachedDatabase.vocabularyGroups;
  $VocabularyCategoriesTable get vocabularyCategories =>
      attachedDatabase.vocabularyCategories;
  $VocabularyPendingCategoriesTable get vocabularyPendingCategories =>
      attachedDatabase.vocabularyPendingCategories;
  VocabularyDaoManager get managers => VocabularyDaoManager(this);
}

class VocabularyDaoManager {
  final _$VocabularyDaoMixin _db;
  VocabularyDaoManager(this._db);
  $$VocabularyWordsTableTableManager get vocabularyWords =>
      $$VocabularyWordsTableTableManager(
          _db.attachedDatabase, _db.vocabularyWords);
  $$VocabularyProgressTableTableManager get vocabularyProgress =>
      $$VocabularyProgressTableTableManager(
          _db.attachedDatabase, _db.vocabularyProgress);
  $$VocabularyGroupsTableTableManager get vocabularyGroups =>
      $$VocabularyGroupsTableTableManager(
          _db.attachedDatabase, _db.vocabularyGroups);
  $$VocabularyCategoriesTableTableManager get vocabularyCategories =>
      $$VocabularyCategoriesTableTableManager(
          _db.attachedDatabase, _db.vocabularyCategories);
  $$VocabularyPendingCategoriesTableTableManager
      get vocabularyPendingCategories =>
          $$VocabularyPendingCategoriesTableTableManager(
              _db.attachedDatabase, _db.vocabularyPendingCategories);
}
