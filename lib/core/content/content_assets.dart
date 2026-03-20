/// This class lists the paths to all the JSON content files in the app.
///
/// It organizes the files by level (A1, A2, etc.) and category.
class ContentAssets {
  /// This list contains all vocabulary files for level A1.
  static const List<String> vocabularyA1 = [
    'assets/content/vocabulary/A1/01_application_career.json',
    'assets/content/vocabulary/A1/02_company_structure.json',
    'assets/content/vocabulary/A1/03_contracts.json',
    'assets/content/vocabulary/A1/04_contracts_law.json',
    'assets/content/vocabulary/A1/05_education.json',
    'assets/content/vocabulary/A1/06_education_school.json',
    'assets/content/vocabulary/A1/07_email_correspondence.json',
    'assets/content/vocabulary/A1/08_everyday_german.json',
    'assets/content/vocabulary/A1/09_finance.json',
    'assets/content/vocabulary/A1/10_it_technology.json',
    'assets/content/vocabulary/A1/11_job_search_application.json',
    'assets/content/vocabulary/A1/12_marketing.json',
    'assets/content/vocabulary/A1/13_marketing_sales.json',
    'assets/content/vocabulary/A1/14_meetings.json',
    'assets/content/vocabulary/A1/15_meetings_presentations.json',
    'assets/content/vocabulary/A1/16_office_administration.json',
    'assets/content/vocabulary/A1/17_office_communication.json',
    'assets/content/vocabulary/A1/18_office_environment.json',
    'assets/content/vocabulary/A1/19_phone_communication.json',
    'assets/content/vocabulary/A1/20_professions.json',
    'assets/content/vocabulary/A1/21_recruiting.json',
    'assets/content/vocabulary/A1/22_training_internship.json',
    'assets/content/vocabulary/A1/23_visa_authorities.json',
    'assets/content/vocabulary/A1/24_work_tasks.json',
  ];

  /// This list contains all vocabulary files for level A2.
  static const List<String> vocabularyA2 = [
    'assets/content/vocabulary/A2/01_application_career.json',
    'assets/content/vocabulary/A2/02_finance.json',
    'assets/content/vocabulary/A2/03_it_technology.json',
    'assets/content/vocabulary/A2/04_marketing.json',
    'assets/content/vocabulary/A2/05_contracts.json',
    'assets/content/vocabulary/A2/06_meetings.json',
    'assets/content/vocabulary/A2/07_education.json',
    'assets/content/vocabulary/A2/08_office_communication.json',
    'assets/content/vocabulary/A2/09_company_structure.json',
    'assets/content/vocabulary/A2/10_professions.json',
    'assets/content/vocabulary/A2/11_recruiting.json',
    'assets/content/vocabulary/A2/12_office_environment.json',
    'assets/content/vocabulary/A2/13_work_tasks.json',
    'assets/content/vocabulary/A2/14_office_administration.json',
    'assets/content/vocabulary/A2/15_email_correspondence.json',
    'assets/content/vocabulary/A2/16_meetings_presentations.json',
    'assets/content/vocabulary/A2/17_everyday_german.json',
    'assets/content/vocabulary/A2/18_phone_communication.json',
    'assets/content/vocabulary/A2/19_contracts_law.json',
    'assets/content/vocabulary/A2/20_marketing_sales.json',
    'assets/content/vocabulary/A2/21_education_school.json',
    'assets/content/vocabulary/A2/22_visa_authorities.json',
    'assets/content/vocabulary/A2/23_training_internship.json',
    'assets/content/vocabulary/A2/24_job_search_application.json',
  ];

  /// This list contains all vocabulary files for level B1.
  static const List<String> vocabularyB1 = [
    'assets/content/vocabulary/B1/01_application_career.json',
    'assets/content/vocabulary/B1/02_finance.json',
    'assets/content/vocabulary/B1/03_it_technology.json',
    'assets/content/vocabulary/B1/04_contracts.json',
    'assets/content/vocabulary/B1/05_marketing.json',
    'assets/content/vocabulary/B1/06_company_structure.json',
    'assets/content/vocabulary/B1/07_professions.json',
    'assets/content/vocabulary/B1/08_recruiting.json',
    'assets/content/vocabulary/B1/09_office_administration.json',
    'assets/content/vocabulary/B1/10_email_correspondence.json',
    'assets/content/vocabulary/B1/11_meetings_presentations.json',
    'assets/content/vocabulary/B1/12_everyday_german.json',
    'assets/content/vocabulary/B1/13_phone_communication.json',
    'assets/content/vocabulary/B1/14_contracts_law.json',
    'assets/content/vocabulary/B1/15_marketing_sales.json',
    'assets/content/vocabulary/B1/16_education_school.json',
    'assets/content/vocabulary/B1/17_visa_authorities.json',
    'assets/content/vocabulary/B1/18_training_internship.json',
    'assets/content/vocabulary/B1/19_job_search_application.json',
  ];

  /// This list contains all vocabulary files for level B2.
  static const List<String> vocabularyB2 = [
    'assets/content/vocabulary/B2/01_negotiation_contracts.json',
    'assets/content/vocabulary/B2/02_project_management.json',
    'assets/content/vocabulary/B2/03_economy_markets.json',
    'assets/content/vocabulary/B2/04_office_communication_adv.json',
  ];

  /// This list contains all vocabulary files for level C1.
  static const List<String> vocabularyC1 = [
    'assets/content/vocabulary/C1/01_abstract_concepts.json',
    'assets/content/vocabulary/C1/02_academic_discourse.json',
    'assets/content/vocabulary/C1/03_leadership_culture.json',
  ];

  /// This list combines all vocabulary files from all levels.
  static const List<String> vocabulary = [
    ...vocabularyA1,
    ...vocabularyA2,
    ...vocabularyB1,
    ...vocabularyB2,
    ...vocabularyC1,
    'assets/content/vocabulary/misc.json',
  ];
}
