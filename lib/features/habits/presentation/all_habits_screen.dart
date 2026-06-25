import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/app/app_theme.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'package:habit_tracker/features/monetization/data/monetization_providers.dart';
import 'package:habit_tracker/shared/widgets/empty_state_view.dart';
import 'package:habit_tracker/shared/widgets/error_view.dart';
import 'package:habit_tracker/shared/widgets/skeleton_loader.dart';

// ---------------------------------------------------------------------------
// Filter state
// ---------------------------------------------------------------------------

enum _StatusFilter { active, inactive, all }

enum _KindFilter { all, positive, negative }

class _FilterState {
  const _FilterState({
    this.status = _StatusFilter.active,
    this.kind = _KindFilter.all,
    this.searchQuery = '',
  });
  final _StatusFilter status;
  final _KindFilter kind;
  final String searchQuery;

  _FilterState copyWith({
    _StatusFilter? status,
    _KindFilter? kind,
    String? searchQuery,
  }) =>
      _FilterState(
        status: status ?? this.status,
        kind: kind ?? this.kind,
        searchQuery: searchQuery ?? this.searchQuery,
      );
}

class _FilterNotifier extends Notifier<_FilterState> {
  @override
  _FilterState build() => const _FilterState();

  void set(_FilterState s) => state = s;
}

final _filterProvider =
    NotifierProvider<_FilterNotifier, _FilterState>(_FilterNotifier.new);

// ---------------------------------------------------------------------------
// Habits list provider (filtered + sorted)
// ---------------------------------------------------------------------------

final _allHabitsProvider = FutureProvider.autoDispose<List<Habit>>((ref) async {
  final repo = ref.watch(habitsRepositoryProvider);
  final filter = ref.watch(_filterProvider);
  final all = await repo.getAll();

  return all.where((h) {
    if (filter.status == _StatusFilter.active && !h.isActive) { return false; }
    if (filter.status == _StatusFilter.inactive && h.isActive) { return false; }
    if (filter.kind == _KindFilter.positive &&
        h.habitKind != HabitKind.positive) { return false; }
    if (filter.kind == _KindFilter.negative &&
        h.habitKind != HabitKind.negative) { return false; }
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!h.title.toLowerCase().contains(q)) return false;
    }
    return true;
  }).toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
});

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class AllHabitsScreen extends ConsumerStatefulWidget {
  const AllHabitsScreen({super.key});

  @override
  ConsumerState<AllHabitsScreen> createState() => _AllHabitsScreenState();
}

class _AllHabitsScreenState extends ConsumerState<AllHabitsScreen> {
  bool _searching = false;
  final _searchCtrl = TextEditingController();
  bool _reordering = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(_filterProvider);
    final habitsAsync = ref.watch(_allHabitsProvider);
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: _buildAppBar(filter),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner ad stub (free users)
          if (!isPremium) const _BannerAdStub(),

          // Filter chips
          _FilterBar(filter: filter),

          // Habit list
          Expanded(
            child: habitsAsync.when(
              loading: () => ListView.builder(
                itemCount: 5,
                itemBuilder: (_, _) => const HabitCardSkeleton(),
              ),
              error: (e, _) => ErrorView(error: e),
              data: (habits) => habits.isEmpty
                  ? const EmptyStateView(
                      emoji: '📋',
                      title: 'Привычек нет',
                      subtitle: 'Создайте первую привычку, нажав +',
                    )
                  : _reordering
                      ? _ReorderList(
                          habits: habits,
                          isPremium: isPremium,
                          onReorder: _onReorder,
                          onStopReorder: () =>
                              setState(() => _reordering = false),
                        )
                      : _HabitList(
                          habits: habits,
                          isPremium: isPremium,
                        ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(_FilterState filter) {
    if (_searching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() => _searching = false);
            _searchCtrl.clear();
            ref.read(_filterProvider.notifier).set(
                filter.copyWith(searchQuery: ''));
          },
        ),
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          decoration: const InputDecoration.collapsed(
            hintText: 'Поиск привычек…',
          ),
          onChanged: (v) => ref.read(_filterProvider.notifier).set(
              filter.copyWith(searchQuery: v)),
        ),
      );
    }

    return AppBar(
      title: const Text('Все привычки'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () => setState(() => _searching = true),
        ),
        IconButton(
          icon: Icon(
            _reordering ? Icons.check : Icons.swap_vert,
            color: _reordering ? AppTheme.primaryColor : null,
          ),
          tooltip: _reordering ? 'Готово' : 'Сортировать',
          onPressed: () => setState(() => _reordering = !_reordering),
        ),
      ],
    );
  }

  Future<void> _onReorder(List<Habit> reordered) async {
    final repo = ref.read(habitsRepositoryProvider);
    for (int i = 0; i < reordered.length; i++) {
      await repo.update(reordered[i].copyWith(sortOrder: i));
    }
    ref.invalidate(_allHabitsProvider);
  }
}

// ---------------------------------------------------------------------------
// Filter bar
// ---------------------------------------------------------------------------

