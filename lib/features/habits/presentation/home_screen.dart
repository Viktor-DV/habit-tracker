import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/app/app_theme.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/core/time/habit_day_resolver.dart';
import 'package:habit_tracker/core/time/repeat_rule_evaluator.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'package:habit_tracker/features/habits/presentation/entry_saver.dart'
    as es;
import 'package:habit_tracker/features/notifications/data/notification_providers.dart';
import 'package:habit_tracker/features/notifications/presentation/permission_banner.dart';
import 'package:habit_tracker/features/monetization/domain/ads_repository.dart';
import 'package:habit_tracker/features/monetization/presentation/ad_widgets.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';
import 'package:habit_tracker/l10n/l10n.dart';
import 'package:habit_tracker/l10n/l10n_date.dart';
import 'package:habit_tracker/shared/widgets/adaptive_content.dart';
import 'package:habit_tracker/shared/widgets/empty_state_view.dart';
import 'package:habit_tracker/shared/widgets/error_view.dart';
import 'package:habit_tracker/shared/widgets/skeleton_loader.dart';

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Logical "today" considering dayStart setting.
final todayProvider = Provider<DateTime>((ref) {
  final s = ref.watch(settingsProvider);
  return todayHabitDay(
    dayStartHour: s.dayStartHour,
    dayStartMinute: s.dayStartMinute,
  );
});

/// User-selected date on the home calendar.
class _SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => ref.read(todayProvider);

  void set(DateTime date) => state = date;
}

final selectedDateProvider =
    NotifierProvider<_SelectedDateNotifier, DateTime>(_SelectedDateNotifier.new);

class _DayItem {
  const _DayItem(this.habit, this.entry);
  final Habit habit;
  final HabitEntry? entry;
}

/// Habits expected on the [selectedDate], with their entries.
final dayHabitsProvider =
    FutureProvider.autoDispose<List<_DayItem>>((ref) async {
  ref.watch(habitsRevisionProvider);
  final date = ref.watch(selectedDateProvider);
  final repo = ref.watch(habitsRepositoryProvider);
  final all = await repo.getAll();
  final expected = all
      .where((h) => h.isActive && isExpectedOn(h, date))
      .toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  final result = <_DayItem>[];
  for (final h in expected) {
    final entry = await repo.getEntryForDate(h.id, date);
    result.add(_DayItem(h, entry));
  }
  return result;
});

/// Day status aggregation for the calendar (keyed by ISO date string).
enum _DayStatus { allDone, partial, noneDone, noHabits }

/// Data for one visible calendar month.
class _MonthData {
  const _MonthData(this.statusByDate);
  final Map<String, _DayStatus> statusByDate;
}

final _monthDataProvider = FutureProvider.autoDispose
    .family<_MonthData, DateTime>((ref, firstOfMonth) async {
  ref.watch(habitsRevisionProvider);
  final repo = ref.watch(habitsRepositoryProvider);
  final today = ref.watch(todayProvider);
  final habits = await repo.getAll();
  final activeHabits = habits.where((h) => h.isActive).toList();

  final lastOfMonth = DateTime(firstOfMonth.year, firstOfMonth.month + 1, 0);
  final entries = await repo.getEntriesForRange(firstOfMonth, lastOfMonth);

  // Group entries by date string
  final entriesByDate = <String, List<HabitEntry>>{};
  for (final e in entries) {
    entriesByDate.putIfAbsent(_ds(e.date), () => []).add(e);
  }

  final statusByDate = <String, _DayStatus>{};
  var cursor = firstOfMonth;
  while (!cursor.isAfter(lastOfMonth)) {
    if (!cursor.isAfter(today)) {
      final expected =
          activeHabits.where((h) => isExpectedOn(h, cursor)).toList();
      if (expected.isEmpty) {
        statusByDate[_ds(cursor)] = _DayStatus.noHabits;
      } else {
        final dateKey = _ds(cursor);
        final dayEntries = entriesByDate[dateKey] ?? [];
        final doneIds = dayEntries
            .where((e) =>
                e.status == EntryStatus.done || e.status == EntryStatus.success)
            .map((e) => e.habitId)
            .toSet();
        final doneCount =
            expected.where((h) => doneIds.contains(h.id)).length;
        if (doneCount == 0) {
          statusByDate[dateKey] = _DayStatus.noneDone;
        } else if (doneCount == expected.length) {
          statusByDate[dateKey] = _DayStatus.allDone;
        } else {
          statusByDate[dateKey] = _DayStatus.partial;
        }
      }
    }
    cursor = cursor.add(const Duration(days: 1));
  }
  return _MonthData(statusByDate);
});

