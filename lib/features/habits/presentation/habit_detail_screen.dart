import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/app/app_theme.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/core/time/expected_days_calculator.dart';
import 'package:habit_tracker/core/time/repeat_rule_evaluator.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'package:habit_tracker/features/habits/presentation/entry_saver.dart'
    as es;
import 'package:habit_tracker/features/notifications/data/notification_providers.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final _habitEntriesProvider =
    FutureProvider.autoDispose.family<List<HabitEntry>, int>(
  (ref, habitId) => ref.watch(habitsRepositoryProvider).getEntriesForHabit(habitId),
);

// ---------------------------------------------------------------------------
// Metrics
// ---------------------------------------------------------------------------

class _Metrics {
  const _Metrics({
    required this.currentStreak,
    required this.bestStreak,
    required this.totalDone,
    required this.completionRate30,
    required this.daysActive,
  });
  final int currentStreak;
  final int bestStreak;
  final int totalDone;
  final double completionRate30;
  final int daysActive;
}

_Metrics _computeMetrics(
  Habit habit,
  List<HabitEntry> entries,
  DateTime today,
) {
  final doneStatuses = {EntryStatus.done, EntryStatus.success};
  final doneByDate = <String, bool>{};
  for (final e in entries) {
    final key = _ds(e.date);
    if (doneStatuses.contains(e.status)) doneByDate[key] = true;
  }

  final start = _dateOnly(habit.repeatStartDate);
  final daysActive = today.difference(start).inDays + 1;

  // Expected days to today
  final expectedAll = expectedDaysInRange(habit, start, today);

  // Total done (among expected)
  int totalDone = 0;
  for (final d in expectedAll) {
    if (doneByDate[_ds(d)] == true) totalDone++;
  }

  // Current streak: walk back from today counting consecutive done expected days
  int currentStreak = 0;
  for (int i = expectedAll.length - 1; i >= 0; i--) {
    final d = expectedAll[i];
    if (d.isAfter(today)) continue;
    if (doneByDate[_ds(d)] == true) {
      currentStreak++;
    } else {
      break;
    }
  }

  // Best streak
  int bestStreak = 0;
  int run = 0;
  for (final d in expectedAll) {
    if (d.isAfter(today)) break;
    if (doneByDate[_ds(d)] == true) {
      run++;
      if (run > bestStreak) bestStreak = run;
    } else {
      run = 0;
    }
  }

  // Completion rate last 30 days
  final from30 = today.subtract(const Duration(days: 29));
  final expected30 =
      expectedDaysInRange(habit, from30.isBefore(start) ? start : from30, today);
  final done30 =
      expected30.where((d) => doneByDate[_ds(d)] == true).length;
  final completionRate30 =
      expected30.isEmpty ? 0.0 : done30 / expected30.length;

  return _Metrics(
    currentStreak: currentStreak,
    bestStreak: bestStreak,
    totalDone: totalDone,
    completionRate30: completionRate30,
    daysActive: daysActive,
  );
}

// ---------------------------------------------------------------------------
// Weekly chart data
// ---------------------------------------------------------------------------

class _WeekBar {
  const _WeekBar(this.label, this.done, this.expected);
  final String label;
  final int done;
  final int expected;
  double get ratio => expected == 0 ? 0.0 : (done / expected).clamp(0.0, 1.0);
}

