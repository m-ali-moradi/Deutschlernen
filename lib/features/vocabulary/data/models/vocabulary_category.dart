import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';

/// Represents a single vocabulary category with its display properties and metadata.
///
/// This class holds the static configuration for a category, such as its name,
/// icon, and color gradient. It is used to display categories in the UI,
/// such as in the grid view or on cards.
class VocabularyCategory {
  final String id;
  final String name;
  final String displayName;
  final String icon;
  final List<Color> gradient;
  final String group;
  final String groupDisplayName;

  const VocabularyCategory({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.gradient,
    required this.group,
    required this.groupDisplayName,
  });

  /// Creates a [VocabularyCategory] from a [VocabularyCategoryEntity].
  ///
  /// This factory method parses the gradient colors from the entity's
  /// [gradientColorsJson] field and creates a [VocabularyCategory] instance.
  ///
  /// [data]: The vocabulary category entity to convert.
  /// [groupName]: The name of the group this category belongs to.
  /// [strings]: The UI text provider for localization.
  ///
  /// Returns a [VocabularyCategory] instance with the parsed data.
  factory VocabularyCategory.fromData(
    VocabularyCategoryEntity data,
    String groupName,
    AppUiText strings,
  ) {
    try {
      final List<dynamic> colorHexes = jsonDecode(data.gradientColorsJson);
      final List<Color> colors = colorHexes.map((hex) {
        // Handle both 0xFFRRGGBB and #RRGGBB formats if necessary,
        // but our JSON uses 0xFFRRGGBB style integers as strings
        return Color(int.parse(hex));
      }).toList();

      return VocabularyCategory(
        id: data.id,
        name: data.name,
        displayName: strings.vocabularyCategory(data.name),
        icon: data.icon,
        gradient: colors,
        group: groupName,
        groupDisplayName: strings.vocabularyGroup(groupName),
      );
    } catch (e) {
      // Fallback for malformed data
      return VocabularyCategory(
        id: data.id,
        name: data.name,
        displayName: strings.vocabularyCategory(data.name),
        icon: data.icon,
        gradient: const [Colors.blue, Colors.blueAccent],
        group: groupName,
        groupDisplayName: strings.vocabularyGroup(groupName),
      );
    }
  }
}

/// Gets the display label for a vocabulary category.
///
/// [strings]: The UI text provider for localization.
/// [category]: The category name.
///
/// Returns the display label for the category.
String getCategoryLabel(AppUiText strings, String category) {
  return strings.vocabularyCategory(category);
}

