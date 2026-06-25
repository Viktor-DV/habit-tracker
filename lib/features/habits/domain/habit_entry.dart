import 'habit_enums.dart';

class HabitEntry {
  const HabitEntry({
    required this.id,
    required this.habitId,
    required this.date,
    required this.status,
    this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int habitId;

  /// Date of the habit-day (YYYY-MM-DD)
  final DateTime date;

  final EntryStatus status;

  /// Actual value for quantity/time habits (null for yes_no / avoidance)
  final double? value;

  final DateTime createdAt;
  final DateTime updatedAt;

  HabitEntry copyWith({
    int? id,
    int? habitId,
    DateTime? date,
    EntryStatus? status,
    double? value,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HabitEntry(
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
  bool operator ==(Object other) =>
      identical(this, other) || (other is HabitEntry && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
