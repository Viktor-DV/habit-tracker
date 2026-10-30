import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/app/app_theme.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/features/notifications/data/notification_providers.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';
import 'package:habit_tracker/features/settings/domain/settings.dart';
import 'package:habit_tracker/features/settings/domain/theme_mode.dart';
import 'package:habit_tracker/features/settings/data/theme_mode_provider.dart';
import 'package:habit_tracker/l10n/l10n.dart';
import 'package:habit_tracker/l10n/l10n_date.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    // Any settings change (dayStart, morning, snooze, DND) → reschedule.
    ref.listen(settingsProvider, (_, next) {
      ref.read(notificationOrchestratorProvider).rebuild(next);
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader(context.l10n.appearanceSection),
          const _ThemeModeTile(),
          const Divider(),

          // 1. DND
          _SectionHeader(context.l10n.notificationsSection),
          _DndTile(settings: settings, notifier: notifier),
          const Divider(),

          // 2. Время начала нового дня
          _SectionHeader(context.l10n.daySection),
          _DayStartTile(settings: settings, notifier: notifier),
          const Divider(),

          // 3. Общее утреннее напоминание
          _SwitchTile(
            title: context.l10n.morningSummaryTitle,
            subtitle:
                context.l10n.morningSummarySubtitle(formatTime(context, settings.dayStartHour, settings.dayStartMinute)),
            value: settings.morningSummaryEnabled,
            onChanged: (v) => notifier.setMorningSummary(v),
          ),
          const Divider(),

          // 4. Интервал «Напомнить позже»
          _SnoozeIntervalTile(settings: settings, notifier: notifier),
          const Divider(),

          // 5. История
          _SectionHeader(context.l10n.historySection),
          _HistorySection(settings: settings, notifier: notifier),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Theme mode
// ---------------------------------------------------------------------------

class _ThemeModeTile extends ConsumerWidget {
  const _ThemeModeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final setMode = ref.read(themeModeProvider.notifier).set;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.themeLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          SegmentedButton<ThemeModeOption>(
            showSelectedIcon: false,
            selected: {mode},
            onSelectionChanged: (s) => setMode(s.first),
            segments: [
              ButtonSegment(
                value: ThemeModeOption.light,
                label: Text(context.l10n.themeLight),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeModeOption.system,
                label: Text(context.l10n.themeSystem),
                icon: const Icon(Icons.settings_brightness_outlined),
              ),
              ButtonSegment(
                value: ThemeModeOption.dark,
                label: Text(context.l10n.themeDark),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DND
// ---------------------------------------------------------------------------

class _DndTile extends ConsumerWidget {
  const _DndTile({required this.settings, required this.notifier});
  final Settings settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = settings.dndMode != DndMode.off;
    return Column(
      children: [
        _SwitchTile(
          title: context.l10n.dndTitle,
          subtitle: isActive ? _dndLabel(context, settings) : context.l10n.dndSubtitleOff,
          value: isActive,
          onChanged: (v) => v ? notifier.setDndForever() : notifier.setDndOff(),
        ),
        if (isActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                _OutlineButton(
                  label: context.l10n.dndMutePeriod,
                  onTap: () => _pickDndUntil(context),
                ),
                const SizedBox(width: 12),
                _OutlineButton(
                  label: context.l10n.dndDisable,
                  onTap: notifier.setDndOff,
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _dndLabel(BuildContext context, Settings s) => switch (s.dndMode) {
        DndMode.forever => context.l10n.dndForever,
        DndMode.until => s.dndUntil != null
            ? context.l10n.dndUntil(formatDateTime(context, s.dndUntil!))
            : context.l10n.dndMuted,
        DndMode.off => '',
      };

  Future<void> _pickDndUntil(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final until = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    notifier.setDndUntil(until);
  }
}

// ---------------------------------------------------------------------------
// Day start time
// ---------------------------------------------------------------------------

class _DayStartTile extends StatelessWidget {
  const _DayStartTile({required this.settings, required this.notifier});
  final Settings settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(context.l10n.dayStartTitle),
      subtitle: Text(
        formatTime(context, settings.dayStartHour, settings.dayStartMinute),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppTheme.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: settings.dayStartHour, minute: settings.dayStartMinute),
      helpText: context.l10n.dayStartPickerHint,
    );
    if (picked == null) return;
    notifier.setDayStartTime(picked.hour, picked.minute);
  }
}

// ---------------------------------------------------------------------------
// Snooze interval
// ---------------------------------------------------------------------------

class _SnoozeIntervalTile extends StatelessWidget {
  const _SnoozeIntervalTile({required this.settings, required this.notifier});
  final Settings settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(context.l10n.snoozeTitle),
      subtitle: Text(
        context.l10n.snoozeUnit(settings.snoozeIntervalMinutes),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppTheme.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final ctrl =
        TextEditingController(text: '${settings.snoozeIntervalMinutes}');
    final result = await showDialog<int>(
      context: context,
      builder: (_) => _NumberInputDialog(
        title: context.l10n.intervalDialogTitle,
        controller: ctrl,
        min: 1,
        max: 120,
      ),
    );
    if (result != null) notifier.setSnoozeInterval(result);
  }
}

// ---------------------------------------------------------------------------
// History section
// ---------------------------------------------------------------------------

class _HistorySection extends ConsumerWidget {
  const _HistorySection({required this.settings, required this.notifier});
  final Settings settings;
  final SettingsNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(habitsRepositoryProvider);
    final countAsync = ref.watch(_entryCountProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SwitchTile(
          title: context.l10n.historyKeepTitle,
          subtitle: context.l10n.historyKeepSubtitle,
          value: settings.historyEnabled,
          onChanged: (v) => notifier.setHistoryEnabled(v),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: countAsync.when(
            data: (count) => Text(
              context.l10n.historyCount(count),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppTheme.textSecondary),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _OutlineButton(
                label: context.l10n.historyClearAll,
                onTap: () => _confirmClearAll(context, repo, ref),
              ),
              _OutlineButton(
                label: context.l10n.historyClearN,
                onTap: () => _pickClearN(context, repo, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmClearAll(
    BuildContext context,
    dynamic repo,
    WidgetRef ref,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.clearAllTitle),
        content: Text(context.l10n.clearAllBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.clearAllConfirm),
          ),
        ],
      ),
    );
    if (ok == true) {
      await repo.deleteAllEntriesGlobal();
      ref.invalidate(_entryCountProvider);
    }
  }

  Future<void> _pickClearN(
    BuildContext context,
    dynamic repo,
    WidgetRef ref,
  ) async {
    final countAsync = ref.read(_entryCountProvider);
    final total = countAsync.asData?.value ?? 0;
    final ctrl = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (_) => _NumberInputDialog(
        title: context.l10n.clearNTitle,
        subtitle: context.l10n.clearNSubtitle(total),
        controller: ctrl,
        min: 1,
        max: total > 0 ? total : 9999,
      ),
    );
    if (result != null) {
      await repo.deleteOldestEntries(result);
      ref.invalidate(_entryCountProvider);
    }
  }
}

final _entryCountProvider = FutureProvider.autoDispose<int>((ref) {
  final repo = ref.watch(habitsRepositoryProvider);
  return repo.getTotalEntriesCount();
});

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 0.8,
              color: AppTheme.textSecondary,
            ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppTheme.textSecondary),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppTheme.primaryColor,
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        side: BorderSide(color: AppTheme.dividerColor),
        shape: const RoundedRectangleBorder(borderRadius: AppTheme.chipRadius),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        textStyle: const TextStyle(fontSize: 13),
      ),
      child: Text(label),
    );
  }
}

class _NumberInputDialog extends StatelessWidget {
  const _NumberInputDialog({
    required this.title,
    required this.controller,
    required this.min,
    required this.max,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final TextEditingController controller;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                subtitle!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppTheme.textSecondary),
              ),
            ),
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(hintText: context.l10n.numberHint),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            final v = int.tryParse(controller.text);
            if (v != null && v >= min && v <= max) {
              Navigator.pop(context, v);
            }
          },
          child: Text(context.l10n.ok),
        ),
      ],
    );
  }
}