String _ds(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.highlightHabitId});
  final int? highlightHabitId;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late DateTime _visibleMonth;
  bool _showAllActive = false;

  @override
  void initState() {
    super.initState();
    final today = ref.read(todayProvider);
    _visibleMonth = DateTime(today.year, today.month);
  }

  void _prevMonth() =>
      setState(() => _visibleMonth =
          DateTime(_visibleMonth.year, _visibleMonth.month - 1));

  void _nextMonth() =>
      setState(() => _visibleMonth =
          DateTime(_visibleMonth.year, _visibleMonth.month + 1));

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = ref.watch(todayProvider);
    final monthAsync = ref.watch(_monthDataProvider(_visibleMonth));
    // habitId from a tapped notification (cleared once shown).
    final highlightId =
        widget.highlightHabitId ?? ref.watch(notificationHighlightProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_outlined),
            tooltip: context.l10n.today,
            onPressed: () {
              setState(() => _visibleMonth = DateTime(today.year, today.month));
              ref.read(selectedDateProvider.notifier).set(today);
            }, // notifier.state is valid for Notifier subclasses
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Top banner ad
          SliverToBoxAdapter(
            child: YandexBannerAd(unitId: kBannerUnit.unitId),
          ),
          const SliverToBoxAdapter(child: PermissionBanner()),
          // ── Calendar ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _MonthCalendar(
              visibleMonth: _visibleMonth,
              selectedDate: selectedDate,
              today: today,
              monthData: monthAsync.asData?.value,
              onPrev: _prevMonth,
              onNext: _nextMonth,
              onSelectDate: (d) {
                ref.read(selectedDateProvider.notifier).set(d);
                if (d.month != _visibleMonth.month) {
                  setState(
                    () => _visibleMonth = DateTime(d.year, d.month),
                  );
                }
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Day header + filter ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatDate(context, selectedDate, today),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _FilterChip(
                    label: context.l10n.filterAllActive,
                    selected: _showAllActive,
                    onTap: () =>
                        setState(() => _showAllActive = !_showAllActive),
                  ),
                ],
              ),
            ),
          ),

          // ── Habit list ────────────────────────────────────────────────────
          _showAllActive
              ? _AllActiveHabitsList(selectedDate: selectedDate)
              : _DayHabitsList(
                  highlightHabitId: highlightId,
                ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime d, DateTime today) {
    if (_ds(d) == _ds(today)) return context.l10n.today;
    if (_ds(d) == _ds(today.subtract(const Duration(days: 1)))) {
      return context.l10n.yesterday;
    }
    if (_ds(d) == _ds(today.add(const Duration(days: 1)))) {
      return context.l10n.tomorrow;
    }
    return '${d.day} ${monthShort(context, d)}';
  }
}

// ---------------------------------------------------------------------------
// Month calendar widget
// ---------------------------------------------------------------------------

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.visibleMonth,
    required this.selectedDate,
    required this.today,
    required this.monthData,
    required this.onPrev,
    required this.onNext,
    required this.onSelectDate,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final DateTime today;
  final _MonthData? monthData;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cells = _buildCells();
    final weekLabels = [
      for (var i = 0; i < 7; i++) weekdayShort(context, i),
    ];

    return Container(
      color: AppTheme.surfaceColor,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onPrev,
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Text(
                  '${monthLong(context, visibleMonth)} ${visibleMonth.year}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: onNext,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          // Week day labels
          Row(
            children: weekLabels
                .map(
                  (l) => Expanded(
                    child: Center(
                      child: Text(
                        l,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 4),
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemCount: cells.length,
            itemBuilder: (_, i) => _DayCell(
              cell: cells[i],
              selectedDate: selectedDate,
              today: today,
              monthData: monthData,
              onTap: cells[i].date != null ? () => onSelectDate(cells[i].date!) : null,
            ),
          ),
        ],
      ),
    );
  }

  List<_Cell> _buildCells() {
    final first = DateTime(visibleMonth.year, visibleMonth.month, 1);
    // weekday: 1=Mon…7=Sun — offset for Monday-first grid
    final startOffset = first.weekday - 1;
    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final totalCells = ((startOffset + daysInMonth) / 7).ceil() * 7;

    return List.generate(totalCells, (i) {
      final dayNum = i - startOffset + 1;
      if (dayNum < 1 || dayNum > daysInMonth) return const _Cell(null);
      return _Cell(DateTime(visibleMonth.year, visibleMonth.month, dayNum));
    });
  }
}

