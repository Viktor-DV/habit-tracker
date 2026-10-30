import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/app/app_theme.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'package:habit_tracker/features/habits/domain/habit_templates.dart';
import 'package:habit_tracker/features/notifications/data/notification_providers.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';
import 'package:habit_tracker/l10n/l10n.dart';
import 'package:habit_tracker/l10n/l10n_date.dart';

// ---------------------------------------------------------------------------
// Palette & icons available for selection
// ---------------------------------------------------------------------------

const _kColors = [
  Color(0xFF2383E2), Color(0xFFE84393), Color(0xFF43C59E),
  Color(0xFFF59E0B), Color(0xFF6C63FF), Color(0xFFFF6B35),
  Color(0xFF4CAF50), Color(0xFF00BCD4), Color(0xFF9C27B0),
  Color(0xFF8D6E63), Color(0xFF9E9E9E), Color(0xFFF44336),
];

const _kIcons = <String, IconData>{
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
};

// ---------------------------------------------------------------------------
// Form data
// ---------------------------------------------------------------------------

class _FormData {
  String title = '';
  String? description;
  VisualType visualType = VisualType.emoji;
  String emoji = '⭐';
  String iconName = 'star';
  Color color = _kColors[0];
  HabitKind habitKind = HabitKind.positive;
  CompletionType completionType = CompletionType.yesNo;
  double? targetValue;
  String? targetUnit;
  RepeatType repeatType = RepeatType.everyDay;
  List<int> repeatWeekdays = [1, 2, 3, 4, 5]; // Mon–Fri default
  int repeatInterval = 2;
  int repeatGoalCount = 3;
  int repeatPeriodDays = 7;
  DateTime repeatStartDate = DateTime.now();
  NotificationMode notificationMode = NotificationMode.dailySummary;
  List<String> notificationTimes = [];
  bool timerEnabled = false;

  void applyTemplate(HabitTemplate t) {
    title = t.title;
    description = t.description;
    visualType = VisualType.emoji;
    emoji = t.emoji;
    color = t.color;
    habitKind = t.habitKind;
    completionType = t.completionType;
    targetValue = t.targetValue;
    targetUnit = t.targetUnit;
    repeatType = t.repeatType;
  }

  void applyHabit(Habit h) {
    title = h.title;
    description = h.description;
    visualType = h.visualType;
    emoji = h.emoji ?? '⭐';
    iconName = h.iconName ?? 'star';
    color = h.color;
    habitKind = h.habitKind;
    completionType = h.completionType;
    targetValue = h.targetValue;
    targetUnit = h.targetUnit;
    repeatType = h.repeatType;
    repeatWeekdays = List.of(h.repeatWeekdays);
    repeatInterval = h.repeatInterval ?? 2;
    repeatGoalCount = h.repeatGoalCount ?? 3;
    repeatPeriodDays = h.repeatPeriodDays ?? 7;
    repeatStartDate = h.repeatStartDate;
    notificationMode = h.notificationMode;
    notificationTimes = List.of(h.notificationTimes);
    timerEnabled = h.timerEnabled;
  }