List<_WeekBar> _buildWeekBars(
  Habit habit,
  List<HabitEntry> entries,
  DateTime today,
) {
  final doneStatuses = {EntryStatus.done, EntryStatus.success};
  final doneByDate = {
    for (final e in entries)
      if (doneStatuses.contains(e.status)) _ds(e.date): true
  };

  final bars = <_WeekBar>[];
  // Last 8 completed weeks (Mon→Sun)
  final monday = today.subtract(Duration(days: today.weekday - 1));
  for (int w = 7; w >= 0; w--) {
    final weekStart = monday.subtract(Duration(days: w * 7));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final cap = weekEnd.isAfter(today) ? today : weekEnd;

    final habitStart = _dateOnly(habit.repeatStartDate);
    final from = weekStart.isBefore(habitStart) ? habitStart : weekStart;

    final expected = expectedDaysInRange(habit, from, cap).length;
    final done = expectedDaysInRange(habit, from, cap)
        .where((d) => doneByDate[_ds(d)] == true)
        .length;

    final label = w == 0 ? 'Эта' : '${weekStart.day}.${weekStart.month}';
    bars.add(_WeekBar(label, done, expected));
  }
  return bars;
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class HabitDetailScreen extends ConsumerStatefulWidget {
  const HabitDetailScreen({super.key, required this.habit});
  final Habit habit;

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  // ponytail: local copy so we can reflect toggle-active without re-routing
  late Habit _habit;

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(_habitEntriesProvider(_habit.id));

    return Scaffold(
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (entries) {
          final today = DateTime.now();
          final metrics = _computeMetrics(_habit, entries, today);
          final weekBars = _buildWeekBars(_habit, entries, today);
          return CustomScrollView(
            slivers: [
              _DetailAppBar(
                habit: _habit,
                onEdit: _edit,
                onToggleActive: _toggleActive,
                onDelete: _delete,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoSection(habit: _habit),
                      const SizedBox(height: 20),
                      _MetricsSection(metrics: metrics),
                      const SizedBox(height: 20),
                      _WeeklyChart(bars: weekBars, color: _habit.color),
                      const SizedBox(height: 20),
                      _MiniCalendarSection(
                        habit: _habit,
                        entries: entries,
                        today: today,
                      ),
                      if (_habit.completionType == CompletionType.time) ...[
                        const SizedBox(height: 20),
                        _TimerSection(habit: _habit),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _edit() async {
    await context.push('/habits/edit', extra: _habit);
    // Refresh after edit
    ref.invalidate(_habitEntriesProvider(_habit.id));
  }

  Future<void> _toggleActive() async {
    final repo = ref.read(habitsRepositoryProvider);
    final updated = _habit.copyWith(isActive: !_habit.isActive);
    await repo.update(updated);
    setState(() => _habit = updated);
    await _rebuildNotifications();
  }

  Future<void> _rebuildNotifications() => ref
      .read(notificationOrchestratorProvider)
      .rebuild(ref.read(settingsProvider));

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить привычку?'),
        content: const Text('Все записи тоже будут удалены.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить',
                style: TextStyle(color: Color(0xFFF44336))),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final repo = ref.read(habitsRepositoryProvider);
    await repo.deleteAllEntries(_habit.id);
    await repo.delete(_habit.id);
    await _rebuildNotifications();
    if (mounted) context.pop();
  }
}

// ---------------------------------------------------------------------------
// SliverAppBar with header
// ---------------------------------------------------------------------------

class _DetailAppBar extends StatelessWidget {
  const _DetailAppBar({
    required this.habit,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  });
  final Habit habit;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: habit.color,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: onEdit,
          tooltip: 'Редактировать',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (v) {
            if (v == 'toggle') onToggleActive();
            if (v == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'toggle',
              child: Text(habit.isActive ? 'Деактивировать' : 'Активировать'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Удалить',
                  style: TextStyle(color: Color(0xFFF44336))),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                habit.color,
                habit.color.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppTheme.cardRadius,
                    ),
                    child: Center(
                      child: habit.visualType == VisualType.emoji
                          ? Text(
                              habit.emoji ?? '⭐',
                              style: const TextStyle(fontSize: 36),
                            )
                          : const Icon(Icons.star_outline,
                              color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (habit.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            habit.description!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _Badge(
                              habit.isActive ? 'Активна' : 'Неактивна',
                              habit.isActive
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              habit.isActive
                                  ? habit.color.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.15),
                            ),
                            const SizedBox(width: 8),
                            _Badge(
                              habit.habitKind == HabitKind.positive
                                  ? 'Позитивная'
                                  : 'Негативная',
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 0.15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.textColor, this.bgColor);
  final String label;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppTheme.chipRadius,
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.25), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info section
// ---------------------------------------------------------------------------

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('Механика', _completionLabel(habit.completionType)),
      if (habit.targetValue != null)
        ('Цель', '${_fmtV(habit.targetValue!)} ${habit.targetUnit ?? ''}'),
      ('Расписание', _scheduleLabel(habit)),
      ('Начало', _fmtDate(habit.repeatStartDate)),
      ('Создана', _fmtDate(habit.createdAt)),
    ];

    return _Card(
      title: 'Информация',
      child: Column(
        children: rows
            .map(
              (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        r.$1,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        r.$2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _completionLabel(CompletionType ct) => switch (ct) {
        CompletionType.yesNo => 'Да / Нет',
        CompletionType.quantity => 'Количество',
        CompletionType.time => 'Время',
        CompletionType.avoidance => 'Избегание',
      };

  String _scheduleLabel(Habit h) {
    switch (h.repeatType) {
      case RepeatType.everyDay:
        return 'Каждый день';
      case RepeatType.selectedWeekdays:
        const names = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
        final days = h.repeatWeekdays.map((d) => names[d - 1]).join(', ');
        return days.isEmpty ? 'По дням недели' : days;
      case RepeatType.everyNDays:
        return 'Каждые ${h.repeatInterval ?? 2} дн.';
      case RepeatType.nTimesPerNDays:
        return '${h.repeatGoalCount ?? 3} раз за ${h.repeatPeriodDays ?? 7} дн.';
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  String _fmtV(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}

// ---------------------------------------------------------------------------
// Metrics section
// ---------------------------------------------------------------------------

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.metrics});
  final _Metrics metrics;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Статистика',
      child: Row(
        children: [
          _MetricTile('🔥', '${metrics.currentStreak}', 'Серия'),
          _MetricTile('🏆', '${metrics.bestStreak}', 'Рекорд'),
          _MetricTile(
            '✅',
            '${metrics.totalDone}',
            'Выполнено',
          ),
          _MetricTile(
            '📊',
            '${(metrics.completionRate30 * 100).round()}%',
            '30 дней',
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile(this.emoji, this.value, this.label);
  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Weekly bar chart
// ---------------------------------------------------------------------------

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.bars, required this.color});
  final List<_WeekBar> bars;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'По неделям',
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: bars.map((bar) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: bar.expected == 0 ? 0.05 : bar.ratio,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bar.done > 0
                                  ? color
                                  : AppTheme.cardBackground,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                              border: bar.done == 0 && bar.expected > 0
                                  ? Border.all(
                                      color: AppTheme.dividerColor)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bar.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.textSecondary,
                            fontSize: 9,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mini calendar (last 3 months)
// ---------------------------------------------------------------------------

class _MiniCalendarSection extends StatelessWidget {
  const _MiniCalendarSection({
    required this.habit,
    required this.entries,
    required this.today,
  });
  final Habit habit;
  final List<HabitEntry> entries;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final doneByDate = {
      for (final e in entries)
        if (e.status == EntryStatus.done || e.status == EntryStatus.success)
          _ds(e.date): true
    };

    return _Card(
      title: 'История (последние 3 месяца)',
      child: Column(
        children: List.generate(3, (i) {
          final month = DateTime(today.year, today.month - (2 - i));
          return _MiniMonthGrid(
            month: month,
            habit: habit,
            doneByDate: doneByDate,
            today: today,
          );
        }),
      ),
    );
  }
}

class _MiniMonthGrid extends StatelessWidget {
  const _MiniMonthGrid({
    required this.month,
    required this.habit,
    required this.doneByDate,
    required this.today,
  });
  final DateTime month;
  final Habit habit;
  final Map<String, bool> doneByDate;
  final DateTime today;

  static const _monthNames = [
    'Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
    'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек',
  ];

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final offset = first.weekday - 1;
    final totalCells = ((offset + daysInMonth) / 7).ceil() * 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, top: 8),
          child: Text(
            '${_monthNames[month.month - 1]} ${month.year}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            childAspectRatio: 1,
          ),
          itemCount: totalCells,
          itemBuilder: (_, i) {
            final dayNum = i - offset + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const SizedBox.shrink();
            }
            final date = DateTime(month.year, month.month, dayNum);
            final isFuture = date.isAfter(today);
            final isExpected = isExpectedOn(habit, date);
            final isDone = doneByDate[_ds(date)] == true;
            final isToday = _ds(date) == _ds(today);

            Color bg = Colors.transparent;
            if (isToday) {
              bg = AppTheme.primaryColor.withValues(alpha: 0.15);
            } else if (isDone) {
              bg = habit.color;
            } else if (isExpected && !isFuture) {
              bg = AppTheme.cardBackground;
            }

            return Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                border: isToday
                    ? Border.all(color: AppTheme.primaryColor, width: 1)
                    : isExpected && !isFuture && !isDone
                        ? Border.all(color: AppTheme.dividerColor)
                        : null,
              ),
              child: Center(
                child: Text(
                  '$dayNum',
                  style: TextStyle(
                    fontSize: 9,
                    color: isDone ? Colors.white : null,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Timer section (for time habits)
// ---------------------------------------------------------------------------

class _TimerSection extends ConsumerStatefulWidget {
  const _TimerSection({required this.habit});
  final Habit habit;

  @override
  ConsumerState<_TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends ConsumerState<_TimerSection> {
  final _stopwatch = Stopwatch();
  Timer? _ticker;
  bool _running = false;

  @override
  void dispose() {
    _ticker?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _toggle() {
    if (_running) {
      _ticker?.cancel();
      _stopwatch.stop();
      setState(() => _running = false);
      _promptSave();
    } else {
      _stopwatch.start();
      _ticker = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {}),
      );
      setState(() => _running = true);
    }
  }

  Future<void> _promptSave() async {
    final elapsed = _stopwatch.elapsed;
    final minutes = elapsed.inMinutes;
    if (minutes == 0) return;

    final save = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Сохранить время?'),
        content:
            Text('Прошло ${_fmtDuration(elapsed)}. Сохранить как выполнение?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
    if (save == true) {
      final target = widget.habit.targetValue ?? 0;
      final status = minutes >= target ? EntryStatus.done : EntryStatus.skipped;
      final today = DateTime.now();
      final date = DateTime(today.year, today.month, today.day);
      await es.saveEntry(
        ref,
        widget.habit,
        null,
        date,
        status: status,
        value: minutes.toDouble(),
        onInvalidate: () => ref.invalidate(_habitEntriesProvider(widget.habit.id)),
      );
      if (mounted) {
        ref.invalidate(_habitEntriesProvider(widget.habit.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сохранено: $minutes мин')),
        );
      }
      _stopwatch.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;
    final target = widget.habit.targetValue;
    final targetSec = target != null ? (target * 60).toInt() : null;
    final progress = targetSec != null && targetSec > 0
        ? (elapsed.inSeconds / targetSec).clamp(0.0, 1.0)
        : 0.0;

    return _Card(
      title: 'Таймер',
      child: Column(
        children: [
          // Circular-ish progress ring using LinearProgressIndicator
          if (targetSec != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppTheme.cardBackground,
                color: progress >= 1.0
                    ? const Color(0xFF43C59E)
                    : widget.habit.color,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _fmtDuration(elapsed),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
              if (target != null) ...[
                Text(
                  ' / ${_fmtV(target)} ${widget.habit.targetUnit ?? 'мин'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _toggle,
                icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                label: Text(_running ? 'Стоп' : 'Старт'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _running ? const Color(0xFFF44336) : widget.habit.color,
                ),
              ),
              if (!_running && _stopwatch.elapsedMilliseconds > 0) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    setState(() => _stopwatch.reset());
                  },
                  child: const Text('Сброс'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _fmtV(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.7,
                ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
String _ds(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
