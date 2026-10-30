// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Трекер привычек';

  @override
  String get cancel => 'Отмена';

  @override
  String get ok => 'OK';

  @override
  String get navHome => 'Главная';

  @override
  String get navHabits => 'Привычки';

  @override
  String get navStats => 'Статистика';

  @override
  String get navSettings => 'Настройки';

  @override
  String get fabCreateHabit => 'Создать привычку';

  @override
  String get homeTitle => 'Главная';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get tomorrow => 'Завтра';

  @override
  String get filterAllActive => 'Все активные';

  @override
  String get emptyNoHabitsTitle => 'Привычек нет';

  @override
  String get emptyNoHabitsSubtitle => 'Нажмите + чтобы создать первую привычку';

  @override
  String get emptyNoActiveTitle => 'Нет активных привычек';

  @override
  String get emptyNoActiveSubtitle => 'Создайте первую привычку, нажав +';

  @override
  String get resetSkip => 'Пропустить';

  @override
  String get resetReset => 'Сбросить';

  @override
  String get quantityValueHint => 'Значение';

  @override
  String get negSuccess => 'Успех';

  @override
  String get negFailure => 'Срыв';

  @override
  String get negSkip => 'Пропуск';

  @override
  String get allHabitsTitle => 'Все привычки';

  @override
  String get searchHint => 'Поиск привычек…';

  @override
  String get filterActive => 'Активные';

  @override
  String get filterInactive => 'Неактивные';

  @override
  String get filterAll => 'Все';

  @override
  String get kindPositive => 'Позитивные';

  @override
  String get kindNegative => 'Негативные';

  @override
  String get reorderDone => 'Готово';

  @override
  String get reorderSort => 'Сортировать';

  @override
  String get emptyHabitsTitle => 'Привычек нет';

  @override
  String get emptyHabitsSubtitle => 'Создайте первую привычку, нажав +';

  @override
  String get reorderHint => 'Перетащите для изменения порядка';

  @override
  String get metaPositive => 'Позитивная';

  @override
  String get metaNegative => 'Негативная';

  @override
  String get metaInactive => 'Неактивна';

  @override
  String get repeatEveryDay => 'Каждый день';

  @override
  String get repeatSelectedWeekdays => 'По дням';

  @override
  String get repeatEveryNDays => 'Через N дней';

  @override
  String get repeatNTimesPerNDays => 'N раз за N дней';

  @override
  String get deleteTitle => 'Удалить привычку?';

  @override
  String get deleteBody => 'Все записи тоже будут удалены.';

  @override
  String get deleteConfirm => 'Удалить';

  @override
  String get editTooltip => 'Редактировать';

  @override
  String get toggleActivate => 'Активизировать';

  @override
  String get toggleDeactivate => 'Деактивировать';

  @override
  String get badgeActive => 'Активна';

  @override
  String get badgeInactive => 'Неактивна';

  @override
  String get badgePositive => 'Позитивная';

  @override
  String get badgeNegative => 'Негативная';

  @override
  String get infoTitle => 'Информация';

  @override
  String get infoMechanics => 'Механика';

  @override
  String get infoGoal => 'Цель';

  @override
  String get infoSchedule => 'Расписание';

  @override
  String get infoStart => 'Начало';

  @override
  String get infoCreated => 'Создана';

  @override
  String get completionYesNo => 'Да / Нет';

  @override
  String get completionQuantity => 'Количество';

  @override
  String get completionTime => 'Время';

  @override
  String get completionAvoidance => 'Избегание';

  @override
  String get scheduleEveryDay => 'Каждый день';

  @override
  String get scheduleSelectedWeekdays => 'По дням недели';

  @override
  String scheduleEveryNDays(int count) {
    return 'Каждые $count дн.';
  }

  @override
  String scheduleNTimesPerNDays(int goalCount, int periodDays) {
    return '$goalCount раз за $periodDays дн.';
  }

  @override
  String get metricsTitle => 'Статистика';

  @override
  String get metricStreak => 'Серия';

  @override
  String get metricBest => 'Рекорд';

  @override
  String get metricDone => 'Выполнено';

  @override
  String get metric30days => '30 дней';

  @override
  String get chartWeekly => 'По неделям';

  @override
  String get weekThis => 'Эта';

  @override
  String get historyTitle => 'История (последние 3 месяца)';

  @override
  String get timerTitle => 'Таймер';

  @override
  String get timerSaveQuestion => 'Сохранить время?';

  @override
  String timerSaveBody(String duration) {
    return 'Прошло $duration. Сохранить как выполнение?';
  }

  @override
  String get timerNo => 'Нет';

  @override
  String get timerSave => 'Сохранить';

  @override
  String timerSaved(int minutes) {
    return 'Сохранено: $minutes мин';
  }

  @override
  String get timerStart => 'Старт';

  @override
  String get timerStop => 'Стоп';

  @override
  String get timerReset => 'Сброс';

  @override
  String get unitMinutes => 'мин';

  @override
  String get formCreateTitle => 'Создать привычку';

  @override
  String get formEditTitle => 'Редактировать';

  @override
  String get formSave => 'Сохранить';

  @override
  String get formCreate => 'Создать';

  @override
  String get visualLabel => 'Визуал';

  @override
  String get visualEmoji => 'Эмодзи';

  @override
  String get visualIcon => 'Иконка';

  @override
  String get colorLabel => 'Цвет';

  @override
  String get emojiHint => 'Вставьте эмодзи';

  @override
  String get titleDescLabel => 'Название и описание';

  @override
  String get titleHint => 'Название привычки *';

  @override
  String get titleRequired => 'Введите название';

  @override
  String get descHint => 'Описание (необязательно)';

  @override
  String get mechanicsTypeLabel => 'Тип';

  @override
  String get mechanicsLabel => 'Механика';

  @override
  String get goalLabel => 'Цель';

  @override
  String get targetValueHint => 'Значение';

  @override
  String get targetUnitTimeHint => 'мин / ч';

  @override
  String get targetUnitOtherHint => 'единица';

  @override
  String get timerOnScreen => 'Таймер на экране привычки';

  @override
  String get scheduleLabel => 'Расписание';

  @override
  String get everyNDaysLabel => 'Каждые N дней';

  @override
  String get timesLabel => 'Раз';

  @override
  String get inNDaysLabel => 'в N дней';

  @override
  String get startDateLabel => 'Дата старта';

  @override
  String get notificationsLabel => 'Уведомления';

  @override
  String get reminderTimeLabel => 'Время напоминаний';

  @override
  String get addTime => 'Добавить время';

  @override
  String get notifOff => 'Выкл';

  @override
  String get notifMorning => 'Утром';

  @override
  String get notifMorningPlus => 'Утром + своё время';

  @override
  String get templateTitle => 'Новая привычка';

  @override
  String get customHabit => 'Своя привычка';

  @override
  String get customHabitSubtitle => 'Настрой с нуля';

  @override
  String get statsTitle => 'Статистика';

  @override
  String get period7 => '7 дней';

  @override
  String get period30 => 'Месяц';

  @override
  String get period90 => '3 месяца';

  @override
  String get periodYear => 'Год';

  @override
  String get emptyStatsTitle => 'Пока нет данных';

  @override
  String get emptyStatsSubtitle => 'Отмечайте привычки, чтобы видеть прогресс';

  @override
  String get avgCompletion => 'Среднее\nвыполнение';

  @override
  String get totalDone => 'Всего\nвыполнено';

  @override
  String get bestHabit => 'Лучшая';

  @override
  String get trendTitle => 'ДИНАМИКА';

  @override
  String get noData => 'Нет данных';

  @override
  String get byHabitTitle => 'ПО ПРИВЫЧКАМ';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get appearanceSection => 'Оформление';

  @override
  String get notificationsSection => 'Уведомления';

  @override
  String get daySection => 'День';

  @override
  String get historySection => 'История';

  @override
  String get themeLabel => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get dndTitle => 'Заглушить все уведомления';

  @override
  String get dndSubtitleOff => 'Уведомления активны';

  @override
  String get dndMutePeriod => 'Заглушить на период';

  @override
  String get dndDisable => 'Отключить';

  @override
  String get dndForever => 'Заглушено навсегда';

  @override
  String dndUntil(String date) {
    return 'Заглушено до $date';
  }

  @override
  String get dndMuted => 'Заглушено';

  @override
  String get dayStartTitle => 'Начало нового дня';

  @override
  String get dayStartPickerHint => 'Начало нового дня';

  @override
  String get snoozeTitle => 'Интервал «Напомнить позже»';

  @override
  String snoozeUnit(int minutes) {
    return '$minutes мин';
  }

  @override
  String get morningSummaryTitle => 'Утреннее напоминание';

  @override
  String morningSummarySubtitle(String time) {
    return 'Сводка привычек в начале нового дня ($time)';
  }

  @override
  String get historyKeepTitle => 'Хранить историю';

  @override
  String get historyKeepSubtitle =>
      'Без истории долгосрочная статистика ограничена';

  @override
  String historyCount(int count) {
    return 'Записей: $count  ·  Авточистка при >50 МБ';
  }

  @override
  String get historyClearAll => 'Очистить всё';

  @override
  String get historyClearN => 'Очистить последние N';

  @override
  String get clearAllTitle => 'Очистить всю историю?';

  @override
  String get clearAllBody => 'Это действие нельзя отменить.';

  @override
  String get clearAllConfirm => 'Очистить';

  @override
  String get clearNTitle => 'Удалить последних N записей';

  @override
  String clearNSubtitle(int total) {
    return 'Всего записей: $total';
  }

  @override
  String get numberHint => 'Введите число';

  @override
  String get intervalDialogTitle => 'Интервал (мин)';

  @override
  String get errorTitle => 'Что-то пошло не так';

  @override
  String get retry => 'Повторить';

  @override
  String get permOffTitle => 'Уведомления отключены';

  @override
  String get permOffSubtitle => 'Нажмите, чтобы разрешить напоминания';

  @override
  String get notifMorningTitle => 'Привычки на сегодня';

  @override
  String get notifTimeToDo => 'Пора выполнить привычку';

  @override
  String get notifReminder => 'Напоминание';

  @override
  String summaryAndMore(String base, int count) {
    return '$base и ещё $count';
  }

  @override
  String get channelMorning => 'Утренняя сводка';

  @override
  String get channelHabits => 'Напоминания о привычках';

  @override
  String get channelMorningDesc => 'Сводка привычек на день';

  @override
  String get channelHabitsDesc => 'Напоминания по привычкам';

  @override
  String get actionDone => 'Выполнено';

  @override
  String get actionSnooze => 'Напомнить позже';
}
