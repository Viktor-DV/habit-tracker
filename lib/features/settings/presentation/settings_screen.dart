import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/app/app_theme.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/features/monetization/data/monetization_providers.dart';
import 'package:habit_tracker/features/monetization/domain/premium_repository.dart';
import 'package:habit_tracker/features/notifications/data/notification_providers.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';
import 'package:habit_tracker/features/settings/domain/settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);

    // Any settings change (dayStart, morning, snooze, DND) → reschedule.
    ref.listen(settingsProvider, (_, next) {
      ref.read(notificationOrchestratorProvider).rebuild(next);
    });

    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (!isPremium) const _BannerAdStub(),

          // 1. DND
          _SectionHeader('Уведомления'),
          _DndTile(settings: settings, notifier: notifier),
          const Divider(),

          // 2. Время начала нового дня
          _SectionHeader('День'),
          _DayStartTile(settings: settings, notifier: notifier),
          const Divider(),

          // 3. Общее утреннее напоминание
          _SwitchTile(
            title: 'Утреннее напоминание',
            subtitle:
                'Сводка привычек в начале нового дня (${_fmt(settings.dayStartHour, settings.dayStartMinute)})',
            value: settings.morningSummaryEnabled,
            onChanged: (v) => notifier.setMorningSummary(v),
          ),
          const Divider(),

          // 4. Интервал «Напомнить позже»
          _SnoozeIntervalTile(settings: settings, notifier: notifier),
          const Divider(),

          // 5. История
          _SectionHeader('История'),
          _HistorySection(settings: settings, notifier: notifier),
          const Divider(),

          // 6. Premium
          _SectionHeader('Premium'),
          _PremiumTile(theme: theme),

          const SizedBox(height: 32),
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
          title: 'Заглушить все уведомления',
          subtitle: isActive ? _dndLabel(settings) : 'Уведомления активны',
          value: isActive,
          onChanged: (v) => v ? notifier.setDndForever() : notifier.setDndOff(),
        ),
        if (isActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                _OutlineButton(
                  label: 'Заглушить на период',
                  onTap: () => _pickDndUntil(context),
                ),
                const SizedBox(width: 12),
                _OutlineButton(
                  label: 'Отключить',
                  onTap: notifier.setDndOff,
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _dndLabel(Settings s) => switch (s.dndMode) {
        DndMode.forever => 'Заглушено навсегда',
        DndMode.until => s.dndUntil != null
            ? 'Заглушено до ${_fmtDate(s.dndUntil!)}'
            : 'Заглушено',
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

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')} ${_fmt(d.hour, d.minute)}';
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
      title: const Text('Начало нового дня'),
      subtitle: Text(
        _fmt(settings.dayStartHour, settings.dayStartMinute),
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
      helpText: 'Начало нового дня',
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
      title: const Text('Интервал «Напомнить позже»'),
      subtitle: Text(
        '${settings.snoozeIntervalMinutes} мин',
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
        title: 'Интервал (мин)',
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
          title: 'Хранить историю',
          subtitle: 'Без истории долгосрочная статистика ограничена',
          value: settings.historyEnabled,
          onChanged: (v) => notifier.setHistoryEnabled(v),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: countAsync.when(
            data: (count) => Text(
              'Записей: $count  ·  Авточистка при >50 МБ',
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
                label: 'Очистить всё',
                onTap: () => _confirmClearAll(context, repo, ref),
              ),
              _OutlineButton(
                label: 'Очистить последние N',
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
        title: const Text('Очистить всю историю?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Очистить'),
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
        title: 'Удалить последних N записей',
        subtitle: 'Всего записей: $total',
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
// Premium tile
// ---------------------------------------------------------------------------

class _PremiumTile extends ConsumerWidget {
  const _PremiumTile({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(premiumProvider);
    final isPremium = status == PremiumStatus.premium;

    if (isPremium) {
      return ListTile(
        leading: const Icon(Icons.star_rounded, color: Color(0xFF2E7D32)),
        title: const Text('Premium активен'),
        subtitle: const Text('Реклама отключена · Безлимит привычек'),
      );
    }

    return ListTile(
      title: const Text('Получить Premium'),
      subtitle: const Text('Безлимит привычек · Без рекламы · Разово'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: AppTheme.chipRadius,
        ),
        child: Text(
          'Купить — 100 ₽',
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: () => context.push('/paywall'),
    );
  }
}

// ---------------------------------------------------------------------------
// Banner ad stub (settings screen)
// ---------------------------------------------------------------------------

class _BannerAdStub extends StatelessWidget {
  const _BannerAdStub();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Center(
        child: Text(
          'Реклама Яндекс',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFFAAAAAA),
              ),
        ),
      ),
    );
  }
}

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
            decoration: const InputDecoration(hintText: 'Введите число'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            final v = int.tryParse(controller.text);
            if (v != null && v >= min && v <= max) {
              Navigator.pop(context, v);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

String _fmt(int h, int m) =>
    '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