class _Cell {
  const _Cell(this.date);
  final DateTime? date;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.cell,
    required this.selectedDate,
    required this.today,
    required this.monthData,
    required this.onTap,
  });

  final _Cell cell;
  final DateTime selectedDate;
  final DateTime today;
  final _MonthData? monthData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (cell.date == null) return const SizedBox.shrink();

    final date = cell.date!;
    final dateStr = _ds(date);
    final isSelected = dateStr == _ds(selectedDate);
    final isToday = dateStr == _ds(today);
    final isFuture = date.isAfter(today);
    final status = monthData?.statusByDate[dateStr];

    Color bgColor = Colors.transparent;
    Color textColor = Theme.of(context).colorScheme.onSurface;

    if (isSelected) {
      bgColor = AppTheme.primaryColor;
      textColor = Colors.white;
    } else if (isToday) {
      bgColor = AppTheme.primaryColor.withValues(alpha: 0.12);
      textColor = AppTheme.primaryColor;
    }

    final dotColor = _dotColor(status, isFuture, isSelected);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppTheme.chipRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isToday || isSelected ? FontWeight.w600 : FontWeight.w400,
                color: textColor,
              ),
            ),
            if (dotColor != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white70 : dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color? _dotColor(_DayStatus? status, bool isFuture, bool isSelected) {
    if (isFuture || status == null) return null;
    return switch (status) {
      _DayStatus.allDone => const Color(0xFF43C59E),
      _DayStatus.partial => const Color(0xFFF59E0B),
      _DayStatus.noneDone => const Color(0xFFE3E2E0),
      _DayStatus.noHabits => null,
    };
  }
}

// ---------------------------------------------------------------------------
// Day habit list
// ---------------------------------------------------------------------------

class _DayHabitsList extends ConsumerWidget {
  const _DayHabitsList({this.highlightHabitId});
  final int? highlightHabitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dayHabitsProvider);

    return async.when(
      loading: () => const SliverSkeletonList(),
      error: (e, _) => SliverErrorView(error: e),
      data: (items) {
        if (items.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyStateView(
                emoji: '🌿',
                title: context.l10n.emptyNoHabitsTitle,
                subtitle: context.l10n.emptyNoHabitsSubtitle,
              ),
            );
        }
        return SliverAdaptiveContent(
          sliver: SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _HabitCard(
                item: items[i],
                highlighted: items[i].habit.id == highlightHabitId,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// All-active list (filter mode)
// ---------------------------------------------------------------------------

class _AllActiveHabitsList extends ConsumerWidget {
  const _AllActiveHabitsList({required this.selectedDate});
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_allActiveProvider);

    return async.when(
      loading: () => const SliverSkeletonList(),
      error: (e, _) => SliverErrorView(error: e),
      data: (habits) {
        if (habits.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(
              emoji: '🌿',
              title: context.l10n.emptyNoActiveTitle,
              subtitle: context.l10n.emptyNoActiveSubtitle,
            ),
          );
        }
        return SliverAdaptiveContent(
          sliver: SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            sliver: SliverList.separated(
              itemCount: habits.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _HabitCardSimple(habit: habits[i]),
            ),
          ),
        );
      },
    );
  }
}

final _allActiveProvider = FutureProvider.autoDispose<List<Habit>>((ref) async {
  ref.watch(habitsRevisionProvider);
  final repo = ref.watch(habitsRepositoryProvider);
  final all = await repo.getAll();
  return all.where((h) => h.isActive).toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
});

// ---------------------------------------------------------------------------
// Habit card — full interaction per Этап 7
// ---------------------------------------------------------------------------

