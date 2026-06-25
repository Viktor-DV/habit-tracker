// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, HabitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _habitKindMeta = const VerificationMeta(
    'habitKind',
  );
  @override
  late final GeneratedColumn<String> habitKind = GeneratedColumn<String>(
    'habit_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completionTypeMeta = const VerificationMeta(
    'completionType',
  );
  @override
  late final GeneratedColumn<String> completionType = GeneratedColumn<String>(
    'completion_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visualTypeMeta = const VerificationMeta(
    'visualType',
  );
  @override
  late final GeneratedColumn<String> visualType = GeneratedColumn<String>(
    'visual_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('icon'),
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetUnitMeta = const VerificationMeta(
    'targetUnit',
  );
  @override
  late final GeneratedColumn<String> targetUnit = GeneratedColumn<String>(
    'target_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatTypeMeta = const VerificationMeta(
    'repeatType',
  );
  @override
  late final GeneratedColumn<String> repeatType = GeneratedColumn<String>(
    'repeat_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatDaysJsonMeta = const VerificationMeta(
    'repeatDaysJson',
  );
  @override
  late final GeneratedColumn<String> repeatDaysJson = GeneratedColumn<String>(
    'repeat_days_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatIntervalMeta = const VerificationMeta(
    'repeatInterval',
  );
  @override
  late final GeneratedColumn<int> repeatInterval = GeneratedColumn<int>(
    'repeat_interval',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatGoalCountMeta = const VerificationMeta(
    'repeatGoalCount',
  );
  @override
  late final GeneratedColumn<int> repeatGoalCount = GeneratedColumn<int>(
    'repeat_goal_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatPeriodDaysMeta = const VerificationMeta(
    'repeatPeriodDays',
  );
  @override
  late final GeneratedColumn<int> repeatPeriodDays = GeneratedColumn<int>(
    'repeat_period_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatStartDateMeta = const VerificationMeta(
    'repeatStartDate',
  );
  @override
  late final GeneratedColumn<String> repeatStartDate = GeneratedColumn<String>(
    'repeat_start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationModeMeta = const VerificationMeta(
    'notificationMode',
  );
  @override
  late final GeneratedColumn<String> notificationMode = GeneratedColumn<String>(
    'notification_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily_summary'),
  );
  static const VerificationMeta _notificationTimesJsonMeta =
      const VerificationMeta('notificationTimesJson');
  @override
  late final GeneratedColumn<String> notificationTimesJson =
      GeneratedColumn<String>(
        'notification_times_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timerEnabledMeta = const VerificationMeta(
    'timerEnabled',
  );
  @override
  late final GeneratedColumn<bool> timerEnabled = GeneratedColumn<bool>(
    'timer_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("timer_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    habitKind,
    completionType,
    visualType,
    iconName,
    emoji,
    photoPath,
    colorValue,
    targetValue,
    targetUnit,
    repeatType,
    repeatDaysJson,
    repeatInterval,
    repeatGoalCount,
    repeatPeriodDays,
    repeatStartDate,
    isActive,
    createdAt,
    notificationMode,
    notificationTimesJson,
    timerEnabled,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('habit_kind')) {
      context.handle(
        _habitKindMeta,
        habitKind.isAcceptableOrUnknown(data['habit_kind']!, _habitKindMeta),
      );
    } else if (isInserting) {
      context.missing(_habitKindMeta);
    }
    if (data.containsKey('completion_type')) {
      context.handle(
        _completionTypeMeta,
        completionType.isAcceptableOrUnknown(
          data['completion_type']!,
          _completionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completionTypeMeta);
    }
    if (data.containsKey('visual_type')) {
      context.handle(
        _visualTypeMeta,
        visualType.isAcceptableOrUnknown(data['visual_type']!, _visualTypeMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('target_unit')) {
      context.handle(
        _targetUnitMeta,
        targetUnit.isAcceptableOrUnknown(data['target_unit']!, _targetUnitMeta),
      );
    }
    if (data.containsKey('repeat_type')) {
      context.handle(
        _repeatTypeMeta,
        repeatType.isAcceptableOrUnknown(data['repeat_type']!, _repeatTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatTypeMeta);
    }
    if (data.containsKey('repeat_days_json')) {
      context.handle(
        _repeatDaysJsonMeta,
        repeatDaysJson.isAcceptableOrUnknown(
          data['repeat_days_json']!,
          _repeatDaysJsonMeta,
        ),
      );
    }
    if (data.containsKey('repeat_interval')) {
      context.handle(
        _repeatIntervalMeta,
        repeatInterval.isAcceptableOrUnknown(
          data['repeat_interval']!,
          _repeatIntervalMeta,
        ),
      );
    }
    if (data.containsKey('repeat_goal_count')) {
      context.handle(
        _repeatGoalCountMeta,
        repeatGoalCount.isAcceptableOrUnknown(
          data['repeat_goal_count']!,
          _repeatGoalCountMeta,
        ),
      );
    }
    if (data.containsKey('repeat_period_days')) {
      context.handle(
        _repeatPeriodDaysMeta,
        repeatPeriodDays.isAcceptableOrUnknown(
          data['repeat_period_days']!,
          _repeatPeriodDaysMeta,
        ),
      );
    }
    if (data.containsKey('repeat_start_date')) {
      context.handle(
        _repeatStartDateMeta,
        repeatStartDate.isAcceptableOrUnknown(
          data['repeat_start_date']!,
          _repeatStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repeatStartDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('notification_mode')) {
      context.handle(
        _notificationModeMeta,
        notificationMode.isAcceptableOrUnknown(
          data['notification_mode']!,
          _notificationModeMeta,
        ),
      );
    }
    if (data.containsKey('notification_times_json')) {
      context.handle(
        _notificationTimesJsonMeta,
        notificationTimesJson.isAcceptableOrUnknown(
          data['notification_times_json']!,
          _notificationTimesJsonMeta,
        ),
      );
    }
    if (data.containsKey('timer_enabled')) {
      context.handle(
        _timerEnabledMeta,
        timerEnabled.isAcceptableOrUnknown(
          data['timer_enabled']!,
          _timerEnabledMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      habitKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_kind'],
      )!,
      completionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_type'],
      )!,
      visualType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visual_type'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      ),
      targetUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_unit'],
      ),
      repeatType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_type'],
      )!,
      repeatDaysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_days_json'],
      ),
      repeatInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_interval'],
      ),
      repeatGoalCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_goal_count'],
      ),
      repeatPeriodDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_period_days'],
      ),
      repeatStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_start_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      notificationMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_mode'],
      )!,
      notificationTimesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_times_json'],
      ),
      timerEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}timer_enabled'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class HabitRow extends DataClass implements Insertable<HabitRow> {
  final int id;
  final String title;
  final String? description;
  final String habitKind;
  final String completionType;
  final String visualType;
  final String? iconName;
  final String? emoji;
  final String? photoPath;
  final int colorValue;
  final double? targetValue;
  final String? targetUnit;
  final String repeatType;
  final String? repeatDaysJson;
  final int? repeatInterval;
  final int? repeatGoalCount;
  final int? repeatPeriodDays;
  final String repeatStartDate;
  final bool isActive;
  final int createdAt;
  final String notificationMode;
  final String? notificationTimesJson;
  final bool timerEnabled;
  final int sortOrder;
  const HabitRow({
    required this.id,
    required this.title,
    this.description,
    required this.habitKind,
    required this.completionType,
    required this.visualType,
    this.iconName,
    this.emoji,
    this.photoPath,
    required this.colorValue,
    this.targetValue,
    this.targetUnit,
    required this.repeatType,
    this.repeatDaysJson,
    this.repeatInterval,
    this.repeatGoalCount,
    this.repeatPeriodDays,
    required this.repeatStartDate,
    required this.isActive,
    required this.createdAt,
    required this.notificationMode,
    this.notificationTimesJson,
    required this.timerEnabled,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['habit_kind'] = Variable<String>(habitKind);
    map['completion_type'] = Variable<String>(completionType);
    map['visual_type'] = Variable<String>(visualType);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || targetValue != null) {
      map['target_value'] = Variable<double>(targetValue);
    }
    if (!nullToAbsent || targetUnit != null) {
      map['target_unit'] = Variable<String>(targetUnit);
    }
    map['repeat_type'] = Variable<String>(repeatType);
    if (!nullToAbsent || repeatDaysJson != null) {
      map['repeat_days_json'] = Variable<String>(repeatDaysJson);
    }
    if (!nullToAbsent || repeatInterval != null) {
      map['repeat_interval'] = Variable<int>(repeatInterval);
    }
    if (!nullToAbsent || repeatGoalCount != null) {
      map['repeat_goal_count'] = Variable<int>(repeatGoalCount);
    }
    if (!nullToAbsent || repeatPeriodDays != null) {
      map['repeat_period_days'] = Variable<int>(repeatPeriodDays);
    }
    map['repeat_start_date'] = Variable<String>(repeatStartDate);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    map['notification_mode'] = Variable<String>(notificationMode);
    if (!nullToAbsent || notificationTimesJson != null) {
      map['notification_times_json'] = Variable<String>(notificationTimesJson);
    }
    map['timer_enabled'] = Variable<bool>(timerEnabled);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      habitKind: Value(habitKind),
      completionType: Value(completionType),
      visualType: Value(visualType),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      colorValue: Value(colorValue),
      targetValue: targetValue == null && nullToAbsent
          ? const Value.absent()
          : Value(targetValue),
      targetUnit: targetUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(targetUnit),
      repeatType: Value(repeatType),
      repeatDaysJson: repeatDaysJson == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatDaysJson),
      repeatInterval: repeatInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatInterval),
      repeatGoalCount: repeatGoalCount == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatGoalCount),
      repeatPeriodDays: repeatPeriodDays == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatPeriodDays),
      repeatStartDate: Value(repeatStartDate),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      notificationMode: Value(notificationMode),
      notificationTimesJson: notificationTimesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationTimesJson),
      timerEnabled: Value(timerEnabled),
      sortOrder: Value(sortOrder),
    );
  }

  factory HabitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      habitKind: serializer.fromJson<String>(json['habitKind']),
      completionType: serializer.fromJson<String>(json['completionType']),
      visualType: serializer.fromJson<String>(json['visualType']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      targetValue: serializer.fromJson<double?>(json['targetValue']),
      targetUnit: serializer.fromJson<String?>(json['targetUnit']),
      repeatType: serializer.fromJson<String>(json['repeatType']),
      repeatDaysJson: serializer.fromJson<String?>(json['repeatDaysJson']),
      repeatInterval: serializer.fromJson<int?>(json['repeatInterval']),
      repeatGoalCount: serializer.fromJson<int?>(json['repeatGoalCount']),
      repeatPeriodDays: serializer.fromJson<int?>(json['repeatPeriodDays']),
      repeatStartDate: serializer.fromJson<String>(json['repeatStartDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      notificationMode: serializer.fromJson<String>(json['notificationMode']),
      notificationTimesJson: serializer.fromJson<String?>(
        json['notificationTimesJson'],
      ),
      timerEnabled: serializer.fromJson<bool>(json['timerEnabled']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'habitKind': serializer.toJson<String>(habitKind),
      'completionType': serializer.toJson<String>(completionType),
      'visualType': serializer.toJson<String>(visualType),
      'iconName': serializer.toJson<String?>(iconName),
      'emoji': serializer.toJson<String?>(emoji),
      'photoPath': serializer.toJson<String?>(photoPath),
      'colorValue': serializer.toJson<int>(colorValue),
      'targetValue': serializer.toJson<double?>(targetValue),
      'targetUnit': serializer.toJson<String?>(targetUnit),
      'repeatType': serializer.toJson<String>(repeatType),
      'repeatDaysJson': serializer.toJson<String?>(repeatDaysJson),
      'repeatInterval': serializer.toJson<int?>(repeatInterval),
      'repeatGoalCount': serializer.toJson<int?>(repeatGoalCount),
      'repeatPeriodDays': serializer.toJson<int?>(repeatPeriodDays),
      'repeatStartDate': serializer.toJson<String>(repeatStartDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
      'notificationMode': serializer.toJson<String>(notificationMode),
      'notificationTimesJson': serializer.toJson<String?>(
        notificationTimesJson,
      ),
      'timerEnabled': serializer.toJson<bool>(timerEnabled),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  HabitRow copyWith({
    int? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? habitKind,
    String? completionType,
    String? visualType,
    Value<String?> iconName = const Value.absent(),
    Value<String?> emoji = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    int? colorValue,
    Value<double?> targetValue = const Value.absent(),
    Value<String?> targetUnit = const Value.absent(),
    String? repeatType,
    Value<String?> repeatDaysJson = const Value.absent(),
    Value<int?> repeatInterval = const Value.absent(),
    Value<int?> repeatGoalCount = const Value.absent(),
    Value<int?> repeatPeriodDays = const Value.absent(),
    String? repeatStartDate,
    bool? isActive,
    int? createdAt,
    String? notificationMode,
    Value<String?> notificationTimesJson = const Value.absent(),
    bool? timerEnabled,
    int? sortOrder,
  }) => HabitRow(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    habitKind: habitKind ?? this.habitKind,
    completionType: completionType ?? this.completionType,
    visualType: visualType ?? this.visualType,
    iconName: iconName.present ? iconName.value : this.iconName,
    emoji: emoji.present ? emoji.value : this.emoji,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    colorValue: colorValue ?? this.colorValue,
    targetValue: targetValue.present ? targetValue.value : this.targetValue,
    targetUnit: targetUnit.present ? targetUnit.value : this.targetUnit,
    repeatType: repeatType ?? this.repeatType,
    repeatDaysJson: repeatDaysJson.present
        ? repeatDaysJson.value
        : this.repeatDaysJson,
    repeatInterval: repeatInterval.present
        ? repeatInterval.value
        : this.repeatInterval,
    repeatGoalCount: repeatGoalCount.present
        ? repeatGoalCount.value
        : this.repeatGoalCount,
    repeatPeriodDays: repeatPeriodDays.present
        ? repeatPeriodDays.value
        : this.repeatPeriodDays,
    repeatStartDate: repeatStartDate ?? this.repeatStartDate,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    notificationMode: notificationMode ?? this.notificationMode,
    notificationTimesJson: notificationTimesJson.present
        ? notificationTimesJson.value
        : this.notificationTimesJson,
    timerEnabled: timerEnabled ?? this.timerEnabled,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  HabitRow copyWithCompanion(HabitsCompanion data) {
    return HabitRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      habitKind: data.habitKind.present ? data.habitKind.value : this.habitKind,
      completionType: data.completionType.present
          ? data.completionType.value
          : this.completionType,
      visualType: data.visualType.present
          ? data.visualType.value
          : this.visualType,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      targetUnit: data.targetUnit.present
          ? data.targetUnit.value
          : this.targetUnit,
      repeatType: data.repeatType.present
          ? data.repeatType.value
          : this.repeatType,
      repeatDaysJson: data.repeatDaysJson.present
          ? data.repeatDaysJson.value
          : this.repeatDaysJson,
      repeatInterval: data.repeatInterval.present
          ? data.repeatInterval.value
          : this.repeatInterval,
      repeatGoalCount: data.repeatGoalCount.present
          ? data.repeatGoalCount.value
          : this.repeatGoalCount,
      repeatPeriodDays: data.repeatPeriodDays.present
          ? data.repeatPeriodDays.value
          : this.repeatPeriodDays,
      repeatStartDate: data.repeatStartDate.present
          ? data.repeatStartDate.value
          : this.repeatStartDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      notificationMode: data.notificationMode.present
          ? data.notificationMode.value
          : this.notificationMode,
      notificationTimesJson: data.notificationTimesJson.present
          ? data.notificationTimesJson.value
          : this.notificationTimesJson,
      timerEnabled: data.timerEnabled.present
          ? data.timerEnabled.value
          : this.timerEnabled,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('habitKind: $habitKind, ')
          ..write('completionType: $completionType, ')
          ..write('visualType: $visualType, ')
          ..write('iconName: $iconName, ')
          ..write('emoji: $emoji, ')
          ..write('photoPath: $photoPath, ')
          ..write('colorValue: $colorValue, ')
          ..write('targetValue: $targetValue, ')
          ..write('targetUnit: $targetUnit, ')
          ..write('repeatType: $repeatType, ')
          ..write('repeatDaysJson: $repeatDaysJson, ')
          ..write('repeatInterval: $repeatInterval, ')
          ..write('repeatGoalCount: $repeatGoalCount, ')
          ..write('repeatPeriodDays: $repeatPeriodDays, ')
          ..write('repeatStartDate: $repeatStartDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('notificationMode: $notificationMode, ')
          ..write('notificationTimesJson: $notificationTimesJson, ')
          ..write('timerEnabled: $timerEnabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    description,
    habitKind,
    completionType,
    visualType,
    iconName,
    emoji,
    photoPath,
    colorValue,
    targetValue,
    targetUnit,
    repeatType,
    repeatDaysJson,
    repeatInterval,
    repeatGoalCount,
    repeatPeriodDays,
    repeatStartDate,
    isActive,
    createdAt,
    notificationMode,
    notificationTimesJson,
    timerEnabled,
    sortOrder,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.habitKind == this.habitKind &&
          other.completionType == this.completionType &&
          other.visualType == this.visualType &&
          other.iconName == this.iconName &&
          other.emoji == this.emoji &&
          other.photoPath == this.photoPath &&
          other.colorValue == this.colorValue &&
          other.targetValue == this.targetValue &&
          other.targetUnit == this.targetUnit &&
          other.repeatType == this.repeatType &&
          other.repeatDaysJson == this.repeatDaysJson &&
          other.repeatInterval == this.repeatInterval &&
          other.repeatGoalCount == this.repeatGoalCount &&
          other.repeatPeriodDays == this.repeatPeriodDays &&
          other.repeatStartDate == this.repeatStartDate &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.notificationMode == this.notificationMode &&
          other.notificationTimesJson == this.notificationTimesJson &&
          other.timerEnabled == this.timerEnabled &&
          other.sortOrder == this.sortOrder);
}

class HabitsCompanion extends UpdateCompanion<HabitRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> habitKind;
  final Value<String> completionType;
  final Value<String> visualType;
  final Value<String?> iconName;
  final Value<String?> emoji;
  final Value<String?> photoPath;
  final Value<int> colorValue;
  final Value<double?> targetValue;
  final Value<String?> targetUnit;
  final Value<String> repeatType;
  final Value<String?> repeatDaysJson;
  final Value<int?> repeatInterval;
  final Value<int?> repeatGoalCount;
  final Value<int?> repeatPeriodDays;
  final Value<String> repeatStartDate;
  final Value<bool> isActive;
  final Value<int> createdAt;
  final Value<String> notificationMode;
  final Value<String?> notificationTimesJson;
  final Value<bool> timerEnabled;
  final Value<int> sortOrder;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.habitKind = const Value.absent(),
    this.completionType = const Value.absent(),
    this.visualType = const Value.absent(),
    this.iconName = const Value.absent(),
    this.emoji = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.targetUnit = const Value.absent(),
    this.repeatType = const Value.absent(),
    this.repeatDaysJson = const Value.absent(),
    this.repeatInterval = const Value.absent(),
    this.repeatGoalCount = const Value.absent(),
    this.repeatPeriodDays = const Value.absent(),
    this.repeatStartDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.notificationMode = const Value.absent(),
    this.notificationTimesJson = const Value.absent(),
    this.timerEnabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String habitKind,
    required String completionType,
    this.visualType = const Value.absent(),
    this.iconName = const Value.absent(),
    this.emoji = const Value.absent(),
    this.photoPath = const Value.absent(),
    required int colorValue,
    this.targetValue = const Value.absent(),
    this.targetUnit = const Value.absent(),
    required String repeatType,
    this.repeatDaysJson = const Value.absent(),
    this.repeatInterval = const Value.absent(),
    this.repeatGoalCount = const Value.absent(),
    this.repeatPeriodDays = const Value.absent(),
    required String repeatStartDate,
    this.isActive = const Value.absent(),
    required int createdAt,
    this.notificationMode = const Value.absent(),
    this.notificationTimesJson = const Value.absent(),
    this.timerEnabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : title = Value(title),
       habitKind = Value(habitKind),
       completionType = Value(completionType),
       colorValue = Value(colorValue),
       repeatType = Value(repeatType),
       repeatStartDate = Value(repeatStartDate),
       createdAt = Value(createdAt);
  static Insertable<HabitRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? habitKind,
    Expression<String>? completionType,
    Expression<String>? visualType,
    Expression<String>? iconName,
    Expression<String>? emoji,
    Expression<String>? photoPath,
    Expression<int>? colorValue,
    Expression<double>? targetValue,
    Expression<String>? targetUnit,
    Expression<String>? repeatType,
    Expression<String>? repeatDaysJson,
    Expression<int>? repeatInterval,
    Expression<int>? repeatGoalCount,
    Expression<int>? repeatPeriodDays,
    Expression<String>? repeatStartDate,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
    Expression<String>? notificationMode,
    Expression<String>? notificationTimesJson,
    Expression<bool>? timerEnabled,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (habitKind != null) 'habit_kind': habitKind,
      if (completionType != null) 'completion_type': completionType,
      if (visualType != null) 'visual_type': visualType,
      if (iconName != null) 'icon_name': iconName,
      if (emoji != null) 'emoji': emoji,
      if (photoPath != null) 'photo_path': photoPath,
      if (colorValue != null) 'color_value': colorValue,
      if (targetValue != null) 'target_value': targetValue,
      if (targetUnit != null) 'target_unit': targetUnit,
      if (repeatType != null) 'repeat_type': repeatType,
      if (repeatDaysJson != null) 'repeat_days_json': repeatDaysJson,
      if (repeatInterval != null) 'repeat_interval': repeatInterval,
      if (repeatGoalCount != null) 'repeat_goal_count': repeatGoalCount,
      if (repeatPeriodDays != null) 'repeat_period_days': repeatPeriodDays,
      if (repeatStartDate != null) 'repeat_start_date': repeatStartDate,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (notificationMode != null) 'notification_mode': notificationMode,
      if (notificationTimesJson != null)
        'notification_times_json': notificationTimesJson,
      if (timerEnabled != null) 'timer_enabled': timerEnabled,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  HabitsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? habitKind,
    Value<String>? completionType,
    Value<String>? visualType,
    Value<String?>? iconName,
    Value<String?>? emoji,
    Value<String?>? photoPath,
    Value<int>? colorValue,
    Value<double?>? targetValue,
    Value<String?>? targetUnit,
    Value<String>? repeatType,
    Value<String?>? repeatDaysJson,
    Value<int?>? repeatInterval,
    Value<int?>? repeatGoalCount,
    Value<int?>? repeatPeriodDays,
    Value<String>? repeatStartDate,
    Value<bool>? isActive,
    Value<int>? createdAt,
    Value<String>? notificationMode,
    Value<String?>? notificationTimesJson,
    Value<bool>? timerEnabled,
    Value<int>? sortOrder,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      habitKind: habitKind ?? this.habitKind,
      completionType: completionType ?? this.completionType,
      visualType: visualType ?? this.visualType,
      iconName: iconName ?? this.iconName,
      emoji: emoji ?? this.emoji,
      photoPath: photoPath ?? this.photoPath,
      colorValue: colorValue ?? this.colorValue,
      targetValue: targetValue ?? this.targetValue,
      targetUnit: targetUnit ?? this.targetUnit,
      repeatType: repeatType ?? this.repeatType,
      repeatDaysJson: repeatDaysJson ?? this.repeatDaysJson,
      repeatInterval: repeatInterval ?? this.repeatInterval,
      repeatGoalCount: repeatGoalCount ?? this.repeatGoalCount,
      repeatPeriodDays: repeatPeriodDays ?? this.repeatPeriodDays,
      repeatStartDate: repeatStartDate ?? this.repeatStartDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      notificationMode: notificationMode ?? this.notificationMode,
      notificationTimesJson:
          notificationTimesJson ?? this.notificationTimesJson,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (habitKind.present) {
      map['habit_kind'] = Variable<String>(habitKind.value);
    }
    if (completionType.present) {
      map['completion_type'] = Variable<String>(completionType.value);
    }
    if (visualType.present) {
      map['visual_type'] = Variable<String>(visualType.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (targetUnit.present) {
      map['target_unit'] = Variable<String>(targetUnit.value);
    }
    if (repeatType.present) {
      map['repeat_type'] = Variable<String>(repeatType.value);
    }
    if (repeatDaysJson.present) {
      map['repeat_days_json'] = Variable<String>(repeatDaysJson.value);
    }
    if (repeatInterval.present) {
      map['repeat_interval'] = Variable<int>(repeatInterval.value);
    }
    if (repeatGoalCount.present) {
      map['repeat_goal_count'] = Variable<int>(repeatGoalCount.value);
    }
    if (repeatPeriodDays.present) {
      map['repeat_period_days'] = Variable<int>(repeatPeriodDays.value);
    }
    if (repeatStartDate.present) {
      map['repeat_start_date'] = Variable<String>(repeatStartDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (notificationMode.present) {
      map['notification_mode'] = Variable<String>(notificationMode.value);
    }
    if (notificationTimesJson.present) {
      map['notification_times_json'] = Variable<String>(
        notificationTimesJson.value,
      );
    }
    if (timerEnabled.present) {
      map['timer_enabled'] = Variable<bool>(timerEnabled.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('habitKind: $habitKind, ')
          ..write('completionType: $completionType, ')
          ..write('visualType: $visualType, ')
          ..write('iconName: $iconName, ')
          ..write('emoji: $emoji, ')
          ..write('photoPath: $photoPath, ')
          ..write('colorValue: $colorValue, ')
          ..write('targetValue: $targetValue, ')
          ..write('targetUnit: $targetUnit, ')
          ..write('repeatType: $repeatType, ')
          ..write('repeatDaysJson: $repeatDaysJson, ')
          ..write('repeatInterval: $repeatInterval, ')
          ..write('repeatGoalCount: $repeatGoalCount, ')
          ..write('repeatPeriodDays: $repeatPeriodDays, ')
          ..write('repeatStartDate: $repeatStartDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('notificationMode: $notificationMode, ')
          ..write('notificationTimesJson: $notificationTimesJson, ')
          ..write('timerEnabled: $timerEnabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $HabitEntriesTable extends HabitEntries
    with TableInfo<$HabitEntriesTable, HabitEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    date,
    status,
    value,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HabitEntriesTable createAlias(String alias) {
    return $HabitEntriesTable(attachedDatabase, alias);
  }
}

class HabitEntryRow extends DataClass implements Insertable<HabitEntryRow> {
  final int id;
  final int habitId;
  final String date;
  final String status;
  final double? value;
  final int createdAt;
  final int updatedAt;
  const HabitEntryRow({
    required this.id,
    required this.habitId,
    required this.date,
    required this.status,
    this.value,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<int>(habitId);
    map['date'] = Variable<String>(date);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  HabitEntriesCompanion toCompanion(bool nullToAbsent) {
    return HabitEntriesCompanion(
      id: Value(id),
      habitId: Value(habitId),
      date: Value(date),
      status: Value(status),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HabitEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitEntryRow(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<int>(json['habitId']),
      date: serializer.fromJson<String>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      value: serializer.fromJson<double?>(json['value']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<int>(habitId),
      'date': serializer.toJson<String>(date),
      'status': serializer.toJson<String>(status),
      'value': serializer.toJson<double?>(value),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  HabitEntryRow copyWith({
    int? id,
    int? habitId,
    String? date,
    String? status,
    Value<double?> value = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => HabitEntryRow(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    date: date ?? this.date,
    status: status ?? this.status,
    value: value.present ? value.value : this.value,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HabitEntryRow copyWithCompanion(HabitEntriesCompanion data) {
    return HabitEntryRow(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntryRow(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, habitId, date, status, value, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitEntryRow &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.status == this.status &&
          other.value == this.value &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HabitEntriesCompanion extends UpdateCompanion<HabitEntryRow> {
  final Value<int> id;
  final Value<int> habitId;
  final Value<String> date;
  final Value<String> status;
  final Value<double?> value;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const HabitEntriesCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HabitEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int habitId,
    required String date,
    required String status,
    this.value = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : habitId = Value(habitId),
       date = Value(date),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HabitEntryRow> custom({
    Expression<int>? id,
    Expression<int>? habitId,
    Expression<String>? date,
    Expression<String>? status,
    Expression<double>? value,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HabitEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? habitId,
    Value<String>? date,
    Value<String>? status,
    Value<double?>? value,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return HabitEntriesCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      status: status ?? this.status,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitEntriesTable habitEntries = $HabitEntriesTable(this);
  late final HabitsDao habitsDao = HabitsDao(this as AppDatabase);
  late final EntriesDao entriesDao = EntriesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [habits, habitEntries];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> description,
      required String habitKind,
      required String completionType,
      Value<String> visualType,
      Value<String?> iconName,
      Value<String?> emoji,
      Value<String?> photoPath,
      required int colorValue,
      Value<double?> targetValue,
      Value<String?> targetUnit,
      required String repeatType,
      Value<String?> repeatDaysJson,
      Value<int?> repeatInterval,
      Value<int?> repeatGoalCount,
      Value<int?> repeatPeriodDays,
      required String repeatStartDate,
      Value<bool> isActive,
      required int createdAt,
      Value<String> notificationMode,
      Value<String?> notificationTimesJson,
      Value<bool> timerEnabled,
      Value<int> sortOrder,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> description,
      Value<String> habitKind,
      Value<String> completionType,
      Value<String> visualType,
      Value<String?> iconName,
      Value<String?> emoji,
      Value<String?> photoPath,
      Value<int> colorValue,
      Value<double?> targetValue,
      Value<String?> targetUnit,
      Value<String> repeatType,
      Value<String?> repeatDaysJson,
      Value<int?> repeatInterval,
      Value<int?> repeatGoalCount,
      Value<int?> repeatPeriodDays,
      Value<String> repeatStartDate,
      Value<bool> isActive,
      Value<int> createdAt,
      Value<String> notificationMode,
      Value<String?> notificationTimesJson,
      Value<bool> timerEnabled,
      Value<int> sortOrder,
    });

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, HabitRow> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitEntriesTable, List<HabitEntryRow>>
  _habitEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitEntries,
    aliasName: $_aliasNameGenerator(db.habits.id, db.habitEntries.habitId),
  );

  $$HabitEntriesTableProcessedTableManager get habitEntriesRefs {
    final manager = $$HabitEntriesTableTableManager(
      $_db,
      $_db.habitEntries,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitKind => $composableBuilder(
    column: $table.habitKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionType => $composableBuilder(
    column: $table.completionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visualType => $composableBuilder(
    column: $table.visualType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetUnit => $composableBuilder(
    column: $table.targetUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatType => $composableBuilder(
    column: $table.repeatType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatDaysJson => $composableBuilder(
    column: $table.repeatDaysJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatInterval => $composableBuilder(
    column: $table.repeatInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatGoalCount => $composableBuilder(
    column: $table.repeatGoalCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatPeriodDays => $composableBuilder(
    column: $table.repeatPeriodDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatStartDate => $composableBuilder(
    column: $table.repeatStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationMode => $composableBuilder(
    column: $table.notificationMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationTimesJson => $composableBuilder(
    column: $table.notificationTimesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get timerEnabled => $composableBuilder(
    column: $table.timerEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitEntriesRefs(
    Expression<bool> Function($$HabitEntriesTableFilterComposer f) f,
  ) {
    final $$HabitEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitEntries,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitEntriesTableFilterComposer(
            $db: $db,
            $table: $db.habitEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitKind => $composableBuilder(
    column: $table.habitKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionType => $composableBuilder(
    column: $table.completionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visualType => $composableBuilder(
    column: $table.visualType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetUnit => $composableBuilder(
    column: $table.targetUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatType => $composableBuilder(
    column: $table.repeatType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatDaysJson => $composableBuilder(
    column: $table.repeatDaysJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatInterval => $composableBuilder(
    column: $table.repeatInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatGoalCount => $composableBuilder(
    column: $table.repeatGoalCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatPeriodDays => $composableBuilder(
    column: $table.repeatPeriodDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatStartDate => $composableBuilder(
    column: $table.repeatStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationMode => $composableBuilder(
    column: $table.notificationMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationTimesJson => $composableBuilder(
    column: $table.notificationTimesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get timerEnabled => $composableBuilder(
    column: $table.timerEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get habitKind =>
      $composableBuilder(column: $table.habitKind, builder: (column) => column);

  GeneratedColumn<String> get completionType => $composableBuilder(
    column: $table.completionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get visualType => $composableBuilder(
    column: $table.visualType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetUnit => $composableBuilder(
    column: $table.targetUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatType => $composableBuilder(
    column: $table.repeatType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatDaysJson => $composableBuilder(
    column: $table.repeatDaysJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatInterval => $composableBuilder(
    column: $table.repeatInterval,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatGoalCount => $composableBuilder(
    column: $table.repeatGoalCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatPeriodDays => $composableBuilder(
    column: $table.repeatPeriodDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatStartDate => $composableBuilder(
    column: $table.repeatStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get notificationMode => $composableBuilder(
    column: $table.notificationMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notificationTimesJson => $composableBuilder(
    column: $table.notificationTimesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get timerEnabled => $composableBuilder(
    column: $table.timerEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> habitEntriesRefs<T extends Object>(
    Expression<T> Function($$HabitEntriesTableAnnotationComposer a) f,
  ) {
    final $$HabitEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitEntries,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.habitEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          HabitRow,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (HabitRow, $$HabitsTableReferences),
          HabitRow,
          PrefetchHooks Function({bool habitEntriesRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> habitKind = const Value.absent(),
                Value<String> completionType = const Value.absent(),
                Value<String> visualType = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<double?> targetValue = const Value.absent(),
                Value<String?> targetUnit = const Value.absent(),
                Value<String> repeatType = const Value.absent(),
                Value<String?> repeatDaysJson = const Value.absent(),
                Value<int?> repeatInterval = const Value.absent(),
                Value<int?> repeatGoalCount = const Value.absent(),
                Value<int?> repeatPeriodDays = const Value.absent(),
                Value<String> repeatStartDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<String> notificationMode = const Value.absent(),
                Value<String?> notificationTimesJson = const Value.absent(),
                Value<bool> timerEnabled = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                title: title,
                description: description,
                habitKind: habitKind,
                completionType: completionType,
                visualType: visualType,
                iconName: iconName,
                emoji: emoji,
                photoPath: photoPath,
                colorValue: colorValue,
                targetValue: targetValue,
                targetUnit: targetUnit,
                repeatType: repeatType,
                repeatDaysJson: repeatDaysJson,
                repeatInterval: repeatInterval,
                repeatGoalCount: repeatGoalCount,
                repeatPeriodDays: repeatPeriodDays,
                repeatStartDate: repeatStartDate,
                isActive: isActive,
                createdAt: createdAt,
                notificationMode: notificationMode,
                notificationTimesJson: notificationTimesJson,
                timerEnabled: timerEnabled,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required String habitKind,
                required String completionType,
                Value<String> visualType = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required int colorValue,
                Value<double?> targetValue = const Value.absent(),
                Value<String?> targetUnit = const Value.absent(),
                required String repeatType,
                Value<String?> repeatDaysJson = const Value.absent(),
                Value<int?> repeatInterval = const Value.absent(),
                Value<int?> repeatGoalCount = const Value.absent(),
                Value<int?> repeatPeriodDays = const Value.absent(),
                required String repeatStartDate,
                Value<bool> isActive = const Value.absent(),
                required int createdAt,
                Value<String> notificationMode = const Value.absent(),
                Value<String?> notificationTimesJson = const Value.absent(),
                Value<bool> timerEnabled = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                title: title,
                description: description,
                habitKind: habitKind,
                completionType: completionType,
                visualType: visualType,
                iconName: iconName,
                emoji: emoji,
                photoPath: photoPath,
                colorValue: colorValue,
                targetValue: targetValue,
                targetUnit: targetUnit,
                repeatType: repeatType,
                repeatDaysJson: repeatDaysJson,
                repeatInterval: repeatInterval,
                repeatGoalCount: repeatGoalCount,
                repeatPeriodDays: repeatPeriodDays,
                repeatStartDate: repeatStartDate,
                isActive: isActive,
                createdAt: createdAt,
                notificationMode: notificationMode,
                notificationTimesJson: notificationTimesJson,
                timerEnabled: timerEnabled,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (habitEntriesRefs) db.habitEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitEntriesRefs)
                    await $_getPrefetchedData<
                      HabitRow,
                      $HabitsTable,
                      HabitEntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._habitEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$HabitsTableReferences(
                        db,
                        table,
                        p0,
                      ).habitEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      HabitRow,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (HabitRow, $$HabitsTableReferences),
      HabitRow,
      PrefetchHooks Function({bool habitEntriesRefs})
    >;
typedef $$HabitEntriesTableCreateCompanionBuilder =
    HabitEntriesCompanion Function({
      Value<int> id,
      required int habitId,
      required String date,
      required String status,
      Value<double?> value,
      required int createdAt,
      required int updatedAt,
    });
typedef $$HabitEntriesTableUpdateCompanionBuilder =
    HabitEntriesCompanion Function({
      Value<int> id,
      Value<int> habitId,
      Value<String> date,
      Value<String> status,
      Value<double?> value,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

final class $$HabitEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $HabitEntriesTable, HabitEntryRow> {
  $$HabitEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) => db.habits.createAlias(
    $_aliasNameGenerator(db.habitEntries.habitId, db.habits.id),
  );

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<int>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitEntriesTable,
          HabitEntryRow,
          $$HabitEntriesTableFilterComposer,
          $$HabitEntriesTableOrderingComposer,
          $$HabitEntriesTableAnnotationComposer,
          $$HabitEntriesTableCreateCompanionBuilder,
          $$HabitEntriesTableUpdateCompanionBuilder,
          (HabitEntryRow, $$HabitEntriesTableReferences),
          HabitEntryRow,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitEntriesTableTableManager(_$AppDatabase db, $HabitEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> habitId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => HabitEntriesCompanion(
                id: id,
                habitId: habitId,
                date: date,
                status: status,
                value: value,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int habitId,
                required String date,
                required String status,
                Value<double?> value = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => HabitEntriesCompanion.insert(
                id: id,
                habitId: habitId,
                date: date,
                status: status,
                value: value,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable: $$HabitEntriesTableReferences
                                    ._habitIdTable(db),
                                referencedColumn: $$HabitEntriesTableReferences
                                    ._habitIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitEntriesTable,
      HabitEntryRow,
      $$HabitEntriesTableFilterComposer,
      $$HabitEntriesTableOrderingComposer,
      $$HabitEntriesTableAnnotationComposer,
      $$HabitEntriesTableCreateCompanionBuilder,
      $$HabitEntriesTableUpdateCompanionBuilder,
      (HabitEntryRow, $$HabitEntriesTableReferences),
      HabitEntryRow,
      PrefetchHooks Function({bool habitId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitEntriesTableTableManager get habitEntries =>
      $$HabitEntriesTableTableManager(_db, _db.habitEntries);
}

mixin _$HabitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $HabitsTable get habits => attachedDatabase.habits;
  HabitsDaoManager get managers => HabitsDaoManager(this);
}

class HabitsDaoManager {
  final _$HabitsDaoMixin _db;
  HabitsDaoManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db.attachedDatabase, _db.habits);
}

mixin _$EntriesDaoMixin on DatabaseAccessor<AppDatabase> {
  $HabitsTable get habits => attachedDatabase.habits;
  $HabitEntriesTable get habitEntries => attachedDatabase.habitEntries;
  EntriesDaoManager get managers => EntriesDaoManager(this);
}

class EntriesDaoManager {
  final _$EntriesDaoMixin _db;
  EntriesDaoManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db.attachedDatabase, _db.habits);
  $$HabitEntriesTableTableManager get habitEntries =>
      $$HabitEntriesTableTableManager(_db.attachedDatabase, _db.habitEntries);
}
