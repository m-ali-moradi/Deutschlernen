import 'package:flutter/material.dart';

// ─── Model Types ──────────────────────────────────────────────────────────────

class ExPair {
  final String de;
  final String en;
  const ExPair(this.de, this.en);
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

abstract class GrammarSection {
  const GrammarSection();
}

class ConceptSection extends GrammarSection {
  final String title;
  final String text;
  final List<String>? bullets;
  const ConceptSection({required this.title, required this.text, this.bullets});
}

class FormulaSection extends GrammarSection {
  final String label;
  final String formula;
  final List<Color> colors;
  const FormulaSection({required this.label, required this.formula, required this.colors});
}

class ConjugationSection extends GrammarSection {
  final String title;
  final List<TableRow2> rows;
  final SectionColor color;
  const ConjugationSection({required this.title, required this.rows, required this.color});
}

class ExamplesSection extends GrammarSection {
  final String title;
  final List<ExPair> items;
  final SectionColor color;
  const ExamplesSection({required this.title, required this.items, required this.color});
}

class ComparisonSection extends GrammarSection {
  final String title;
  final List<String> headers;
  final List<ComparisonRow> rows;
  const ComparisonSection({required this.title, required this.headers, required this.rows});
}

class RulesSection extends GrammarSection {
  final String title;
  final List<String> items;
  const RulesSection({required this.title, required this.items});
}

enum TipVariant { info, warning, success }

class TipSection extends GrammarSection {
  final String text;
  final TipVariant variant;
  const TipSection({required this.text, this.variant = TipVariant.info});
}

class FromToLabel {
  final String label;
  final String text;
  const FromToLabel({required this.label, required this.text});
}

class TransformSection extends GrammarSection {
  final String title;
  final FromToLabel from;
  final FromToLabel to;
  final String? note;
  const TransformSection({required this.title, required this.from, required this.to, this.note});
}

// ─── GrammarDetailData ────────────────────────────────────────────────────────

class GrammarDetailData {
  final String id;
  final String subtitle;
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
}

// ─── Color Palette ────────────────────────────────────────────────────────────

enum SectionColor {
  blue, indigo, violet, purple, fuchsia, pink, rose, red, orange,
  amber, yellow, lime, green, emerald, teal, cyan, sky, stone, slate,
}

extension SectionColorExt on SectionColor {
  Color get bg => const {
    SectionColor.blue:    Color(0xFF3B82F6),
    SectionColor.indigo:  Color(0xFF6366F1),
    SectionColor.violet:  Color(0xFF8B5CF6),
    SectionColor.purple:  Color(0xFFA855F7),
    SectionColor.fuchsia: Color(0xFFD946EF),
    SectionColor.pink:    Color(0xFFEC4899),
    SectionColor.rose:    Color(0xFFF43F5E),
    SectionColor.red:     Color(0xFFEF4444),
    SectionColor.orange:  Color(0xFFF97316),
    SectionColor.amber:   Color(0xFFF59E0B),
    SectionColor.yellow:  Color(0xFFEAB308),
    SectionColor.lime:    Color(0xFF84CC16),
    SectionColor.green:   Color(0xFF22C55E),
    SectionColor.emerald: Color(0xFF10B981),
    SectionColor.teal:    Color(0xFF14B8A6),
    SectionColor.cyan:    Color(0xFF06B6D4),
    SectionColor.sky:     Color(0xFF0EA5E9),
    SectionColor.stone:   Color(0xFF78716C),
    SectionColor.slate:   Color(0xFF64748B),
  }[this]!;

  Color get lightBg => bg.withValues(alpha: 0.08);
  Color get text => bg;
}

// ─── Level Colors ─────────────────────────────────────────────────────────────

const Color kA1Bg   = Color(0xFFDCFCE7);
const Color kA1Text = Color(0xFF16A34A);
const Color kA2Bg   = Color(0xFFDBEAFE);
const Color kA2Text = Color(0xFF1D4ED8);
const Color kB1Bg   = Color(0xFFEDE9FE);
const Color kB1Text = Color(0xFF7C3AED);
const Color kB2Bg   = Color(0xFFFEF3C7);
const Color kB2Text = Color(0xFFB45309);
const Color kC1Bg   = Color(0xFFFEE2E2);
const Color kC1Text = Color(0xFFDC2626);