/// Saves / upserts an entry for the currently selected date.
Future<void> _saveEntry(
  WidgetRef ref,
  Habit habit,
  HabitEntry? existing, {
  required EntryStatus status,
  double? value,
}) {
  final date = ref.read(selectedDateProvider);
  return es.saveEntry(
    ref, habit, existing, date,
    status: status,
    value: value,
      onInvalidate: () {
        ref.read(habitsRevisionProvider.notifier).bump();
        ref.invalidate(dayHabitsProvider);
        ref.invalidate(_monthDataProvider(DateTime(date.year, date.month)));
      // Reschedule so completed habits stop reminding today.
      ref
          .read(notificationOrchestratorProvider)
          .rebuild(ref.read(settingsProvider));
    },
  );
}

class _HabitCard extends ConsumerWidget {
  const _HabitCard({required this.item, this.highlighted = false});
  final _DayItem item;
  final bool highlighted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habit = item.habit;
    final entry = item.entry;
    final ct = habit.completionType;
    final isQuantityOrTime =
        ct == CompletionType.quantity || ct == CompletionType.time;
    final isNegative = habit.habitKind == HabitKind.negative;
    final isDone = entry?.status == EntryStatus.done ||
        entry?.status == EntryStatus.success;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: highlighted
            ? AppTheme.primaryColor.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(
          color: highlighted ? AppTheme.primaryColor : AppTheme.dividerColor,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: AppTheme.cardRadius,
        onLongPress: () => context.push('/habits/edit', extra: habit),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: stripe + visual + title + (yesNo button) ──────────
              Row(
                children: [
                  _stripe(habit.color, 36),
                  const SizedBox(width: 12),
                  _HabitVisual(habit: habit, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      habit.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                decoration: isDone && !isQuantityOrTime
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: isDone && !isQuantityOrTime
                                    ? AppTheme.textSecondary
                                    : null,
                              ),
                    ),
                  ),
                  if (!isQuantityOrTime && !isNegative)
                    _YesNoButton(habit: habit, entry: entry, ref: ref),
                ],
              ),

              // ── Bottom row: quantity / negative controls ──────────────────
              if (isQuantityOrTime) ...[
                const SizedBox(height: 10),
                _QuantityRow(item: item, ref: ref),
              ],
              if (isNegative) ...[
                const SizedBox(height: 10),
                _NegativeRow(item: item, ref: ref),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _stripe(Color c, double h) => Container(
        width: 4,
        height: h,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

// ---------------------------------------------------------------------------
// Yes / No button (one-directional: tap = done, long-press = undo/skip)
// ---------------------------------------------------------------------------

class _YesNoButton extends ConsumerWidget {
  const _YesNoButton({
    required this.habit,
    required this.entry,
    required this.ref,
  });
  final Habit habit;
  final HabitEntry? entry;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef r) {
    final isDone = entry?.status == EntryStatus.done;
    final isSkipped = entry?.status == EntryStatus.skipped;

    return GestureDetector(
      // Tap = mark done (no-op if already done)
      onTap: isDone
          ? null
          : () => _saveEntry(ref, habit, entry, status: EntryStatus.done),
      onLongPress: () => _showResetSheet(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDone
              ? habit.color
              : isSkipped
                  ? AppTheme.cardBackground
                  : Colors.transparent,
          borderRadius: AppTheme.chipRadius,
          border: Border.all(
            color: isDone
                ? habit.color
                : isSkipped
                    ? AppTheme.dividerColor
                    : AppTheme.dividerColor,
            width: 1.5,
          ),
        ),
        child: isDone
            ? const Icon(Icons.check, size: 20, color: Colors.white)
            : isSkipped
                ? Icon(Icons.remove,
                    size: 18, color: AppTheme.textSecondary)
                : null,
      ),
    );
  }

  Future<void> _showResetSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: Text(context.l10n.resetSkip),
              onTap: () => Navigator.pop(context, 'skip'),
            ),
            ListTile(
              leading: const Icon(Icons.undo),
              title: Text(context.l10n.resetReset),
              onTap: () => Navigator.pop(context, 'reset'),
            ),
          ],
        ),
      ),
    );
    if (result == 'skip') {
      await _saveEntry(ref, habit, entry, status: EntryStatus.skipped);
    } else if (result == 'reset') {
      final repo = ref.read(habitsRepositoryProvider);
      if (entry != null && entry!.id != 0) await repo.deleteEntry(entry!.id);
      ref.read(habitsRevisionProvider.notifier).bump();
      ref.invalidate(dayHabitsProvider);
      final date = ref.read(selectedDateProvider);
      ref.invalidate(_monthDataProvider(DateTime(date.year, date.month)));
    }
  }
}

