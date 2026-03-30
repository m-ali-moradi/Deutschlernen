import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../../../../core/database/app_database.dart';

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
