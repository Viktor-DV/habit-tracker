import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/app/app_theme.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'package:habit_tracker/features/statistics/domain/statistics_calculator.dart';
import 'package:habit_tracker/shared/widgets/empty_state_view.dart';
import 'package:habit_tracker/shared/widgets/error_view.dart';
import 'package:habit_tracker/l10n/l10n.dart';

// ---------------------------------------------------------------------------
// Period selection
// ---------------------------------------------------------------------------

enum StatPeriod { days7, days30, days90, year }

extension on StatPeriod {
  String label(BuildContext context) => switch (this) {
        StatPeriod.days7 => context.l10n.period7,
        StatPeriod.days30 => context.l10n.period30,
        StatPeriod.days90 => context.l10n.period90,
        StatPeriod.year => context.l10n.periodYear,
      };
  int get days => switch (this) {
        StatPeriod.days7 => 7,
        StatPeriod.days30 => 30,
        StatPeriod.days90 => 90,
        StatPeriod.year => 365,
      };
}

// Default = rolling last month per spec.
class _PeriodNotifier extends Notifier<StatPeriod> {
  @override
  StatPeriod build() => StatPeriod.days30;
  void set(StatPeriod p) => state = p;
}

final _periodProvider =
    NotifierProvider<_PeriodNotifier, StatPeriod>(_PeriodNotifier.new);

// ---------------------------------------------------------------------------
// Aggregated data
// ---------------------------------------------------------------------------

class _HabitStat {
  const _HabitStat(this.habit, this.stats);
  final Habit habit;
  final PeriodStats stats;
}

class _OverallStats {
  const _OverallStats({
    required this.perHabit,
    required this.avgCompletion,
    required this.totalCompleted,
    required this.bestHabit,
    required this.dailyRatios,
  });
  final List<_HabitStat> perHabit;
  final double avgCompletion;
  final int totalCompleted;
  final _HabitStat? bestHabit;

  /// Completion ratio per calendar day across all active habits (for trend chart).
  final List<double> dailyRatios;
}