/// Category icons
///
/// Returns an IconData representing the category.
IconData getVocabularyCategoryIcon(String idOrName) {
  switch (idOrName) {
    // Personal Information
    case 'name_origin':
      return Icons.badge_rounded;
    case 'address_phone':
      return Icons.contact_phone_rounded;
    case 'documents':
      return Icons.description_rounded;
    case 'date_of_birth':
      return Icons.cake_rounded;
    case 'marital_status':
      return Icons.favorite_rounded;
    case 'age_nationality':
      return Icons.public_rounded;
    case 'languages':
      return Icons.translate_rounded;
    case 'alphabet_spelling':
      return Icons.spellcheck_rounded;

    // Authorities & Visa
    case 'registration_anmeldung':
      return Icons.how_to_reg_rounded;
    case 'residence_permit_visa':
      return Icons.card_membership_rounded;
    case 'appointments_authorities':
    case 'appointments_health':
      return Icons.event_available_rounded;
    case 'forms_documents_authorities':
      return Icons.assignment_rounded;
    case 'offices_authorities':
      return Icons.account_balance_rounded;
    case 'tax_id_numbers':
      return Icons.pin_rounded;
    case 'insurance_authorities':
      return Icons.health_and_safety_rounded;
    case 'legal_procedures':
      return Icons.gavel_rounded;

    // Work & Business
    case 'application':
      return Icons.work_rounded;
    case 'office_tasks':
      return Icons.assignment_ind_rounded;
    case 'company':
      return Icons.business_rounded;
    case 'meetings':
      return Icons.groups_rounded;
    case 'email_communication':
      return Icons.alternate_email_rounded;
    case 'salary_projects':
      return Icons.payments_rounded;
    case 'contracts':
      return Icons.history_edu_rounded;
    case 'work_schedule_shifts':
      return Icons.schedule_rounded;
    case 'finance':
      return Icons.account_balance_wallet_rounded;
    case 'marketing':
      return Icons.campaign_rounded;
    case 'hr':
      return Icons.hail_rounded;

    // Travel & Transport
    case 'train_bus':
      return Icons.directions_bus_rounded;
    case 'ticket_booking':
      return Icons.confirmation_number_rounded;
    case 'directions':
      return Icons.explore_rounded;
    case 'delays_problems':
      return Icons.report_problem_rounded;
    case 'airport':
      return Icons.flight_rounded;
    case 'hotel':
      return Icons.hotel_rounded;
    case 'luggage':
      return Icons.luggage_rounded;

    // Home & Housing
    case 'apartment_search':
      return Icons.search_rounded;
    case 'rent_contract':
      return Icons.draw_rounded;
    case 'rooms':
      return Icons.meeting_room_rounded;
    case 'utilities':
      return Icons.bolt_rounded;
    case 'furniture':
      return Icons.chair_rounded;
    case 'cleaning':
      return Icons.cleaning_services_rounded;
    case 'repairs':
      return Icons.handyman_rounded;
    case 'landlord_tenant':
      return Icons.vpn_key_rounded;

    // Health & Body
    case 'symptoms':
      return Icons.coronavirus_rounded;
    case 'doctor_visit':
      return Icons.medical_services_rounded;
    case 'emergency':
      return Icons.emergency_rounded;
    case 'medicine':
      return Icons.medication_rounded;
    case 'pharmacy':
      return Icons.local_pharmacy_rounded;
    case 'insurance_health':
      return Icons.health_and_safety_rounded;
    case 'body_parts':
      return Icons.accessibility_new_rounded;

    // Education
    case 'university':
      return Icons.school_rounded;
    case 'exams_homework':
      return Icons.edit_note_rounded;
    case 'registration_enrollment':
      return Icons.receipt_long_rounded;
    case 'courses_modules':
      return Icons.auto_stories_rounded;
    case 'deadlines':
      return Icons.hourglass_bottom_rounded;
    case 'school':
      return Icons.home_work_rounded;
    case 'subjects':
      return Icons.book_rounded;

    // Daily Life Basics
    case 'greetings':
      return Icons.waving_hand_rounded;
    case 'numbers':
      return Icons.numbers_rounded;
    case 'time_calendar':
      return Icons.calendar_month_rounded;
    case 'food_drinks':
      return Icons.restaurant_rounded;
    case 'shopping_prices':
      return Icons.shopping_cart_rounded;
    case 'family':
      return Icons.family_restroom_rounded;
    case 'home_basics':
      return Icons.home_rounded;
    case 'daily_actions':
      return Icons.directions_walk_rounded;
    case 'common_objects':
      return Icons.category_rounded;
    case 'feelings_states':
      return Icons.sentiment_satisfied_alt_rounded;
    case 'weather_seasons':
      return Icons.wb_sunny_rounded;
    case 'hobbies_leisure':
      return Icons.sports_esports_rounded;
    case 'clothing_colors':
      return Icons.checkroom_rounded;
    case 'invitations_events':
      return Icons.celebration_rounded;

    // Technology & IT
    case 'software_app':
      return Icons.smartphone_rounded;
    case 'internet_data':
      return Icons.language_rounded;
    case 'accounts_login':
      return Icons.lock_rounded;
    case 'computer_hardware':
      return Icons.laptop_rounded;
    case 'security':
      return Icons.security_rounded;
    case 'files_storage':
      return Icons.folder_shared_rounded;
    case 'social_media':
      return Icons.share_rounded;
    case 'programming':
      return Icons.code_rounded;

    // Abstract & Formal Language
    case 'formal_phrases':
      return Icons.record_voice_over_rounded;
    case 'opinions_arguments':
      return Icons.lightbulb_rounded;
    case 'cause_result':
      return Icons.link_rounded;
    case 'comparison':
      return Icons.compare_arrows_rounded;
    case 'condition_hypothesis':
      return Icons.psychology_rounded;
    case 'linking_words':
      return Icons.auto_awesome_motion_rounded;

    // Phrases (Common for all groups)
    case 'important_phrases_personal':
      return Icons.assignment_ind_rounded;
    case 'important_phrases_authorities':
      return Icons.gavel_rounded;
    case 'important_phrases_work':
      return Icons.handshake_rounded;
    case 'important_phrases_travel':
      return Icons.travel_explore_rounded;
    case 'important_phrases_home':
      return Icons.home_repair_service_rounded;
    case 'important_phrases_health':
      return Icons.medical_information_rounded;
    case 'important_phrases_education':
      return Icons.cast_for_education_rounded;
    case 'important_phrases_daily':
      return Icons.forum_rounded;
    case 'important_phrases_technology':
      return Icons.smart_toy_rounded;
    case 'important_phrases_abstract':
      return Icons.auto_awesome_rounded;

    // Backward compatibility for names
    case 'Greetings':
    case 'Begrüßungen':
      return Icons.waving_hand_rounded;
    case 'School':
    case 'Schule':
      return Icons.home_work_rounded;
    case 'University':
    case 'Universität':
      return Icons.school_rounded;
    case 'Food & Drink':
    case 'Essen & Trinken':
      return Icons.restaurant_rounded;
    case 'Travel':
    case 'Reisen':
      return Icons.flight_takeoff_rounded;

    default:
      return Icons.category_rounded;
  }
}