class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.filter});
  final _FilterState filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          // Status filter
          _Chip(
            label: 'Активные',
            selected: filter.status == _StatusFilter.active,
            onTap: () => ref.read(_filterProvider.notifier).set(
                filter.copyWith(status: _StatusFilter.active)),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'Неактивные',
            selected: filter.status == _StatusFilter.inactive,
            onTap: () => ref.read(_filterProvider.notifier).set(
                filter.copyWith(status: _StatusFilter.inactive)),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'Все',
            selected: filter.status == _StatusFilter.all,
            onTap: () => ref.read(_filterProvider.notifier).set(
                filter.copyWith(status: _StatusFilter.all)),
          ),
          const SizedBox(width: 16),
          _Chip(
            label: 'Позитивные',
            selected: filter.kind == _KindFilter.positive,
            onTap: () => ref.read(_filterProvider.notifier).set(
                filter.copyWith(kind: _KindFilter.positive)),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'Негативные',
            selected: filter.kind == _KindFilter.negative,
            onTap: () => ref.read(_filterProvider.notifier).set(
                filter.copyWith(kind: _KindFilter.negative)),
          ),
          if (filter.kind != _KindFilter.all) ...[
            const SizedBox(width: 8),
            _Chip(
              label: '✕',
              selected: false,
              onTap: () => ref.read(_filterProvider.notifier).set(
                  filter.copyWith(kind: _KindFilter.all)),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Regular list
// ---------------------------------------------------------------------------

class _HabitList extends StatelessWidget {
  const _HabitList({required this.habits, required this.isPremium});
  final List<Habit> habits;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    // Insert native ad every 5 habits for free users
    final items = <_ListItem>[];
    for (int i = 0; i < habits.length; i++) {
      items.add(_ListItem.habit(habits[i]));
      if (!isPremium && (i + 1) % 5 == 0 && i < habits.length - 1) {
        items.add(const _ListItem.nativeAd());
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final item = items[i];
        if (item.isAd) return const _NativeAdStub();
        return _HabitRow(habit: item.habit!);
      },
    );
  }
}

class _ListItem {
  const _ListItem.habit(this.habit) : isAd = false;
  const _ListItem.nativeAd()
      : habit = null,
        isAd = true;
  final Habit? habit;
  final bool isAd;
}

// ---------------------------------------------------------------------------
// Reorder list
// ---------------------------------------------------------------------------

class _ReorderList extends StatefulWidget {
  const _ReorderList({
    required this.habits,
    required this.isPremium,
    required this.onReorder,
    required this.onStopReorder,
  });
  final List<Habit> habits;
  final bool isPremium;
  final Future<void> Function(List<Habit>) onReorder;
  final VoidCallback onStopReorder;

  @override
  State<_ReorderList> createState() => _ReorderListState();
}

class _ReorderListState extends State<_ReorderList> {
  late List<Habit> _habits;

  @override
  void initState() {
    super.initState();
    _habits = List.of(widget.habits);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Перетащите для изменения порядка',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.textSecondary),
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            itemCount: _habits.length,
            onReorder: (oldIdx, newIdx) {
              setState(() {
                if (newIdx > oldIdx) newIdx -= 1;
                final h = _habits.removeAt(oldIdx);
                _habits.insert(newIdx, h);
              });
              widget.onReorder(_habits);
            },
            itemBuilder: (_, i) => _HabitRow(
              key: ValueKey(_habits[i].id),
              habit: _habits[i],
              trailing: const Icon(
                Icons.drag_handle,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Habit row card
// ---------------------------------------------------------------------------

class _HabitRow extends StatelessWidget {
  const _HabitRow({super.key, required this.habit, this.trailing});
  final Habit habit;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: AppTheme.cardRadius,
      onTap: () => context.push('/habits/detail', extra: habit),
      onLongPress: () => context.push('/habits/edit', extra: habit),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppTheme.cardRadius,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Color stripe
            Container(
              width: 4,
              height: 38,
              decoration: BoxDecoration(
                color: habit.isActive
                    ? habit.color
                    : AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Visual
            _HabitVisual(habit: habit),
            const SizedBox(width: 12),
            // Title + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: habit.isActive ? null : AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    _meta(habit),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ] else
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppTheme.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  String _meta(Habit h) {
    final parts = <String>[];
    parts.add(h.habitKind == HabitKind.positive ? 'Позитивная' : 'Негативная');
    parts.add(_repeatShort(h.repeatType));
    if (!h.isActive) parts.add('Неактивна');
    return parts.join(' · ');
  }

  String _repeatShort(RepeatType rt) => switch (rt) {
        RepeatType.everyDay => 'Каждый день',
        RepeatType.selectedWeekdays => 'По дням',
        RepeatType.everyNDays => 'Через N дней',
        RepeatType.nTimesPerNDays => 'N раз за N дней',
      };
}

class _HabitVisual extends StatelessWidget {
  const _HabitVisual({required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    const size = 36.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: habit.color.withValues(alpha: habit.isActive ? 0.15 : 0.06),
        borderRadius: AppTheme.chipRadius,
      ),
      child: Center(
        child: habit.visualType == VisualType.emoji
            ? Text(
                habit.emoji ?? '⭐',
                style: const TextStyle(fontSize: 18),
              )
            : Icon(Icons.star_outline, size: 18, color: habit.color),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ad stubs  (ponytail: real ads wired in Этап 12)
// ---------------------------------------------------------------------------

class _BannerAdStub extends StatelessWidget {
  const _BannerAdStub();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: AppTheme.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.ad_units_outlined,
              size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Text(
            'Реклама · Убрать → Premium',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _NativeAdStub extends StatelessWidget {
  const _NativeAdStub();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.ad_units_outlined,
              size: 14, color: AppTheme.textSecondary),
          const SizedBox(width: 6),
          Text(
            'Нативная реклама',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

// _EmptyState removed — replaced by shared EmptyStateView.

// ---------------------------------------------------------------------------
// Chip helper
// ---------------------------------------------------------------------------

class _Chip extends StatelessWidget {
  const _Chip({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
