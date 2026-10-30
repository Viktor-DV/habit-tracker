import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Трекер привычек'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In ru, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// No description provided for @navHabits.
  ///
  /// In ru, this message translates to:
  /// **'Привычки'**
  String get navHabits;

  /// No description provided for @navStats.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get navSettings;

  /// No description provided for @fabCreateHabit.
  ///
  /// In ru, this message translates to:
  /// **'Создать привычку'**
  String get fabCreateHabit;

  /// No description provided for @homeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get homeTitle;

  /// No description provided for @today.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In ru, this message translates to:
  /// **'Вчера'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In ru, this message translates to:
  /// **'Завтра'**
  String get tomorrow;

  /// No description provided for @filterAllActive.
  ///
  /// In ru, this message translates to:
  /// **'Все активные'**
  String get filterAllActive;

  /// No description provided for @emptyNoHabitsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Привычек нет'**
  String get emptyNoHabitsTitle;

  /// No description provided for @emptyNoHabitsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите + чтобы создать первую привычку'**
  String get emptyNoHabitsSubtitle;

  /// No description provided for @emptyNoActiveTitle.
  ///
  /// In ru, this message translates to:
  /// **'Нет активных привычек'**
  String get emptyNoActiveTitle;

  /// No description provided for @emptyNoActiveSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Создайте первую привычку, нажав +'**
  String get emptyNoActiveSubtitle;

  /// No description provided for @resetSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get resetSkip;

  /// No description provided for @resetReset.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get resetReset;

  /// No description provided for @quantityValueHint.
  ///
  /// In ru, this message translates to:
  /// **'Значение'**
  String get quantityValueHint;

  /// No description provided for @negSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Успех'**
  String get negSuccess;

  /// No description provided for @negFailure.
  ///
  /// In ru, this message translates to:
  /// **'Срыв'**
  String get negFailure;

  /// No description provided for @negSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропуск'**
  String get negSkip;

  /// No description provided for @allHabitsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Все привычки'**
  String get allHabitsTitle;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск привычек…'**
  String get searchHint;

  /// No description provided for @filterActive.
  ///
  /// In ru, this message translates to:
  /// **'Активные'**
  String get filterActive;

  /// No description provided for @filterInactive.
  ///
  /// In ru, this message translates to:
  /// **'Неактивные'**
  String get filterInactive;

  /// No description provided for @filterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get filterAll;

  /// No description provided for @kindPositive.
  ///
  /// In ru, this message translates to:
  /// **'Позитивные'**
  String get kindPositive;

  /// No description provided for @kindNegative.
  ///
  /// In ru, this message translates to:
  /// **'Негативные'**
  String get kindNegative;

  /// No description provided for @reorderDone.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get reorderDone;

  /// No description provided for @reorderSort.
  ///
  /// In ru, this message translates to:
  /// **'Сортировать'**
  String get reorderSort;

  /// No description provided for @emptyHabitsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Привычек нет'**
  String get emptyHabitsTitle;

  /// No description provided for @emptyHabitsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Создайте первую привычку, нажав +'**
  String get emptyHabitsSubtitle;

  /// No description provided for @reorderHint.
  ///
  /// In ru, this message translates to:
  /// **'Перетащите для изменения порядка'**
  String get reorderHint;

  /// No description provided for @metaPositive.
  ///
  /// In ru, this message translates to:
  /// **'Позитивная'**
  String get metaPositive;

  /// No description provided for @metaNegative.
  ///
  /// In ru, this message translates to:
  /// **'Негативная'**
  String get metaNegative;

  /// No description provided for @metaInactive.
  ///
  /// In ru, this message translates to:
  /// **'Неактивна'**
  String get metaInactive;

  /// No description provided for @repeatEveryDay.
  ///
  /// In ru, this message translates to:
  /// **'Каждый день'**
  String get repeatEveryDay;

  /// No description provided for @repeatSelectedWeekdays.
  ///
  /// In ru, this message translates to:
  /// **'По дням'**
  String get repeatSelectedWeekdays;

  /// No description provided for @repeatEveryNDays.
  ///
  /// In ru, this message translates to:
  /// **'Через N дней'**
  String get repeatEveryNDays;

  /// No description provided for @repeatNTimesPerNDays.
  ///
  /// In ru, this message translates to:
  /// **'N раз за N дней'**
  String get repeatNTimesPerNDays;

  /// No description provided for @deleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить привычку?'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Все записи тоже будут удалены.'**
  String get deleteBody;

  /// No description provided for @deleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get deleteConfirm;

  /// No description provided for @editTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get editTooltip;

  /// No description provided for @toggleActivate.
  ///
  /// In ru, this message translates to:
  /// **'Активизировать'**
  String get toggleActivate;

  /// No description provided for @toggleDeactivate.
  ///
  /// In ru, this message translates to:
  /// **'Деактивировать'**
  String get toggleDeactivate;

  /// No description provided for @badgeActive.
  ///
  /// In ru, this message translates to:
  /// **'Активна'**
  String get badgeActive;

  /// No description provided for @badgeInactive.
  ///
  /// In ru, this message translates to:
  /// **'Неактивна'**
  String get badgeInactive;

  /// No description provided for @badgePositive.
  ///
  /// In ru, this message translates to:
  /// **'Позитивная'**
  String get badgePositive;

  /// No description provided for @badgeNegative.
  ///
  /// In ru, this message translates to:
  /// **'Негативная'**
  String get badgeNegative;

  /// No description provided for @infoTitle.
  ///
  /// In ru, this message translates to:
  /// **'Информация'**
  String get infoTitle;

  /// No description provided for @infoMechanics.
  ///
  /// In ru, this message translates to:
  /// **'Механика'**
  String get infoMechanics;

  /// No description provided for @infoGoal.
  ///
  /// In ru, this message translates to:
  /// **'Цель'**
  String get infoGoal;

  /// No description provided for @infoSchedule.
  ///
  /// In ru, this message translates to:
  /// **'Расписание'**
  String get infoSchedule;

  /// No description provided for @infoStart.
  ///
  /// In ru, this message translates to:
  /// **'Начало'**
  String get infoStart;

  /// No description provided for @infoCreated.
  ///
  /// In ru, this message translates to:
  /// **'Создана'**
  String get infoCreated;

  /// No description provided for @completionYesNo.
  ///
  /// In ru, this message translates to:
  /// **'Да / Нет'**
  String get completionYesNo;

  /// No description provided for @completionQuantity.
  ///
  /// In ru, this message translates to:
  /// **'Количество'**
  String get completionQuantity;

  /// No description provided for @completionTime.
  ///
  /// In ru, this message translates to:
  /// **'Время'**
  String get completionTime;

  /// No description provided for @completionAvoidance.
  ///
  /// In ru, this message translates to:
  /// **'Избегание'**
  String get completionAvoidance;

  /// No description provided for @scheduleEveryDay.
  ///
  /// In ru, this message translates to:
  /// **'Каждый день'**
  String get scheduleEveryDay;

  /// No description provided for @scheduleSelectedWeekdays.
  ///
  /// In ru, this message translates to:
  /// **'По дням недели'**
  String get scheduleSelectedWeekdays;

  /// No description provided for @scheduleEveryNDays.
  ///
  /// In ru, this message translates to:
  /// **'Каждые {count} дн.'**
  String scheduleEveryNDays(int count);

  /// No description provided for @scheduleNTimesPerNDays.
  ///
  /// In ru, this message translates to:
  /// **'{goalCount} раз за {periodDays} дн.'**
  String scheduleNTimesPerNDays(int goalCount, int periodDays);

  /// No description provided for @metricsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get metricsTitle;

  /// No description provided for @metricStreak.
  ///
  /// In ru, this message translates to:
  /// **'Серия'**
  String get metricStreak;

  /// No description provided for @metricBest.
  ///
  /// In ru, this message translates to:
  /// **'Рекорд'**
  String get metricBest;

  /// No description provided for @metricDone.
  ///
  /// In ru, this message translates to:
  /// **'Выполнено'**
  String get metricDone;

  /// No description provided for @metric30days.
  ///
  /// In ru, this message translates to:
  /// **'30 дней'**
  String get metric30days;

  /// No description provided for @chartWeekly.
  ///
  /// In ru, this message translates to:
  /// **'По неделям'**
  String get chartWeekly;

  /// No description provided for @weekThis.
  ///
  /// In ru, this message translates to:
  /// **'Эта'**
  String get weekThis;

  /// No description provided for @historyTitle.
  ///
  /// In ru, this message translates to:
  /// **'История (последние 3 месяца)'**
  String get historyTitle;

  /// No description provided for @timerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Таймер'**
  String get timerTitle;

  /// No description provided for @timerSaveQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить время?'**
  String get timerSaveQuestion;

  /// No description provided for @timerSaveBody.
  ///
  /// In ru, this message translates to:
  /// **'Прошло {duration}. Сохранить как выполнение?'**
  String timerSaveBody(String duration);

  /// No description provided for @timerNo.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get timerNo;

  /// No description provided for @timerSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get timerSave;

  /// No description provided for @timerSaved.
  ///
  /// In ru, this message translates to:
  /// **'Сохранено: {minutes} мин'**
  String timerSaved(int minutes);

  /// No description provided for @timerStart.
  ///
  /// In ru, this message translates to:
  /// **'Старт'**
  String get timerStart;

  /// No description provided for @timerStop.
  ///
  /// In ru, this message translates to:
  /// **'Стоп'**
  String get timerStop;

  /// No description provided for @timerReset.
  ///
  /// In ru, this message translates to:
  /// **'Сброс'**
  String get timerReset;

  /// No description provided for @unitMinutes.
  ///
  /// In ru, this message translates to:
  /// **'мин'**
  String get unitMinutes;

  /// No description provided for @formCreateTitle.
  ///
  /// In ru, this message translates to:
  /// **'Создать привычку'**
  String get formCreateTitle;

  /// No description provided for @formEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get formEditTitle;

  /// No description provided for @formSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get formSave;

  /// No description provided for @formCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get formCreate;

  /// No description provided for @visualLabel.
  ///
  /// In ru, this message translates to:
  /// **'Визуал'**
  String get visualLabel;

  /// No description provided for @visualEmoji.
  ///
  /// In ru, this message translates to:
  /// **'Эмодзи'**
  String get visualEmoji;

  /// No description provided for @visualIcon.
  ///
  /// In ru, this message translates to:
  /// **'Иконка'**
  String get visualIcon;

  /// No description provided for @colorLabel.
  ///
  /// In ru, this message translates to:
  /// **'Цвет'**
  String get colorLabel;

  /// No description provided for @emojiHint.
  ///
  /// In ru, this message translates to:
  /// **'Вставьте эмодзи'**
  String get emojiHint;

  /// No description provided for @titleDescLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название и описание'**
  String get titleDescLabel;

  /// No description provided for @titleHint.
  ///
  /// In ru, this message translates to:
  /// **'Название привычки *'**
  String get titleHint;

  /// No description provided for @titleRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите название'**
  String get titleRequired;

  /// No description provided for @descHint.
  ///
  /// In ru, this message translates to:
  /// **'Описание (необязательно)'**
  String get descHint;

  /// No description provided for @mechanicsTypeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get mechanicsTypeLabel;

  /// No description provided for @mechanicsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Механика'**
  String get mechanicsLabel;

  /// No description provided for @goalLabel.
  ///
  /// In ru, this message translates to:
  /// **'Цель'**
  String get goalLabel;

  /// No description provided for @targetValueHint.
  ///
  /// In ru, this message translates to:
  /// **'Значение'**
  String get targetValueHint;

  /// No description provided for @targetUnitTimeHint.
  ///
  /// In ru, this message translates to:
  /// **'мин / ч'**
  String get targetUnitTimeHint;

  /// No description provided for @targetUnitOtherHint.
  ///
  /// In ru, this message translates to:
  /// **'единица'**
  String get targetUnitOtherHint;

  /// No description provided for @timerOnScreen.
  ///
  /// In ru, this message translates to:
  /// **'Таймер на экране привычки'**
  String get timerOnScreen;

  /// No description provided for @scheduleLabel.
  ///
  /// In ru, this message translates to:
  /// **'Расписание'**
  String get scheduleLabel;

  /// No description provided for @everyNDaysLabel.
  ///
  /// In ru, this message translates to:
  /// **'Каждые N дней'**
  String get everyNDaysLabel;

  /// No description provided for @timesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Раз'**
  String get timesLabel;

  /// No description provided for @inNDaysLabel.
  ///
  /// In ru, this message translates to:
  /// **'в N дней'**
  String get inNDaysLabel;

  /// No description provided for @startDateLabel.
  ///
  /// In ru, this message translates to:
  /// **'Дата старта'**
  String get startDateLabel;

  /// No description provided for @notificationsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notificationsLabel;

  /// No description provided for @reminderTimeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Время напоминаний'**
  String get reminderTimeLabel;

  /// No description provided for @addTime.
  ///
  /// In ru, this message translates to:
  /// **'Добавить время'**
  String get addTime;

  /// No description provided for @notifOff.
  ///
  /// In ru, this message translates to:
  /// **'Выкл'**
  String get notifOff;

  /// No description provided for @notifMorning.
  ///
  /// In ru, this message translates to:
  /// **'Утром'**
  String get notifMorning;

  /// No description provided for @notifMorningPlus.
  ///
  /// In ru, this message translates to:
  /// **'Утром + своё время'**
  String get notifMorningPlus;

  /// No description provided for @templateTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая привычка'**
  String get templateTitle;

  /// No description provided for @customHabit.
  ///
  /// In ru, this message translates to:
  /// **'Своя привычка'**
  String get customHabit;

  /// No description provided for @customHabitSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Настрой с нуля'**
  String get customHabitSubtitle;

  /// No description provided for @statsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get statsTitle;

  /// No description provided for @period7.
  ///
  /// In ru, this message translates to:
  /// **'7 дней'**
  String get period7;

  /// No description provided for @period30.
  ///
  /// In ru, this message translates to:
  /// **'Месяц'**
  String get period30;

  /// No description provided for @period90.
  ///
  /// In ru, this message translates to:
  /// **'3 месяца'**
  String get period90;

  /// No description provided for @periodYear.
  ///
  /// In ru, this message translates to:
  /// **'Год'**
  String get periodYear;

  /// No description provided for @emptyStatsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет данных'**
  String get emptyStatsTitle;

  /// No description provided for @emptyStatsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Отмечайте привычки, чтобы видеть прогресс'**
  String get emptyStatsSubtitle;

  /// No description provided for @avgCompletion.
  ///
  /// In ru, this message translates to:
  /// **'Среднее\nвыполнение'**
  String get avgCompletion;

  /// No description provided for @totalDone.
  ///
  /// In ru, this message translates to:
  /// **'Всего\nвыполнено'**
  String get totalDone;

  /// No description provided for @bestHabit.
  ///
  /// In ru, this message translates to:
  /// **'Лучшая'**
  String get bestHabit;

  /// No description provided for @trendTitle.
  ///
  /// In ru, this message translates to:
  /// **'ДИНАМИКА'**
  String get trendTitle;

  /// No description provided for @noData.
  ///
  /// In ru, this message translates to:
  /// **'Нет данных'**
  String get noData;

  /// No description provided for @byHabitTitle.
  ///
  /// In ru, this message translates to:
  /// **'ПО ПРИВЫЧКАМ'**
  String get byHabitTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @appearanceSection.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get appearanceSection;

  /// No description provided for @notificationsSection.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notificationsSection;

  /// No description provided for @daySection.
  ///
  /// In ru, this message translates to:
  /// **'День'**
  String get daySection;

  /// No description provided for @historySection.
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get historySection;

  /// No description provided for @themeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get themeLabel;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @dndTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заглушить все уведомления'**
  String get dndTitle;

  /// No description provided for @dndSubtitleOff.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления активны'**
  String get dndSubtitleOff;

  /// No description provided for @dndMutePeriod.
  ///
  /// In ru, this message translates to:
  /// **'Заглушить на период'**
  String get dndMutePeriod;

  /// No description provided for @dndDisable.
  ///
  /// In ru, this message translates to:
  /// **'Отключить'**
  String get dndDisable;

  /// No description provided for @dndForever.
  ///
  /// In ru, this message translates to:
  /// **'Заглушено навсегда'**
  String get dndForever;

  /// No description provided for @dndUntil.
  ///
  /// In ru, this message translates to:
  /// **'Заглушено до {date}'**
  String dndUntil(String date);

  /// No description provided for @dndMuted.
  ///
  /// In ru, this message translates to:
  /// **'Заглушено'**
  String get dndMuted;

  /// No description provided for @dayStartTitle.
  ///
  /// In ru, this message translates to:
  /// **'Начало нового дня'**
  String get dayStartTitle;

  /// No description provided for @dayStartPickerHint.
  ///
  /// In ru, this message translates to:
  /// **'Начало нового дня'**
  String get dayStartPickerHint;

  /// No description provided for @snoozeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Интервал «Напомнить позже»'**
  String get snoozeTitle;

  /// No description provided for @snoozeUnit.
  ///
  /// In ru, this message translates to:
  /// **'{minutes} мин'**
  String snoozeUnit(int minutes);

  /// No description provided for @morningSummaryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Утреннее напоминание'**
  String get morningSummaryTitle;

  /// No description provided for @morningSummarySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сводка привычек в начале нового дня ({time})'**
  String morningSummarySubtitle(String time);

  /// No description provided for @historyKeepTitle.
  ///
  /// In ru, this message translates to:
  /// **'Хранить историю'**
  String get historyKeepTitle;

  /// No description provided for @historyKeepSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Без истории долгосрочная статистика ограничена'**
  String get historyKeepSubtitle;

  /// No description provided for @historyCount.
  ///
  /// In ru, this message translates to:
  /// **'Записей: {count}  ·  Авточистка при >50 МБ'**
  String historyCount(int count);

  /// No description provided for @historyClearAll.
  ///
  /// In ru, this message translates to:
  /// **'Очистить всё'**
  String get historyClearAll;

  /// No description provided for @historyClearN.
  ///
  /// In ru, this message translates to:
  /// **'Очистить последние N'**
  String get historyClearN;

  /// No description provided for @clearAllTitle.
  ///
  /// In ru, this message translates to:
  /// **'Очистить всю историю?'**
  String get clearAllTitle;

  /// No description provided for @clearAllBody.
  ///
  /// In ru, this message translates to:
  /// **'Это действие нельзя отменить.'**
  String get clearAllBody;

  /// No description provided for @clearAllConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get clearAllConfirm;

  /// No description provided for @clearNTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить последних N записей'**
  String get clearNTitle;

  /// No description provided for @clearNSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Всего записей: {total}'**
  String clearNSubtitle(int total);

  /// No description provided for @numberHint.
  ///
  /// In ru, this message translates to:
  /// **'Введите число'**
  String get numberHint;

  /// No description provided for @intervalDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Интервал (мин)'**
  String get intervalDialogTitle;

  /// No description provided for @errorTitle.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так'**
  String get errorTitle;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @permOffTitle.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления отключены'**
  String get permOffTitle;

  /// No description provided for @permOffSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите, чтобы разрешить напоминания'**
  String get permOffSubtitle;

  /// No description provided for @notifMorningTitle.
  ///
  /// In ru, this message translates to:
  /// **'Привычки на сегодня'**
  String get notifMorningTitle;

  /// No description provided for @notifTimeToDo.
  ///
  /// In ru, this message translates to:
  /// **'Пора выполнить привычку'**
  String get notifTimeToDo;

  /// No description provided for @notifReminder.
  ///
  /// In ru, this message translates to:
  /// **'Напоминание'**
  String get notifReminder;

  /// No description provided for @summaryAndMore.
  ///
  /// In ru, this message translates to:
  /// **'{base} и ещё {count}'**
  String summaryAndMore(String base, int count);

  /// No description provided for @channelMorning.
  ///
  /// In ru, this message translates to:
  /// **'Утренняя сводка'**
  String get channelMorning;

  /// No description provided for @channelHabits.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания о привычках'**
  String get channelHabits;

  /// No description provided for @channelMorningDesc.
  ///
  /// In ru, this message translates to:
  /// **'Сводка привычек на день'**
  String get channelMorningDesc;

  /// No description provided for @channelHabitsDesc.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания по привычкам'**
  String get channelHabitsDesc;

  /// No description provided for @actionDone.
  ///
  /// In ru, this message translates to:
  /// **'Выполнено'**
  String get actionDone;

  /// No description provided for @actionSnooze.
  ///
  /// In ru, this message translates to:
  /// **'Напомнить позже'**
  String get actionSnooze;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
