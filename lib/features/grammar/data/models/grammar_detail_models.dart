import 'package:flutter/material.dart';

// ─── Model Types ──────────────────────────────────────────────────────────────

/// Represents a pair of German text and its corresponding translation.
/// Used extensively in examples and transform sections.
class ExPair {
  /// The German sentence or phrase.
  final String de;
  /// The translated sentence or phrase (English, Dari, etc.).
  final String translation;
  
  const ExPair(this.de, this.translation);
}

class TableRow2 {
  final String left;
  final String right;
  const TableRow2(this.left, this.right);
}

class ComparisonRow {
  final List<String> cells;
  const ComparisonRow(this.cells);
}

// ─── Section Base + Subclasses ────────────────────────────────────────────────

/// Base class for all grammar sections in the rich detail view.
/// Each section represents a different type of content (Concept, Examples, Rules, etc.).
abstract class GrammarSection {
  const GrammarSection();
}

/// This section explains a grammar concept with text and bullets.
class ConceptSection extends GrammarSection {
  final String title;
  final String text;
  final List<String>? bullets;
  const ConceptSection({required this.title, required this.text, this.bullets});

  factory ConceptSection.fromJson(Map<String, dynamic> json) {
    return ConceptSection(
      title: (json['title'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      bullets: (json['bullets'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

/// This section shows a formula or pattern.
class FormulaSection extends GrammarSection {
  final String label;
  final String formula;
  final List<Color> colors;
  const FormulaSection(
      {required this.label, required this.formula, required this.colors});

  factory FormulaSection.fromJson(Map<String, dynamic> json) {
    return FormulaSection(
      label: (json['label'] ?? '').toString(),
      formula: (json['formula'] ?? '').toString(),
      colors: (json['colors'] as List<dynamic>? ?? const <dynamic>[])
          .map((c) => _colorFromHex(c.toString()))
          .toList(),
    );
  }
}

/// This section shows a conjugation table.
class ConjugationSection extends GrammarSection {
  final String title;
  final List<TableRow2> rows;
  final SectionColor color;
  const ConjugationSection(
      {required this.title, required this.rows, required this.color});

  factory ConjugationSection.fromJson(Map<String, dynamic> json) {
    return ConjugationSection(
      title: (json['title'] ?? '').toString(),
      color: _sectionColorFromString((json['color'] ?? 'blue').toString()),
      rows: (json['rows'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map((row) => TableRow2(
              (row['left'] ?? '').toString(), (row['right'] ?? '').toString()))
          .toList(),
    );
  }
}

/// This section shows multiple example sentences.
class ExamplesSection extends GrammarSection {
  final String title;
  final List<ExPair> items;
  final SectionColor color;
  const ExamplesSection(
      {required this.title, required this.items, required this.color});

  factory ExamplesSection.fromJson(Map<String, dynamic> json) {
    return ExamplesSection(
      title: (json['title'] ?? '').toString(),
      color: _sectionColorFromString((json['color'] ?? 'blue').toString()),
      items: (json['items'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map((item) => ExPair(
              (item['de'] ?? '').toString(), 
              (item['translation'] ?? item['en'] ?? '').toString()))
          .toList(),
    );
  }
}

/// This section compares different grammar points in a table.
class ComparisonSection extends GrammarSection {
  final String title;
  final List<String> headers;
  final List<ComparisonRow> rows;
  const ComparisonSection(
      {required this.title, required this.headers, required this.rows});

  factory ComparisonSection.fromJson(Map<String, dynamic> json) {
    return ComparisonSection(
      title: (json['title'] ?? '').toString(),
      headers: (json['headers'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      rows: (json['rows'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<List<dynamic>>()
          .map((row) =>
              ComparisonRow(row.map((cell) => cell.toString()).toList()))
          .toList(),
    );
  }
}

/// This section lists important rules to follow.
class RulesSection extends GrammarSection {
  final String title;
  final List<String> items;
  const RulesSection({required this.title, required this.items});

  factory RulesSection.fromJson(Map<String, dynamic> json) {
    return RulesSection(
      title: (json['title'] ?? '').toString(),
      items: (json['items'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

enum TipVariant { info, warning, success }

/// This section shows a helpful tip or a warning.
class TipSection extends GrammarSection {
  final String text;
  final TipVariant variant;
  const TipSection({required this.text, this.variant = TipVariant.info});

  factory TipSection.fromJson(Map<String, dynamic> json) {
    final variantRaw = (json['variant'] ?? 'info').toString();
    final variant = TipVariant.values.firstWhere(
      (v) => v.name == variantRaw,
      orElse: () => TipVariant.info,
    );
    return TipSection(text: (json['text'] ?? '').toString(), variant: variant);
  }
}

class FromToLabel {
  final String label;
  final String text;
  const FromToLabel({required this.label, required this.text});
}

/// This section shows how to transform a sentence.
class TransformSection extends GrammarSection {
  final String title;
  final FromToLabel from;
  final FromToLabel to;
  final String? note;
  const TransformSection(
      {required this.title, required this.from, required this.to, this.note});

  factory TransformSection.fromJson(Map<String, dynamic> json) {
    final fromJson =
        (json['from'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    final toJson =
        (json['to'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    return TransformSection(
      title: (json['title'] ?? '').toString(),
      from: FromToLabel(
        label: (fromJson['label'] ?? '').toString(),
        text: (fromJson['text'] ?? '').toString(),
      ),
      to: FromToLabel(
        label: (toJson['label'] ?? '').toString(),
        text: (toJson['text'] ?? '').toString(),
      ),
      note: json['note']?.toString(),
    );
  }
}

// ─── GrammarDetailData ────────────────────────────────────────────────────────

/// Root data model for a grammar topic's rich detail content.
/// It contains metadata for the header and a list of sections for the body.
class GrammarDetailData {
  /// Topic ID (e.g., 'articles_a1')
  final String id;
  /// Secondary title or description
  final String subtitle;
  /// Representative emoji for the topic
  final String emoji;
  final List<Color> gradient;
  final Color levelBg;
  final Color levelText;
  final List<GrammarSection> sections;

  const GrammarDetailData({
    required this.id,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    required this.levelBg,
    required this.levelText,
    required this.sections,
  });

  factory GrammarDetailData.fromJson(Map<String, dynamic> json) {
    return GrammarDetailData(
      id: (json['id'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      emoji: (json['emoji'] ?? '').toString(),
      gradient: (json['gradient'] as List<dynamic>? ?? const <dynamic>[])
          .map((c) => _colorFromHex(c.toString()))
          .toList(),
      levelBg: _colorFromHex((json['levelBg'] ?? '#000000').toString()),
      levelText: _colorFromHex((json['levelText'] ?? '#000000').toString()),
      sections: (json['sections'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(GrammarSectionJson.fromJson)
          .toList(),
    );
  }
}

class GrammarSectionJson {
  static GrammarSection fromJson(Map<String, dynamic> json) {
    final type = (json['type'] ?? '').toString();
    switch (type) {
      case 'concept':
        return ConceptSection.fromJson(json);
      case 'conjugation':
        return ConjugationSection.fromJson(json);
      case 'tip':
        return TipSection.fromJson(json);
      case 'comparison':
        return ComparisonSection.fromJson(json);
      case 'examples':
        return ExamplesSection.fromJson(json);
      case 'rules':
        return RulesSection.fromJson(json);
      case 'transform':
        return TransformSection.fromJson(json);
      case 'formula':
        return FormulaSection.fromJson(json);
      default:
        throw UnsupportedError('Unknown section type: $type');
    }
  }
}

enum SectionColor {
  blue,
  indigo,
  violet,
  purple,
  fuchsia,
  pink,
  rose,
  red,
  orange,
  amber,
  yellow,
  lime,
  green,
  emerald,
  teal,
  cyan,
  sky,
  stone,
  slate,
}

extension SectionColorExt on SectionColor {
  Color get bg => const {
        SectionColor.blue: Color(0xFF3B82F6),
        SectionColor.indigo: Color(0xFF6366F1),
        SectionColor.violet: Color(0xFF8B5CF6),
        SectionColor.purple: Color(0xFFA855F7),
        SectionColor.fuchsia: Color(0xFFD946EF),
        SectionColor.pink: Color(0xFFEC4899),
        SectionColor.rose: Color(0xFFF43F5E),
        SectionColor.red: Color(0xFFEF4444),
        SectionColor.orange: Color(0xFFF97316),
        SectionColor.amber: Color(0xFFF59E0B),
        SectionColor.yellow: Color(0xFFEAB308),
        SectionColor.lime: Color(0xFF84CC16),
        SectionColor.green: Color(0xFF22C55E),
        SectionColor.emerald: Color(0xFF10B981),
        SectionColor.teal: Color(0xFF14B8A6),
        SectionColor.cyan: Color(0xFF06B6D4),
        SectionColor.sky: Color(0xFF0EA5E9),
        SectionColor.stone: Color(0xFF78716C),
        SectionColor.slate: Color(0xFF64748B),
      }[this]!;

  Color get lightBg => bg.withValues(alpha: 0.08);
  Color get text => bg;
}

SectionColor _sectionColorFromString(String color) {
  return SectionColor.values.firstWhere(
    (c) => c.name == color,
    orElse: () => SectionColor.blue,
  );
}

Color _colorFromHex(String hex) {
  final cleaned = hex.replaceFirst('#', '').toUpperCase();
  final full = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
  final value = int.parse(full, radix: 16);
  return Color(value);
}
