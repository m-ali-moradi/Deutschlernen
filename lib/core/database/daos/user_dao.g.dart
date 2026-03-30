// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dao.dart';

// ignore_for_file: type=lint
mixin _$UserDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserStatsTable get userStats => attachedDatabase.userStats;
  $UserPreferencesTable get userPreferences => attachedDatabase.userPreferences;
  $AchievementsTable get achievements => attachedDatabase.achievements;
  UserDaoManager get managers => UserDaoManager(this);
}

class UserDaoManager {
  final _$UserDaoMixin _db;
  UserDaoManager(this._db);
  $$UserStatsTableTableManager get userStats =>
      $$UserStatsTableTableManager(_db.attachedDatabase, _db.userStats);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(
          _db.attachedDatabase, _db.userPreferences);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db.attachedDatabase, _db.achievements);
}
