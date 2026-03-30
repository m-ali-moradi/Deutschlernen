import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [
  UserStats,
  UserPreferences,
  Achievements,
])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  /// Toggles the application's global appearance mode.
  Future<void> setDarkMode(bool value) {
    return (update(userPreferences)..where((t) => t.id.equals(1))).write(
      UserPreferencesCompanion(
        darkMode: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Toggles the background synchronization preference.
  Future<void> setAutoSync(bool value) {
    return (update(userPreferences)..where((t) => t.id.equals(1))).write(
      UserPreferencesCompanion(
        autoSync: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Updates the preference flag once the user completes the initial walkthrough.
  Future<void> markOnboardingAsSeen() async {
    await (update(userPreferences)..where((t) => t.id.equals(1)))
        .write(UserPreferencesCompanion(hasSeenOnboarding: const Value(true)));
  }

  /// Resets the user's weekly progress target if the ISO week has changed.
  Future<void> syncWeeklyProgressIfNewWeek() async {
    final stats = await (select(userStats)..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    if (stats != null) {
      final now = DateTime.now();
      final lastWeek = _getIsoWeek(stats.updatedAt);
      final currentWeek = _getIsoWeek(now);

      if (currentWeek != lastWeek) {
        await (update(userStats)..where((t) => t.id.equals(1))).write(
          const UserStatsCompanion(
            weeklyProgress: Value(0),
          ),
        );
      }
    }
  }

  /// Calculates the ISO-8601 week number for a given date.
  int _getIsoWeek(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      return _getIsoWeek(DateTime(date.year - 1, 12, 31));
    }
    if (woy > 52 && DateTime(date.year, 12, 31).weekday < 4) {
      return 1;
    }
    return date.year * 100 + woy;
  }
}

