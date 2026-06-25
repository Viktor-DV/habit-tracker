import 'package:flutter/material.dart';
import 'habit_enums.dart';

/// A pre-filled template that the user can pick when creating a new habit.
class HabitTemplate {
  const HabitTemplate({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.category,
    this.description,
    this.habitKind = HabitKind.positive,
    this.completionType = CompletionType.yesNo,
    this.targetValue,
    this.targetUnit,
    this.repeatType = RepeatType.everyDay,
  });

  final String id;
  final String title;
  final String emoji;
  final Color color;
  final String category;
  final String? description;
  final HabitKind habitKind;
  final CompletionType completionType;
  final double? targetValue;
  final String? targetUnit;
  final RepeatType repeatType;
}

const kHabitTemplates = <HabitTemplate>[
  // ── Здоровье ────────────────────────────────────────────────────────────────
  HabitTemplate(
    id: 'run',
    title: 'Утренняя пробежка',
    emoji: '🏃',
    color: Color(0xFFE84393),
    category: 'Здоровье',
    description: 'Выйти на пробежку с утра',
    completionType: CompletionType.time,
    targetValue: 20,
    targetUnit: 'мин',
  ),
  HabitTemplate(
    id: 'gym',
    title: 'Спортзал',
    emoji: '🏋️',
    color: Color(0xFFFF6B35),
    category: 'Здоровье',
    description: 'Тренировка в зале',
    repeatType: RepeatType.selectedWeekdays,
  ),
  HabitTemplate(
    id: 'water',
    title: 'Пить воду',
    emoji: '💧',
    color: Color(0xFF2383E2),
    category: 'Здоровье',
    description: 'Выпить не менее 8 стаканов воды',
    completionType: CompletionType.quantity,
    targetValue: 8,
    targetUnit: 'стаканов',
  ),
  HabitTemplate(
    id: 'sleep',
    title: 'Лечь до полуночи',
    emoji: '🌙',
    color: Color(0xFF6C63FF),
    category: 'Здоровье',
    description: 'Ложиться спать до 00:00',
  ),
  HabitTemplate(
    id: 'steps',
    title: '10 000 шагов',
    emoji: '👟',
    color: Color(0xFF43C59E),
    category: 'Здоровье',
    completionType: CompletionType.quantity,
    targetValue: 10000,
    targetUnit: 'шагов',
  ),
  HabitTemplate(
    id: 'no_junk',
    title: 'Без фастфуда',
    emoji: '🥗',
    color: Color(0xFF4CAF50),
    category: 'Здоровье',
    description: 'Не есть фастфуд и сладкое',
    habitKind: HabitKind.negative,
    completionType: CompletionType.avoidance,
  ),
  HabitTemplate(
    id: 'no_smoking',
    title: 'Не курить',
    emoji: '🚭',
    color: Color(0xFF9E9E9E),
    category: 'Здоровье',
    habitKind: HabitKind.negative,
    completionType: CompletionType.avoidance,
  ),
  HabitTemplate(
    id: 'no_alcohol',
    title: 'Без алкоголя',
    emoji: '🍵',
    color: Color(0xFF8D6E63),
    category: 'Здоровье',
    habitKind: HabitKind.negative,
    completionType: CompletionType.avoidance,
  ),
  HabitTemplate(
    id: 'cold_shower',
    title: 'Холодный душ',
    emoji: '🚿',
    color: Color(0xFF00BCD4),
    category: 'Здоровье',
  ),

  // ── Разум ────────────────────────────────────────────────────────────────────
  HabitTemplate(
    id: 'read',
    title: 'Читать книги',
    emoji: '📚',
    color: Color(0xFFF59E0B),
    category: 'Разум',
    description: 'Читать минимум 30 минут в день',
    completionType: CompletionType.time,
    targetValue: 30,
    targetUnit: 'мин',
  ),
  HabitTemplate(
    id: 'meditate',
    title: 'Медитация',
    emoji: '🧘',
    color: Color(0xFF9C27B0),
    category: 'Разум',
    completionType: CompletionType.time,
    targetValue: 10,
    targetUnit: 'мин',
  ),
  HabitTemplate(
    id: 'language',
    title: 'Учить язык',
    emoji: '🗣️',
    color: Color(0xFF2383E2),
    category: 'Разум',
    description: 'Урок иностранного языка',
    completionType: CompletionType.time,
    targetValue: 15,
    targetUnit: 'мин',
  ),
  HabitTemplate(
    id: 'journal',
    title: 'Дневник',
    emoji: '✍️',
    color: Color(0xFFE84393),
    category: 'Разум',
    description: 'Написать хотя бы несколько строк о дне',
  ),
  HabitTemplate(
    id: 'no_social',
    title: 'Без соцсетей',
    emoji: '📵',
    color: Color(0xFFFF5722),
    category: 'Разум',
    description: 'Не открывать соцсети без цели',
    habitKind: HabitKind.negative,
    completionType: CompletionType.avoidance,
  ),

  // ── Продуктивность ───────────────────────────────────────────────────────────
  HabitTemplate(
    id: 'morning_routine',
    title: 'Утренний ритуал',
    emoji: '☀️',
    color: Color(0xFFF59E0B),
    category: 'Продуктивность',
    description: 'Зарядка, завтрак, план на день',
  ),
  HabitTemplate(
    id: 'plan_tomorrow',
    title: 'Планировать завтра',
    emoji: '📋',
    color: Color(0xFF43C59E),
    category: 'Продуктивность',
    description: 'Записать 3 главные задачи на следующий день',
  ),
  HabitTemplate(
    id: 'deep_work',
    title: 'Глубокая работа',
    emoji: '🎯',
    color: Color(0xFF6C63FF),
    category: 'Продуктивность',
    completionType: CompletionType.time,
    targetValue: 2,
    targetUnit: 'ч',
  ),
  HabitTemplate(
    id: 'gratitude',
    title: 'Благодарность',
    emoji: '🙏',
    color: Color(0xFFFF9800),
    category: 'Продуктивность',
    description: 'Написать 3 вещи, за которые благодарен',
  ),
  HabitTemplate(
    id: 'no_procrastinate',
    title: 'Без прокрастинации',
    emoji: '⏰',
    color: Color(0xFFF44336),
    category: 'Продуктивность',
    description: 'Сразу выполнять задачи ≤2 мин',
    habitKind: HabitKind.negative,
    completionType: CompletionType.avoidance,
  ),
];

/// All unique categories in order.
final kTemplateCategories = kHabitTemplates
    .map((t) => t.category)
    .toSet()
    .toList();