  Habit toHabit({int id = 0}) => Habit(
        id: id,
        title: title.trim(),
        description: description?.trim().isEmpty == true ? null : description?.trim(),
        habitKind: habitKind,
        completionType: completionType,
        visualType: visualType,
        emoji: visualType == VisualType.emoji ? emoji : null,
        iconName: visualType == VisualType.icon ? iconName : null,
        color: color,
        targetValue: targetValue,
        targetUnit: targetUnit?.trim().isEmpty == true ? null : targetUnit?.trim(),
        repeatType: repeatType,
        repeatWeekdays: repeatType == RepeatType.selectedWeekdays ? repeatWeekdays : [],
        repeatInterval: repeatType == RepeatType.everyNDays ? repeatInterval : null,
        repeatGoalCount: repeatType == RepeatType.nTimesPerNDays ? repeatGoalCount : null,
        repeatPeriodDays: repeatType == RepeatType.nTimesPerNDays ? repeatPeriodDays : null,
        repeatStartDate: repeatStartDate,
        isActive: true,
        createdAt: DateTime.now(),
        notificationMode: notificationMode,
        notificationTimes: notificationMode == NotificationMode.dailyPlusIndividual
            ? notificationTimes
            : [],
        timerEnabled: completionType == CompletionType.time && timerEnabled,
      );
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class HabitFormScreen extends ConsumerStatefulWidget {
  const HabitFormScreen({
    super.key,
    this.template,
    this.editHabit,
  });

  /// Pre-fill from template (create flow).
  final HabitTemplate? template;

  /// Pre-fill from existing habit (edit flow).
  final Habit? editHabit;

  @override
  ConsumerState<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends ConsumerState<HabitFormScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final _FormData _data;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _data = _FormData();
    if (widget.editHabit != null) {
      _data.applyHabit(widget.editHabit!);
    } else if (widget.template != null) {
      _data.applyTemplate(widget.template!);
    }
    _titleCtrl.text = _data.title;
    _descCtrl.text = _data.description ?? '';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Save
  // ---------------------------------------------------------------------------

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _data.title = _titleCtrl.text;
    _data.description = _descCtrl.text.isEmpty ? null : _descCtrl.text;

    setState(() => _saving = true);
    try {
      final repo = ref.read(habitsRepositoryProvider);
      if (widget.editHabit != null) {
        await repo.update(_data.toHabit(id: widget.editHabit!.id));
      } else {
        await repo.insert(_data.toHabit());
      }
      // Refresh kept-alive Home/list/stats providers.
      ref.read(habitsRevisionProvider.notifier).bump();
      // Notifications depend on schedule/times → rebuild.
      await ref
          .read(notificationOrchestratorProvider)
          .rebuild(ref.read(settingsProvider));
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editHabit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? context.l10n.formEditTitle : context.l10n.formCreateTitle),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(
                isEdit ? context.l10n.formSave : context.l10n.formCreate,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          children: [
            _VisualSection(data: _data, onChanged: () => setState(() {})),
            const SizedBox(height: 16),
            _BasicInfoSection(
              data: _data,
              titleCtrl: _titleCtrl,
              descCtrl: _descCtrl,
            ),
            const SizedBox(height: 16),
            _MechanicsSection(data: _data, onChanged: () => setState(() {})),
            const SizedBox(height: 16),
            _ScheduleSection(data: _data, onChanged: () => setState(() {})),
            const SizedBox(height: 16),
            _NotificationsSection(data: _data, onChanged: () => setState(() {})),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Sections
// ===========================================================================

// ---------------------------------------------------------------------------
// 1. Visual (emoji / icon + color)
// ---------------------------------------------------------------------------

class _VisualSection extends StatelessWidget {
  const _VisualSection({required this.data, required this.onChanged});
  final _FormData data;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(context.l10n.visualLabel),
          const SizedBox(height: 12),
          Row(
            children: [
              // Visual type toggle
              _SegmentedPicker<VisualType>(
                options: [
                  (VisualType.emoji, context.l10n.visualEmoji),
                  (VisualType.icon, context.l10n.visualIcon),
                ],
                selected: data.visualType,
                onSelected: (v) {
                  data.visualType = v;
                  onChanged();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (data.visualType == VisualType.emoji)
            _EmojiInput(
              value: data.emoji,
              onChanged: (v) {
                data.emoji = v;
                onChanged();
              },
            )
          else
            _IconGrid(
              selected: data.iconName,
              onSelected: (name) {
                data.iconName = name;
                onChanged();
              },
            ),
          const SizedBox(height: 14),
          _SectionLabel(context.l10n.colorLabel),
          const SizedBox(height: 10),
          _ColorPalette(
            selected: data.color,
            onSelected: (c) {
              data.color = c;
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}

class _EmojiInput extends StatelessWidget {
  const _EmojiInput({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: AppTheme.chipRadius,
            border: Border.all(color: AppTheme.dividerColor),
          ),
          child: Center(
            child: Text(value, style: const TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: context.l10n.emojiHint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onChanged: (v) {
              // Take the first grapheme cluster (emoji or char)
              if (v.isNotEmpty) onChanged(v.characters.first);
            },
          ),
        ),
      ],
    );
  }
}

class _IconGrid extends StatelessWidget {
  const _IconGrid({required this.selected, required this.onSelected});
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _kIcons.entries.map((e) {
        final isSelected = e.key == selected;
        return GestureDetector(
          onTap: () => onSelected(e.key),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.15)
                  : AppTheme.cardBackground,
              borderRadius: AppTheme.chipRadius,
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Icon(
              e.value,
              size: 20,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorPalette extends StatelessWidget {
  const _ColorPalette({required this.selected, required this.onSelected});
  final Color selected;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _kColors.map((c) {
        final isSelected = c.toARGB32() == selected.toARGB32();
        return GestureDetector(
          onTap: () => onSelected(c),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2.5)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: c.withValues(alpha: 0.6), blurRadius: 6, spreadRadius: 1)]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Basic info
// ---------------------------------------------------------------------------

class _BasicInfoSection extends StatelessWidget {
  const _BasicInfoSection({
    required this.data,
    required this.titleCtrl,
    required this.descCtrl,
  });
  final _FormData data;
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(context.l10n.titleDescLabel),
          const SizedBox(height: 12),
          TextFormField(
            controller: titleCtrl,
            decoration: InputDecoration(hintText: context.l10n.titleHint),
            textCapitalization: TextCapitalization.sentences,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? context.l10n.titleRequired : null,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descCtrl,
            decoration: InputDecoration(
              hintText: context.l10n.descHint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Mechanics
// ---------------------------------------------------------------------------

class _MechanicsSection extends StatelessWidget {
  const _MechanicsSection({required this.data, required this.onChanged});
  final _FormData data;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final showTarget = data.completionType == CompletionType.quantity ||
        data.completionType == CompletionType.time;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(context.l10n.mechanicsTypeLabel),
          const SizedBox(height: 10),
          // Positive / Negative
          _SegmentedPicker<HabitKind>(
            options: [
              (HabitKind.positive, context.l10n.metaPositive),
              (HabitKind.negative, context.l10n.metaNegative),
            ],
            selected: data.habitKind,
            onSelected: (v) {
              data.habitKind = v;
              if (v == HabitKind.negative) {
                data.completionType = CompletionType.avoidance;
              } else if (data.completionType == CompletionType.avoidance) {
                data.completionType = CompletionType.yesNo;
              }
              onChanged();
            },
          ),
          const SizedBox(height: 12),
          _SectionLabel(context.l10n.mechanicsLabel),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _completionTypes(data.habitKind).map((ct) {
                return _Chip(
                  label: _completionLabel(context, ct),
                  selected: data.completionType == ct,
                onTap: () {
                  data.completionType = ct;
                  onChanged();
                },
              );
            }).toList(),
          ),
          if (showTarget) ...[
            const SizedBox(height: 14),
            _SectionLabel(context.l10n.goalLabel),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(hintText: context.l10n.targetValueHint),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (v) =>
                        data.targetValue = double.tryParse(v),
                    controller: TextEditingController(
                      text: data.targetValue?.toString() ?? '',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: data.completionType == CompletionType.time
                          ? context.l10n.targetUnitTimeHint
                          : context.l10n.targetUnitOtherHint,
                    ),
                    onChanged: (v) => data.targetUnit = v,
                    controller:
                        TextEditingController(text: data.targetUnit ?? ''),
                  ),
                ),
              ],
            ),
          ],
          if (data.completionType == CompletionType.time) ...[
            const SizedBox(height: 10),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.timerOnScreen),
              value: data.timerEnabled,
              onChanged: (v) {
                data.timerEnabled = v;
                onChanged();
              },
              activeThumbColor: AppTheme.primaryColor,
            ),
          ],
        ],
      ),
    );
  }

  List<CompletionType> _completionTypes(HabitKind kind) =>
      kind == HabitKind.negative
          ? [CompletionType.avoidance]
          : [
              CompletionType.yesNo,
              CompletionType.quantity,
              CompletionType.time,
            ];

  String _completionLabel(BuildContext context, CompletionType ct) => switch (ct) {
        CompletionType.yesNo => context.l10n.completionYesNo,
        CompletionType.quantity => context.l10n.completionQuantity,
        CompletionType.time => context.l10n.completionTime,
        CompletionType.avoidance => context.l10n.completionAvoidance,
      };
}

// ---------------------------------------------------------------------------
// 4. Schedule
// ---------------------------------------------------------------------------

class _ScheduleSection extends StatelessWidget {
  const _ScheduleSection({required this.data, required this.onChanged});
  final _FormData data;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(context.l10n.scheduleLabel),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: RepeatType.values.map((rt) {
              return _Chip(
                label: _repeatLabel(context, rt),
                selected: data.repeatType == rt,
                onTap: () {
                  data.repeatType = rt;
                  onChanged();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          // Extra controls per repeatType
          if (data.repeatType == RepeatType.selectedWeekdays)
            _WeekdayPicker(
              selected: data.repeatWeekdays,
              onChanged: (days) {
                data.repeatWeekdays = days;
                onChanged();
              },
            ),
          if (data.repeatType == RepeatType.everyNDays)
            _NumberRow(
              label: context.l10n.everyNDaysLabel,
              value: data.repeatInterval,
              min: 2,
              max: 90,
              onChanged: (v) {
                data.repeatInterval = v;
                onChanged();
              },
            ),
          if (data.repeatType == RepeatType.nTimesPerNDays)
            Column(
              children: [
                _NumberRow(
                  label: context.l10n.timesLabel,
                  value: data.repeatGoalCount,
                  min: 1,
                  max: 30,
                  onChanged: (v) {
                    data.repeatGoalCount = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 8),
                _NumberRow(
                  label: context.l10n.inNDaysLabel,
                  value: data.repeatPeriodDays,
                  min: 2,
                  max: 90,
                  onChanged: (v) {
                    data.repeatPeriodDays = v;
                    onChanged();
                  },
                ),
              ],
            ),
          const SizedBox(height: 14),
          _SectionLabel(context.l10n.startDateLabel),
          const SizedBox(height: 8),
          _DatePickerTile(
            date: data.repeatStartDate,
            onChanged: (d) {
              data.repeatStartDate = d;
              onChanged();
            },
          ),
        ],
      ),
    );
  }

  String _repeatLabel(BuildContext context, RepeatType rt) => switch (rt) {
        RepeatType.everyDay => context.l10n.repeatEveryDay,
        RepeatType.selectedWeekdays => context.l10n.repeatSelectedWeekdays,
        RepeatType.everyNDays => context.l10n.everyNDaysLabel,
        RepeatType.nTimesPerNDays => context.l10n.repeatNTimesPerNDays,
      };
}

class _WeekdayPicker extends StatelessWidget {
  const _WeekdayPicker({required this.selected, required this.onChanged});
  final List<int> selected;
  final ValueChanged<List<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: List.generate(7, (i) {
        final weekday = i + 1;
        final isOn = selected.contains(weekday);
        return _Chip(
          label: weekdayShort(context, i),
          selected: isOn,
          onTap: () {
            final next = List<int>.from(selected);
            if (isOn) {
              next.remove(weekday);
            } else {
              next.add(weekday);
              next.sort();
            }
            onChanged(next);
          },
        );
      }),
    );
  }
}

class _NumberRow extends StatelessWidget {
  const _NumberRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        IconButton(
          icon: const Icon(Icons.remove, size: 18),
          onPressed: value > min ? () => onChanged(value - 1) : null,
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.cardBackground,
            shape: const RoundedRectangleBorder(borderRadius: AppTheme.chipRadius),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 18),
          onPressed: value < max ? () => onChanged(value + 1) : null,
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.cardBackground,
            shape: const RoundedRectangleBorder(borderRadius: AppTheme.chipRadius),
          ),
        ),
      ],
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.date, required this.onChanged});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppTheme.chipRadius,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: AppTheme.chipRadius,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 18, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              formatDate(context, date),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Notifications
// ---------------------------------------------------------------------------

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({required this.data, required this.onChanged});
  final _FormData data;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(context.l10n.notificationsLabel),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: NotificationMode.values.map((nm) {
              return _Chip(
                label: _notifLabel(context, nm),
                selected: data.notificationMode == nm,
                onTap: () {
                  data.notificationMode = nm;
                  onChanged();
                },
              );
            }).toList(),
          ),
          if (data.notificationMode == NotificationMode.dailyPlusIndividual) ...[
            const SizedBox(height: 14),
            _SectionLabel(context.l10n.reminderTimeLabel),
            const SizedBox(height: 8),
            ...data.notificationTimes.asMap().entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(e.value,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        data.notificationTimes.removeAt(e.key);
                        onChanged();
                      },
                    ),
                  ],
                ),
              );
            }),
            OutlinedButton.icon(
              onPressed: () => _addTime(context),
              icon: const Icon(Icons.add, size: 16),
              label: Text(context.l10n.addTime),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
                shape: const RoundedRectangleBorder(
                    borderRadius: AppTheme.chipRadius),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _addTime(BuildContext context) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t == null) return;
    final str =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    data.notificationTimes.add(str);
    data.notificationTimes.sort();
    onChanged();
  }

  String _notifLabel(BuildContext context, NotificationMode m) => switch (m) {
        NotificationMode.none => context.l10n.notifOff,
        NotificationMode.dailySummary => context.l10n.notifMorning,
        NotificationMode.dailyPlusIndividual => context.l10n.notifMorningPlus,
      };
}

// ===========================================================================
// Shared small widgets
// ===========================================================================

class _Card extends StatelessWidget {
  const _Card({required this.child});
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
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
    );
  }
}

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
                color: selected ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }
}

class _SegmentedPicker<T> extends StatelessWidget {
  const _SegmentedPicker({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: options.map((opt) {
        final (value, label) = opt;
        final isSelected = value == selected;
        return GestureDetector(
          onTap: () => onSelected(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : AppTheme.cardBackground,
              borderRadius: options.first.$1 == value
                  ? const BorderRadius.horizontal(left: Radius.circular(8))
                  : const BorderRadius.horizontal(right: Radius.circular(8)),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
              ),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
