import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Locale-aware date formatting helpers.
///
/// Using [DateFormat] (from `intl`) instead of hardcoded Russian arrays keeps
/// month and weekday names correct once more locales are added — no string
/// literals live in the UI code.

String monthLong(BuildContext context, DateTime date) =>
    DateFormat('LLLL', _locale(context)).format(date);

String monthShort(BuildContext context, DateTime date) =>
    DateFormat('LLL', _locale(context)).format(date);

/// Short weekday label for a Monday-first index (0 = Mon … 6 = Sun).
String weekdayShort(BuildContext context, int mondayIndex) {
  // 2023-01-02 is a Monday; offset by the requested index.
  final day = DateTime(2023, 1, 2).add(Duration(days: mondayIndex));
  return DateFormat('E', _locale(context)).format(day);
}

String formatDate(BuildContext context, DateTime date) =>
    DateFormat('dd.MM.yyyy', _locale(context)).format(date);

String formatDateTime(BuildContext context, DateTime date) =>
    DateFormat('dd.MM HH:mm', _locale(context)).format(date);

String formatTime(BuildContext context, int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

String _locale(BuildContext context) =>
    Localizations.localeOf(context).languageCode;
