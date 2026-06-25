import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/app/app_theme.dart';
import 'package:habit_tracker/features/habits/domain/habit_templates.dart';

/// Template picker — shown when FAB is pressed.
/// Routes to HabitFormScreen with a pre-filled template or null (custom).
class TemplatePickerScreen extends StatelessWidget {
  const TemplatePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Новая привычка')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // Custom habit card
          _CustomCard(theme: theme),
          const SizedBox(height: 20),

          // Templates by category
          for (final category in kTemplateCategories) ...[
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Text(
                category.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: 0.8,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            _TemplateGrid(
              templates: kHabitTemplates
                  .where((t) => t.category == category)
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppTheme.cardRadius,
      onTap: () => context.push('/habits/new'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryColor,
            width: 1.5,
          ),
          borderRadius: AppTheme.cardRadius,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.12),
                borderRadius: AppTheme.chipRadius,
              ),
              child: const Icon(
                Icons.add,
                color: AppTheme.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Своя привычка',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: AppTheme.primaryColor),
                  ),
                  Text(
                    'Настрой с нуля',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateGrid extends StatelessWidget {
  const _TemplateGrid({required this.templates});
  final List<HabitTemplate> templates;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: templates.length,
      itemBuilder: (context, i) => _TemplateCard(template: templates[i]),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});
  final HabitTemplate template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: AppTheme.cardRadius,
      onTap: () => context.push('/habits/new', extra: template),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: AppTheme.cardRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: template.color.withValues(alpha: 0.15),
                borderRadius: AppTheme.chipRadius,
              ),
              child: Center(
                child: Text(
                  template.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              template.title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: const Color(0xFF191919),
                height: 1.2,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