final _statsProvider =
    FutureProvider.autoDispose<_OverallStats>((ref) async {
  ref.watch(habitsRevisionProvider);
  final repo = ref.watch(habitsRepositoryProvider);
  final period = ref.watch(_periodProvider);

  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  final from = todayDate.subtract(Duration(days: period.days - 1));

  final habits = (await repo.getAll()).where((h) => h.isActive).toList();
  final entries = await repo.getEntriesForRange(from, todayDate);

  // Group entries by habit
  final byHabit = <int, List<HabitEntry>>{};
  for (final e in entries) {
    byHabit.putIfAbsent(e.habitId, () => []).add(e);
  }

  final perHabit = <_HabitStat>[];
  for (final h in habits) {
    final stat = periodStats(
      h,
      byHabit[h.id] ?? const [],
      from,
      todayDate,
      todayDate,
    );
    if (stat.expected > 0) perHabit.add(_HabitStat(h, stat));
  }

  perHabit.sort(
      (a, b) => b.stats.completionRate.compareTo(a.stats.completionRate));

  final avgCompletion = perHabit.isEmpty
      ? 0.0
      : perHabit.map((e) => e.stats.completionRate).reduce((a, b) => a + b) /
          perHabit.length;
  final totalCompleted =
      perHabit.fold<int>(0, (sum, e) => sum + e.stats.completed);

  // Daily trend: for each day, fraction of expected habits completed
  final allDone = doneDateKeys(entries);
  final dailyRatios = <double>[];
  for (var i = 0; i < period.days; i++) {
    final day = from.add(Duration(days: i));
    if (day.isAfter(todayDate)) break;
    var expected = 0;
    var done = 0;
    for (final h in habits) {
      final ideal = idealDays(h, day, day);
      if (ideal > 0) {
        expected++;
        if (allDone.contains(dateKey(day)) &&
            (byHabit[h.id] ?? const [])
                .any((e) =>
                    dateKey(e.date) == dateKey(day) &&
                    (e.status == EntryStatus.done ||
                        e.status == EntryStatus.success))) {
          done++;
        }
      }
    }
    dailyRatios.add(expected == 0 ? 0.0 : done / expected);
  }

  return _OverallStats(
    perHabit: perHabit,
    avgCompletion: avgCompletion,
    totalCompleted: totalCompleted,
    bestHabit: perHabit.isEmpty ? null : perHabit.first,
    dailyRatios: dailyRatios,
  );
});

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(_periodProvider);
    final statsAsync = ref.watch(_statsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.statsTitle)),
      body: Column(
        children: [
          _PeriodBar(period: period),
          Expanded(
            child: statsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, _) => ErrorView(error: e),
              data: (stats) {
                if (stats.perHabit.isEmpty) {
                  return EmptyStateView(
                    emoji: '📊',
                    title: context.l10n.emptyStatsTitle,
                    subtitle: context.l10n.emptyStatsSubtitle,
                  );
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  children: [
                    _SummaryCards(stats: stats),
                    const SizedBox(height: 16),
                    _TrendChart(
                      ratios: stats.dailyRatios,
                      periodDays: period.days,
                    ),
                    const SizedBox(height: 16),
                    _HabitBreakdown(stats: stats),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Period selector
// ---------------------------------------------------------------------------

class _PeriodBar extends ConsumerWidget {
  const _PeriodBar({required this.period});
  final StatPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: StatPeriod.values.map((p) {
          final selected = p == period;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => ref.read(_periodProvider.notifier).set(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.primaryColor
                      : AppTheme.cardBackground,
                  borderRadius: AppTheme.chipRadius,
                  border: Border.all(
                    color: selected
                        ? AppTheme.primaryColor
                        : AppTheme.dividerColor,
                  ),
                ),
                child: Text(
                  p.label(context),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: selected ? Colors.white : AppTheme.textSecondary,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary cards
// ---------------------------------------------------------------------------

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.stats});
  final _OverallStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(
          emoji: '📊',
          value: '${(stats.avgCompletion * 100).round()}%',
          label: context.l10n.avgCompletion,
        ),
        const SizedBox(width: 10),
        _SummaryCard(
          emoji: '✅',
          value: '${stats.totalCompleted}',
          label: context.l10n.totalDone,
        ),
        const SizedBox(width: 10),
        _SummaryCard(
          emoji: '🏆',
          value: stats.bestHabit != null
              ? '${(stats.bestHabit!.stats.completionRate * 100).round()}%'
              : '—',
          label: stats.bestHabit?.habit.title ?? context.l10n.bestHabit,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.emoji,
    required this.value,
    required this.label,
  });
  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: AppTheme.cardRadius,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trend chart (daily completion ratio)
// ---------------------------------------------------------------------------

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.ratios, required this.periodDays});
  final List<double> ratios;
  final int periodDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.trendTitle,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.7,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ratios.isEmpty
                ? Center(child: Text(context.l10n.noData))
                : _BarRow(ratios: ratios),
          ),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({required this.ratios});
  final List<double> ratios;

  @override
  Widget build(BuildContext context) {
    // For long periods, aggregate to keep bars readable (<= ~31 bars).
    final display = _aggregate(ratios, 31);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: display.map((r) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: r <= 0 ? 0.03 : r,
                child: Container(
                  decoration: BoxDecoration(
                    color: r >= 0.999
                        ? const Color(0xFF43C59E)
                        : r > 0
                            ? AppTheme.primaryColor
                            : AppTheme.cardBackground,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(2)),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<double> _aggregate(List<double> src, int maxBars) {
    if (src.length <= maxBars) return src;
    final bucketSize = (src.length / maxBars).ceil();
    final out = <double>[];
    for (var i = 0; i < src.length; i += bucketSize) {
      final end = (i + bucketSize).clamp(0, src.length);
      final slice = src.sublist(i, end);
      out.add(slice.reduce((a, b) => a + b) / slice.length);
    }
    return out;
  }
}

// ---------------------------------------------------------------------------
// Per-habit breakdown
// ---------------------------------------------------------------------------

class _HabitBreakdown extends StatelessWidget {
  const _HabitBreakdown({required this.stats});
  final _OverallStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.byHabitTitle,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.7,
                ),
          ),
          const SizedBox(height: 12),
          ...stats.perHabit.map((s) => _HabitStatRow(stat: s)),
        ],
      ),
    );
  }
}

class _HabitStatRow extends StatelessWidget {
  const _HabitStatRow({required this.stat});
  final _HabitStat stat;

  @override
  Widget build(BuildContext context) {
    final habit = stat.habit;
    final pct = (stat.stats.completionRate * 100).round();

    return InkWell(
      borderRadius: AppTheme.chipRadius,
      onTap: () => context.push('/habits/detail', extra: habit),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  habit.visualType == VisualType.emoji
                      ? (habit.emoji ?? '⭐')
                      : '⭐',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    habit.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${stat.stats.completed}/${stat.stats.expected}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 38,
                  child: Text(
                    '$pct%',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: habit.color,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: stat.stats.completionRate,
                minHeight: 4,
                backgroundColor: AppTheme.cardBackground,
                color: habit.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _EmptyState removed — replaced by shared EmptyStateView.

