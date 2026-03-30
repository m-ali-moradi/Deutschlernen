/// This class lists the paths to all the JSON content files in the app.
///
/// It organizes the files by level (A1, A2, etc.) and category.
class ContentAssets {
  /// This list contains all vocabulary files for level A1.
  static const List<String> vocabularyA1 = [
    'assets/content/vocabulary/A1/01_greetings.json',
    'assets/content/vocabulary/A1/02_numbers.json',
    'assets/content/vocabulary/A1/03_time.json',
    'assets/content/vocabulary/A1/04_days.json',
    'assets/content/vocabulary/A1/05_family.json',
    'assets/content/vocabulary/A1/06_home.json',
    'assets/content/vocabulary/A1/07_food.json',
    'assets/content/vocabulary/A1/08_shopping.json',
    'assets/content/vocabulary/A1/09_name_origin.json',
    'assets/content/vocabulary/A1/10_address_phone.json',
    'assets/content/vocabulary/A1/11_age_nationality.json',
    'assets/content/vocabulary/A1/12_documents.json',
    'assets/content/vocabulary/A1/13_train_bus.json',
    'assets/content/vocabulary/A1/14_airport.json',
    'assets/content/vocabulary/A1/15_ticket_booking.json',
    'assets/content/vocabulary/A1/16_hotel.json',
    'assets/content/vocabulary/A1/17_directions.json',
    'assets/content/vocabulary/A1/18_rooms.json',
    'assets/content/vocabulary/A1/19_furniture.json',
    'assets/content/vocabulary/A1/20_rent_cleaning.json',
    'assets/content/vocabulary/A1/21_repairs.json',
    'assets/content/vocabulary/A1/22_body_parts.json',
    'assets/content/vocabulary/A1/23_symptoms.json',
    'assets/content/vocabulary/A1/24_doctor_pharmacy.json',
    'assets/content/vocabulary/A1/25_emergency.json',
  ];

  /// This list contains all vocabulary files for level A2.
  static const List<String> vocabularyA2 = [
    'assets/content/vocabulary/A2/01_school_basics.json',
    'assets/content/vocabulary/A2/02_company.json',
    'assets/content/vocabulary/A2/03_office_tasks.json',
  ];

  /// This list contains all vocabulary files for level B1.
  static const List<String> vocabularyB1 = [
    'assets/content/vocabulary/B1/01_subjects.json',
    'assets/content/vocabulary/B1/02_exams_homework.json',
    'assets/content/vocabulary/B1/03_meetings.json',
    'assets/content/vocabulary/B1/04_contracts.json',
    'assets/content/vocabulary/B1/05_salary_projects.json',
    'assets/content/vocabulary/B1/06_application.json',
    'assets/content/vocabulary/B1/07_finance.json',
    'assets/content/vocabulary/B1/08_marketing.json',
    'assets/content/vocabulary/B1/09_hr.json',
  ];

  /// This list contains all vocabulary files for level B2.
  static const List<String> vocabularyB2 = [
    'assets/content/vocabulary/B2/01_university_study.json',
    'assets/content/vocabulary/B2/02_exams_academic.json',
  ];

  /// This list contains all vocabulary files for level C1.
  static const List<String> vocabularyC1 = [];

  /// This list combines all vocabulary files from all levels.
  static const List<String> vocabulary = [
    ...vocabularyA1,
    ...vocabularyA2,
    ...vocabularyB1,
    ...vocabularyB2,
    ...vocabularyC1,
    'assets/content/vocabulary/misc.json',
  ];

  static const String vocabularyGroups =
      'assets/content/vocabulary/groups.json';
  static const String vocabularyCategories =
      'assets/content/vocabulary/categories.json';
}
