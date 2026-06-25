import 'package:flutter/material.dart';
import 'package:habit_tracker/app/app_theme.dart';

/// Reusable empty-state widget.
///
/// Usage:
///   EmptyStateView(emoji: '🌿', title: 'Привычек нет', subtitle: 'Нажмите + чтобы создать')
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String emoji;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