// ---------------------------------------------------------------------------
// Quantity / Time row
// ---------------------------------------------------------------------------

class _QuantityRow extends ConsumerStatefulWidget {
  const _QuantityRow({required this.item, required this.ref});
  final _DayItem item;
  final WidgetRef ref;

  @override
  ConsumerState<_QuantityRow> createState() => _QuantityRowState();
}

class _QuantityRowState extends ConsumerState<_QuantityRow> {
  // Local optimistic value (avoids waiting for DB round-trip)
  late double _localValue;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _localValue = widget.item.entry?.value ?? 0.0;
  }

  @override
  void didUpdateWidget(_QuantityRow old) {
    super.didUpdateWidget(old);
    if (widget.item.entry?.value != old.item.entry?.value) {
      _localValue = widget.item.entry?.value ?? 0.0;
    }
  }

  Habit get habit => widget.item.habit;
  HabitEntry? get entry => widget.item.entry;
  double get target => habit.targetValue ?? 0.0;
  String get unit => habit.targetUnit ?? '';
  bool get hasTarget => target > 0;
  bool get isAtOrAboveTarget => hasTarget && _localValue >= target;

  Future<void> _commit(double v) async {
    if (_saving) return;
    setState(() {
      _localValue = v < 0 ? 0 : v;
      _saving = true;
    });
    final status =
        hasTarget && _localValue >= target ? EntryStatus.done : EntryStatus.skipped;
    await _saveEntry(
      widget.ref,
      habit,
      entry,
      status: status,
      value: _localValue,
    );
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _enterExact(BuildContext context) async {
    final ctrl = TextEditingController(
      text: _localValue > 0 ? _fmtV(_localValue) : '',
    );
    final result = await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(habit.title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: context.l10n.quantityValueHint,
            suffixText: unit,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final v = double.tryParse(ctrl.text.replaceAll(',', '.'));
              if (v != null) Navigator.pop(context, v);
            },
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
    if (result != null) await _commit(result);
  }

  @override
  Widget build(BuildContext context) {
    final progressPct = hasTarget ? (_localValue / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        if (hasTarget)
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progressPct,
              minHeight: 3,
              backgroundColor: AppTheme.cardBackground,
              color: isAtOrAboveTarget ? habit.color : AppTheme.primaryColor,
            ),
          ),
        const SizedBox(height: 8),
        // Controls
        Row(
          children: [
            // −
            _StepBtn(
              icon: Icons.remove,
              onTap: _localValue > 0 ? () => _commit(_localValue - 1) : null,
            ),
            const SizedBox(width: 8),
            // Value display (tap to enter exact)
            GestureDetector(
              onTap: () => _enterExact(context),
              child: Container(
                constraints: const BoxConstraints(minWidth: 72),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isAtOrAboveTarget
                      ? habit.color.withValues(alpha: 0.12)
                      : AppTheme.cardBackground,
                  borderRadius: AppTheme.chipRadius,
                  border: Border.all(
                    color: isAtOrAboveTarget
                        ? habit.color
                        : AppTheme.dividerColor,
                  ),
                ),
                child: Text(
                  hasTarget
                      ? '${_fmtV(_localValue)} / ${_fmtV(target)} $unit'
                      : '${_fmtV(_localValue)} $unit',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isAtOrAboveTarget
                            ? habit.color
                            : null,
                        fontWeight: isAtOrAboveTarget
                            ? FontWeight.w600
                            : null,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // +
            _StepBtn(
              icon: Icons.add,
              onTap: () => _commit(_localValue + 1),
            ),
            const Spacer(),
            // ✓ button — set to target or mark done
            if (hasTarget)
              GestureDetector(
                onTap: isAtOrAboveTarget
                    ? null
                    : () => _commit(target),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isAtOrAboveTarget ? habit.color : Colors.transparent,
                    borderRadius: AppTheme.chipRadius,
                    border: Border.all(
                      color: isAtOrAboveTarget
                          ? habit.color
                          : AppTheme.dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 18,
                    color: isAtOrAboveTarget
                        ? Colors.white
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _fmtV(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: AppTheme.chipRadius,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? AppTheme.dividerColor : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Negative habit row: ✓ Успех | ✗ Срыв | — Пропуск
// ---------------------------------------------------------------------------

class _NegativeRow extends ConsumerWidget {
  const _NegativeRow({required this.item, required this.ref});
  final _DayItem item;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef r) {
    final habit = item.habit;
    final currentStatus = item.entry?.status;

    return Row(
      children: [
        _NegBtn(
          label: context.l10n.negSuccess,
          icon: Icons.check,
          activeColor: const Color(0xFF43C59E),
          isActive: currentStatus == EntryStatus.success,
          onTap: () => _saveEntry(ref, habit, item.entry,
              status: EntryStatus.success),
        ),
        const SizedBox(width: 8),
        _NegBtn(
          label: context.l10n.negFailure,
          icon: Icons.close,
          activeColor: const Color(0xFFF44336),
          isActive: currentStatus == EntryStatus.failure,
          onTap: () => _saveEntry(ref, habit, item.entry,
              status: EntryStatus.failure),
        ),
        const SizedBox(width: 8),
        _NegBtn(
          label: context.l10n.negSkip,
          icon: Icons.remove,
          activeColor: AppTheme.textSecondary,
          isActive: currentStatus == EntryStatus.skipped,
          onTap: () => _saveEntry(ref, habit, item.entry,
              status: EntryStatus.skipped),
        ),
      ],
    );
  }
}

class _NegBtn extends StatelessWidget {
  const _NegBtn({
    required this.label,
    required this.icon,
    required this.activeColor,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color activeColor;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.12) : AppTheme.cardBackground,
          borderRadius: AppTheme.chipRadius,
          border: Border.all(
            color: isActive ? activeColor : AppTheme.dividerColor,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14,
                color: isActive ? activeColor : AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive ? activeColor : AppTheme.textSecondary,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCardSimple extends StatelessWidget {
  const _HabitCardSimple({required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: InkWell(
        borderRadius: AppTheme.cardRadius,
        onLongPress: () => context.push('/habits/edit', extra: habit),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: habit.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              _HabitVisual(habit: habit, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  habit.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, size: 18, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Habit visual (emoji or icon)
// ---------------------------------------------------------------------------

class _HabitVisual extends StatelessWidget {
  const _HabitVisual({required this.habit, required this.size});
  final Habit habit;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: habit.color.withValues(alpha: 0.15),
        borderRadius: AppTheme.chipRadius,
      ),
      child: Center(
        child: habit.visualType == VisualType.emoji
            ? Text(
                habit.emoji ?? '⭐',
                style: TextStyle(fontSize: size * 0.55),
              )
            : Icon(
                _iconData(habit.iconName),
                size: size * 0.55,
                color: habit.color,
              ),
      ),
    );
  }

  IconData _iconData(String? name) => const {
        'star': Icons.star_outline,
        'check': Icons.check_circle_outline,
        'fitness': Icons.fitness_center,
        'water': Icons.water_drop_outlined,
        'book': Icons.menu_book_outlined,
        'run': Icons.directions_run,
        'heart': Icons.favorite_outline,
        'moon': Icons.nightlight_outlined,
        'sun': Icons.wb_sunny_outlined,
        'target': Icons.adjust,
        'timer': Icons.timer_outlined,
        'food': Icons.restaurant_outlined,
        'music': Icons.music_note_outlined,
        'code': Icons.code,
        'pen': Icons.edit_outlined,
        'leaf': Icons.eco_outlined,
        'brain': Icons.psychology_outlined,
        'wallet': Icons.account_balance_wallet_outlined,
        'phone': Icons.phone_iphone_outlined,
        'sleep': Icons.hotel_outlined,
      }[name] ??
      Icons.star_outline;
}

// _EmptyDay removed — replaced by shared EmptyStateView.

// ---------------------------------------------------------------------------
// Filter chip
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor.withValues(alpha: 0.12)
              : AppTheme.cardBackground,
          borderRadius: AppTheme.chipRadius,
          border: Border.all(
            color: selected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color:
                    selected ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
