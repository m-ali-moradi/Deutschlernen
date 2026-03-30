import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/features/exams/domain/models/exam_models.dart';

class ExamDetailScreen extends ConsumerWidget {
  final ExamInfo exam;

  const ExamDetailScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appUiTextProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: AppTokens.meshBackground(isDark)),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(context, isDark, strings),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildSectionTitle(
                            strings.examStructureAndDuration(), isDark),
                        const SizedBox(height: 12),
                        ...exam.structure.map((m) =>
                            _buildModuleTile(context, m, isDark, strings)),
                        if (exam.grading != null && exam.grading!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildGradingSection(exam.grading!, isDark, strings),
                        ],
                        const SizedBox(height: 24),
                        _buildSectionTitle(strings.examTips(), isDark),
                        const SizedBox(height: 12),
                        _buildTipsCard(exam.tips, isDark),
                        const SizedBox(height: 24),
                        _buildSectionTitle(
                            strings.examOfficialResources(), isDark),
                        const SizedBox(height: 12),
                        ...exam.resources
                            .map((res) => _buildResourceTile(res, isDark)),
                        const SizedBox(height: 32),
                        _buildSourceLink(isDark, strings),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppUiText strings) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          AppIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  style: TextStyle(
                    color: AppTokens.textPrimary(isDark),
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTokens.primary(isDark).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTokens.primary(isDark)
                                .withValues(alpha: 0.1)),
                      ),
                      child: Text(
                        exam.level,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppTokens.primary(isDark),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      exam.provider.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.textMuted(isDark),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppTokens.textMuted(isDark),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildModuleTile(
      BuildContext context, ExamModule module, bool isDark, AppUiText strings) {
    if (module.isBreak) {
      return _buildBreakTile(module, isDark, strings);
    }

    final displayDuration = module.duration.toLowerCase().contains('min')
        ? module.duration
        : '${module.duration} ${strings.examMinutes()}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(24),
        child: ExpansionTile(
          expandedAlignment: Alignment.topLeft,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTokens.primary(isDark).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_getModuleIcon(module.name),
                    size: 20, color: AppTokens.primary(isDark)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          letterSpacing: -0.3,
                          color: AppTokens.textPrimary(isDark)),
                    ),
                    Text(
                      displayDuration,
                      style: TextStyle(
                        color: AppTokens.primary(isDark),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6, left: 46),
            child: Text(
              module.description,
              style: TextStyle(
                  color: AppTokens.textMuted(isDark),
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
          childrenPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: [
            if (module.parts.isNotEmpty) ...[
              const Divider(height: 24, indent: 40),
              ...module.parts.map((part) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTokens.primary(isDark)
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                part.title,
                                style: TextStyle(
                                  color: AppTokens.primary(isDark),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            part.description,
                            style: TextStyle(
                              color: AppTokens.textPrimary(isDark),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBreakTile(ExamModule module, bool isDark, AppUiText strings) {
    final displayDuration = module.duration.toLowerCase().contains('min')
        ? module.duration
        : '${module.duration} ${strings.examMinutes()}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.coffee_rounded,
                  color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.examBreak(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                      color: AppTokens.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    displayDuration,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textMuted(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard(List<String> tips, bool isDark) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(tips.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == tips.length - 1 ? 0 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppTokens.primary(isDark),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tips[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTokens.textPrimary(isDark),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  IconData _getModuleIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('lesen') || n.contains('reading')) return Icons.menu_book;
    if (n.contains('hören') || n.contains('listening')) return Icons.headphones;
    if (n.contains('schreiben') || n.contains('writing')) return Icons.edit;
    if (n.contains('sprechen') || n.contains('speaking')) {
      return Icons.record_voice_over;
    }
    return Icons.assignment;
  }

  Widget _buildGradingSection(
      List<GradingEntry> grading, bool isDark, AppUiText strings) {
    return PremiumCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(Icons.grade_outlined,
                    size: 18, color: AppTokens.primary(isDark)),
                const SizedBox(width: 8),
                Text(
                  strings.examGrading(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTokens.textPrimary(isDark),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: AppTokens.surfaceMuted(isDark).withValues(alpha: 0.5),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      strings.examPoints(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTokens.textMuted(isDark),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      strings.examGrade(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTokens.textMuted(isDark),
                      ),
                    ),
                  ),
                ],
              ),
              ...grading.map((g) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Text(
                          g.points,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTokens.textPrimary(isDark),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Text(
                          g.grade,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTokens.primary(isDark),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourceTile(ExamResource res, bool isDark) {
    IconData icon;
    switch (res.type) {
      case ExamResourceType.pdf:
        icon = Icons.picture_as_pdf_rounded;
        break;
      case ExamResourceType.mp3:
        icon = Icons.audiotrack_rounded;
        break;
      default:
        icon = Icons.link_rounded;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTokens.stateInfoSurface(isDark).withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: AppTokens.stateInfoForeground(isDark), size: 20),
          ),
          title: Text(
            res.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary(isDark),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (res.description.isNotEmpty) ...[
                  Text(
                    res.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTokens.textMuted(isDark),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  res.type.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTokens.primary(isDark),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.open_in_new_rounded,
            size: 18,
            color: AppTokens.textMuted(isDark).withValues(alpha: 0.5),
          ),
          onTap: () => _launchURL(res.url),
        ),
      ),
    );
  }

  Widget _buildSourceLink(bool isDark, AppUiText strings) {
    return InkWell(
      onTap: () => _launchURL(exam.sourceUrl),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.source, size: 14, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              strings.examSourceInfo(),
              style: TextStyle(
                color: AppTokens.textMuted(isDark),
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Could show snackbar error
    }
  }
}



