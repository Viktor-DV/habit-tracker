# Состояние проекта

Этот файл агент обновляет после каждого крупного этапа.  
Цель — не перечитывать весь проект заново и быстро понимать текущее состояние.

---

## 1. Текущий статус

**Статус:**  
Этапы 0–14 завершены ✅

**Текущий этап:**  
Завершён. Проект готов к публикации в RuStore.

---

## 2. Что уже реализовано

- Flutter-проект создан, документация в `docs/`
- Базовая структура папок `lib/`
- Material 3 Notion-style тема
- go_router с `StatefulShellRoute.indexedStack`
- App shell с bottom nav (4 вкладки) + FAB
- Placeholder-экраны всех вкладок
- **Drift 2.31 + SQLite**: таблицы `habits` и `habit_entries`
- DAOs: `HabitsDao`, `EntriesDao`
- Domain-модели: `Habit`, `HabitEntry`, все enums
- Маппер `HabitRow ↔ Habit`, `HabitEntryRow ↔ HabitEntry`
- `HabitsRepository` (интерфейс + реализация)
- Riverpod-провайдеры: `appDatabaseProvider`, `habitsRepositoryProvider`
- Codegen успешно сгенерирован (`app_database.g.dart`, 2754 строк)
- **Статистика**: `statistics_calculator.dart` — чистые функции (currentStreak, bestStreak, completionRate, idealDays, periodStats), 14 unit tests. `StatisticsScreen` — период (7д/месяц/3мес/год, дефолт месяц-скользящий), summary-карточки, trend bar-chart (агрегация при длинных периодах), разбивка по привычкам с прогресс-барами, Banner stub
- **HabitDetailScreen**: SliverAppBar с градиентом, секция Info, MetricsSection (серия/рекорд/выполнено/30%), WeeklyChart (8 недель, bar chart без пакетов), MiniCalendar (последние 3 месяца), TimerSection (Stopwatch + save), Edit/ToggleActive/Delete. `entry_saver.dart` — shared helper
- **AllHabitsScreen**: фильтры (активные/неактивные/все, позитивные/негативные), поиск по названию, ручная сортировка drag-and-drop (ReorderableListView + persist sortOrder), Banner/Native ad stubs, переход в детальный экран
- **HabitCard Этап 7**: yesNo (тап=done, long-press=reset/skip), quantity/time (−/+/прогресс-бар/точный ввод/✓), negative (Успех/Срыв/Пропуск кнопки). Перевыполнение учтено (value > target → ✓ зелёный). `_saveEntry` — единая точка сохранения entries
- **HomeScreen** — месячный календарь (пн-вс), выбор даты, доты статуса (зел/жёлт/серый), список привычек на день, быстрый toggle yesNo/negative, фильтр «Все активные», кнопка «Сегодня», deep-link `highlightHabitId`
- **`selectedDateProvider`**, **`dayHabitsProvider`**, **`_monthDataProvider`** — реактивные провайдеры главного экрана
- `EntriesDao.getAllEntriesForDateRange` + `HabitsRepository.getEntriesForRange` — диапазонный запрос записей
- **19 шаблонов привычек** по 3 категориям (Здоровье, Разум, Продуктивность)
- **`TemplatePickerScreen`** — сетка шаблонов + «Своя привычка»
- **`HabitFormScreen`** — 5 секций: визуал, инфо, механика, расписание, уведомления; сохранение в БД
- Роутер: `/habits/create` → `/habits/new` → `/habits/edit`
- **`HabitDayResolver`** — логический день с учётом `dayStartHour`
- **`RepeatRuleEvaluator`** — `isExpectedOn(habit, date)` для всех 4 типов
- **`ExpectedDaysCalculator`** — `expectedDaysInRange` / `expectedCountInRange`
- **33 unit tests** — все проходят (`test/core/time/repeat_rule_test.dart`)
- **SharedPreferences** — настройки персистентны
- **`SettingsRepository`** — все поля из ТЗ: dayStart, morningReminder, snooze, DND, history
- **`SettingsNotifier`** (NotifierProvider) — мутации через notifier
- **Экран Настройки** — DND, время начала дня, snooze-интервал, история (кол-во, очистить всё/N), выбор темы (Светлая/Системная/Тёмная); `ref.listen(settingsProvider)` → пересборка уведомлений
- **Уведомления (Этап 11)**: `flutter_local_notifications 22.0.1` + `timezone` + `flutter_timezone`. `NotificationService` (обёртка: init, tz, permissions, exact-schedule, cancel; Android-specific API v22). `NotificationOrchestrator` — полная пересборка (`cancelAll` → расписание на 7-дневный горизонт через `expectedDaysInRange`, идемпотентно: пропускает сегодняшние напоминания выполненных). Утренняя сводка (1/день, список привычек), индивидуальные (action-кнопки Выполнено/Напомнить позже), автоповтор (до 2 follow-up через snooze-интервал), snooze, отмена после выполнения, DND (forever/until). Deep-link payload `habit:<id>` → подсветка на Главной. `PermissionBanner` (плашка разрешений). AndroidManifest: POST_NOTIFICATIONS / SCHEDULE_EXACT_ALARM / RECEIVE_BOOT_COMPLETED + receivers (boot/scheduled/action). Триггеры пересборки: создание/редактирование/деактивация/удаление/выполнение/настройки/cold start. 2 unit-теста на уникальность notification id
- **Монетизация (Этап 12, пересмотрено 08.07.2026)**: только Яндекс реклама. `AdsRepository` (интерфейс + `YandexAdsRepository` на `yandex_mobileads 8.1.0`) — реальные баннеры. Баннер **только на Главной** (вверху, над календарём), показывается всем. In-app покупка (RuStore Billing) и Premium **удалены**: `PremiumRepository`, `RuStorePremiumRepository`, `PaywallScreen`, `premiumProvider`/`isPremiumProvider`, `kFreeHabitLimit`, лимит 5 привычек и Premium-плашка убраны. `flutter_rustore_billing` и deeplink `rustore://` из native-конфигурации удалены. **Нативная реклама НЕ поддерживается официальным Flutter-плагином yandex_mobileads** — поэтому баннер.
- **UI Полировка (Этап 13)**: `shared/widgets/` — `EmptyStateView` (emoji + title + subtitle + action), `ErrorView` / `SliverErrorView`, `SkeletonBox` / `HabitCardSkeleton` / `SliverSkeletonList` (shimmer animation). `AdaptiveContent` / `SliverAdaptiveContent` — ограничение ширины 680px с центрированием на планшетах. Все async-зоны переведены на shared-виджеты. `TextOverflow.ellipsis` в карточках привычек и строках списков. Bottom nav получил `Divider` сверху. Удалены 3 дублирующихся `_EmptyDay`/`_EmptyState`
- **Финальная подготовка (Этап 14)**: Тема выровнена по Notion DESIGN.md (surface-soft #FAFAF9, hairline #E5E3DF, charcoal #37352F, rounded md=8px/lg=12px). `applicationId` → `ru.habitify.tracker`. `android:label` → `@string/app_name` ("Трекер привычек"). `minSdk=26` (Android 8.0+). Adaptive icon (vector XML + mipmap-anydpi-v26). Launch background → #FAFAF9. Permissions/receivers подтверждены. Нет GMS. Release APK 57.7 MB собран ✅ (debug-ключи). 49 тестов ✅
- APK собирается ✓

---

## 3. Ключевые архитектурные решения

- Flutter 3.38.10 / Dart 3.10.9
- Android only
- 100% offline
- Riverpod (`flutter_riverpod ^3.3.2`) — без codegen провайдеров
- go_router `^17.3.0` — StatefulShellRoute
- Drift 2.31.0 + sqlite3 2.9.4
- **`path_provider_android` (не `path_provider`)** — избегаем `objective_c` hook
- feature-first, pragmatic Clean Architecture
- Material 3 + Notion-style

---

## 4. Используемые пакеты

| Пакет | Версия | Назначение |
|-------|--------|------------|
| flutter_riverpod | ^3.3.2 | State management + DI |
| go_router | ^17.3.0 | Роутинг |
| drift | ^2.22.0 (resolved 2.31.0) | ORM / SQLite |
| sqlite3_flutter_libs | ^0.5.0 (resolved 0.5.42) | SQLite для Android |
| path_provider_android | ^2.3.1 | Путь к файлам (Android-only) |
| path | ^1.9.1 | Работа с путями |
| shared_preferences | latest | Локальное key-value хранилище |
| flutter_local_notifications | 22.0.1 | Локальные уведомления (Android, exact alarms) |
| timezone | 0.11.0 | TZDateTime для zonedSchedule |
| flutter_timezone | latest | Локальная IANA-таймзона устройства |
| drift_dev | ^2.31.0 | Codegen для Drift (dev) |
| build_runner | ^2.15.0 | Codegen runner (dev) |
| flutter_lints | ^6.0.0 | Linting (dev) |

---

## 5. Важное: обходной путь build_runner

**Проблема:** Dart 3.10 + `dart compile exe` падает если в дереве зависимостей есть пакет с `hook/build.dart`.  
**Причина цепочки:** `path_provider` → `path_provider_foundation` → `objective_c` (имеет hook).  
**Решение:** Заменить `path_provider` на `path_provider_android` — iOS-пакет не подтягивается.  
**Codegen теперь работает** через `dart run build_runner build`.

---

## 6. Фактическая структура проекта

```
lib/
  main.dart
  app/
    app.dart
    app_router.dart
    app_theme.dart
  core/
    database/
      app_database.dart          # @DriftDatabase + tables + DAOs (part files)
      app_database.g.dart        # сгенерировано
      habits_dao.dart            # part of app_database.dart
      entries_dao.dart           # part of app_database.dart
      database_provider.dart     # Riverpod providers
    notifications/
      notification_service.dart  # обёртка flutter_local_notifications (Android v22)
  features/
    app_shell/presentation/
      app_shell_screen.dart
    habits/
      domain/
        habit.dart
        habit_entry.dart
        habit_enums.dart
        habits_repository.dart
      data/
        habit_mapper.dart
        habits_repository_impl.dart
      presentation/
        home_screen.dart
        all_habits_screen.dart
    statistics/presentation/statistics_screen.dart
    settings/
      domain/settings.dart
      data/settings_repository.dart
      presentation/settings_screen.dart
    notifications/
      domain/notification_orchestrator.dart   # пересборка расписания + id-packing
      data/notification_providers.dart         # провайдеры service/orchestrator/permission/highlight
      data/notification_handler.dart           # ответы на пуши (tap/Выполнено/Напомнить позже)
      presentation/permission_banner.dart      # плашка разрешений
```

> `android/app/build.gradle.kts`: включён `coreLibraryDesugaring` + `desugar_jdk_libs:2.1.4` (требование flutter_local_notifications).

---

## 7. Готовые модули

| Модуль | Статус | Комментарий |
|--------|--------|-------------|
| app_shell | Готов (базовый) | Shell + bottom nav + FAB |
| habits/domain | Готов | Модели, enums, интерфейс репозитория |
| habits/data | Готов (базовый) | Drift DAOs, маппер, реализация репо |
| core/database | Готов | AppDatabase, таблицы, DAOs |
| core/time | Готов | HabitDayResolver, RepeatRuleEvaluator, ExpectedDaysCalculator |
| statistics | Готов | calculators + 14 tests, StatisticsScreen |
| habits/domain (templates) | Готов | 19 шаблонов, HabitTemplate |
| habits/presentation (form) | Готов | TemplatePickerScreen, HabitFormScreen |
| settings/domain | Готов | Settings model + DndMode enum |
| settings/data | Готов | SettingsRepository + SettingsNotifier |
| settings/presentation | Готов | Полный экран Настройки |
| notifications | Готов | NotificationService + Orchestrator, утренние/индивид/snooze/DND/boot, PermissionBanner, 2 теста |
| monetization | Готов (только Яндекс реклама) | AdsRepository → YandexAdsRepository (yandex_mobileads), баннер только на Главной; покупка/Premium удалены |
| shared/ui | Не начат | |

---

## 8. Известные технические долги

- `riverpod_generator` не подключён (конфликт с `flutter_riverpod 3.3.2`) — провайдеры вручную
- Codegen нужно перезапускать при изменении схемы: `dart run build_runner build`
- Плашка разрешений: тап повторно запрашивает разрешение, но не открывает системные настройки Android напрямую (отложено — потребовало бы `android_intent_plus`/`app_settings`). См. ponytail-коммент в `permission_banner.dart`
- Автоповтор/snooze: локальные пуши не читают БД, поэтому follow-up'ы ограничены (`_maxAutoRepeats=2`) и гасятся при выполнении + ежедневной пересборке. Action-кнопки обрабатываются в foreground; в фоне OS гасит пуш, действие применяется при следующем открытии (ponytail-коммент в `notification_service.dart`)

---

## 9. Важные ограничения

- Android only — `path_provider_android` напрямую
- Не использовать Firebase, серверы, облако
- Не хранить пустые habit_entries заранее
- Не считать статистику в UI
- Не обращаться к SDK напрямую из экранов

---

## 10. Последние изменения

- Дата: 24.06.2026
- Этап: 14 — Финальная проверка и подготовка к RuStore
- Что сделано: Тема → Notion DESIGN.md tokens (поверхности, hairline, радиусы). `applicationId=ru.habitify.tracker`. App name = "Трекер привычек" (strings.xml). `minSdk=26`. Adaptive icon vector + mipmap-anydpi-v26. Launch background Notion warm. Manifest: все permissions + receivers проверены. GMS: не используются. Release APK 57.7 MB собран на debug-подписи.
- Ключевые файлы: `lib/app/app_theme.dart`, `android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/res/values/strings.xml`, `android/app/src/main/res/mipmap-anydpi-v26/`, `android/app/src/main/res/drawable/ic_launcher_*.xml`
- Проблемы: нет
- Тесты: 49 всего, все зелёные
- Следующий шаг: Проект завершён. При публикации заменить debug-подпись на production keystore

---

## 10.1. Дополнение — реальная монетизация (08.07.2026)

- Этап: донастройка монетизации (вне плана 0–14)
- Что сделано:
  - pubspec.yaml: добавлены yandex_mobileads ^8.1.0 и flutter_rustore_billing ^10.3.1
  - android/build.gradle.kts: maven-репозиторий https://maven.rustore.ru (нативный billing-client)
  - AndroidManifest.xml: deeplink intent-filter rustore:// для возврата из оплаты
  - RuStorePremiumRepository вместо Stub — реальная покупка premium_forever через RustoreBillingClient (initialize/purchase/purchases), статус в SharedPreferences
  - YandexAdsRepository вместо Stub — YandexAds.initialize()
  - YandexBannerAd — реальный баннер (BannerAd + AdWidget); заменены заглушки в all_habits_screen, statistics_screen, settings_screen
  - main.dart: инициализация обеих SDK на старте
- Проверка: flutter analyze без ошибок; flutter test — 49 зелёных; flutter build apk --debug — собран
- Ограничение: нативная реклама в yandex_mobileads не поддерживается → inline-баннер в списке
- Следующий шаг: создать продукт premium_forever в RuStore Console; вывести приложение из тестового режима в Яндекс.Паблишер

---

## 10.2. Дополнение — UI-правки и тёмная тема (08.07.2026)

- Этап: правки UI (вне плана 0–14)
- Что сделано:
  - FAB: скрыт на вкладке «Настройки» (`app_shell_screen.dart` — `floatingActionButton: null` при `currentIndex == 3`); остаётся на Главной/Привычках/Статистике
  - Баннер Яндекса добавлен вверху Главной (`home_screen.dart`, только Free) — **отклонение от product_spec §5.3** (Главная там без рекламы); сделано по прямому запросу
  - Тёмная тема: переключатель Светлая/Системная/Тёмная в Настройках (`_ThemeModeTile`, `themeModeProvider`, `ThemeModeOption`)
    - `app_theme.dart`: `AppTheme` сделан темозависимым (геттеры читают `_currentMode`), добавлен `darkAppThemeData()`; тёмные токены ВЫВЕДЕНЫ (в notion_DESIGN.md их нет — Known Gaps)
    - `app.dart`: `ConsumerWidget`, смотрит `themeModeProvider`, применяет `themeMode` + `darkTheme`
    - Настройка сохраняется в SharedPreferences (`theme_mode`); применяется на лету без рестарта
- Проверка: flutter analyze без ошибок; flutter test — 49 зелёных; flutter build apk --debug — собран (29.7s)
- Заметка: тёмные токены не из design-дока (дока их не содержит) — подобраны в духе Notion. Визуально тёмная тема не верифицировалась (нет скриншотов).

---

## 11. Graphify — граф знаний

Graphify установлен (`graphify 0.8.38`), Cursor-правило: `.cursor/rules/graphify.mdc`.  
Граф последний раз строился: **08.07.2026** (после поворота на ads-only).

Результат: `lib/graphify-out/` (1047 узлов, 1446 рёбер, 79 сообществ); отчёт `lib/graphify-out/GRAPH_REPORT.md`.  
Примечание: graphify пишет вывод в подпапку сканируемой директории (`lib/graphify-out/`), а не в корень — рекомендуется добавить `lib/graphify-out/` в `.gitignore`.  
Центральные узлы (исторически): `AppDatabase`, `HabitsRepository`, `NotificationOrchestrator`, `AppTheme`.

После каждого крупного этапа запускать:
```
graphify lib/ --no-viz
graphify cluster-only lib/ --no-label
```

---

## 10.3. Дополнение — поворот на ads-only (08.07.2026)

- Причина: продажа приложения через RuStore недоступна, оставляем только рекламу.
- Что сделано:
  - Удалён in-app purchase и Premium целиком: `PremiumRepository` (интерфейс), `RuStorePremiumRepository`, `PaywallScreen`, `premiumProvider`/`isPremiumProvider`/`premiumRepositoryProvider`, `PremiumNotifier`, `kFreeHabitLimit`, `PremiumStatus`. Удалён пакет `flutter_rustore_billing` и deeplink `rustore://` из `AndroidManifest.xml`, убран maven `maven.rustore.ru` из `android/build.gradle.kts`.
  - FAB: убран лимит 5 привычек и редирект на Paywall — теперь просто открывает создание привычки.
  - Баннер Яндекса **оставлен только на Главной** (вверху, над календарём), показывается всем (без проверки Premium). Убран с экранов «Все привычки», «Статистика», «Настройки» (в т.ч. inline-баннер в списке).
  - В Настройках убран `_PremiumTile`; блок «Оформление» с выбором темы оставлен.
  - Из `Settings` удалено поле `premiumCachedStatus` (+ репозиторий/нотифайер).
- Тема по умолчанию: **Системная** (раньше была Светлая) — `theme_mode_provider.dart` читает `'system'`.
- Проверка: flutter pub get; flutter analyze без ошибок; flutter test — 49 зелёных; flutter build apk --debug — собран (52.6s)
- Заметка: разделы 10.1 (реальная монетизация) и часть 10.2 теперь исторические — актуально состояние из 10.3.

---

## 10.4. Дополнение — фиксы и релиз 1.0.0 (15.07.2026)

- Баг 1 (тёмная тема на Статистике): карточки статистики хардкодили `color: Colors.white` → заменено на mode-aware `AppTheme.surfaceColor` (3 карточки: _StatCard, _TrendChart, _HabitBreakdown). Зелёный акцент 100% (`0xFF43C59E`) и белый текст на активном chip оставлены намеренно.
- Баг 2 (новая привычка не появляется на Главной без перезапуска): Home-таб живёт в IndexedStack (StatefulShellRoute) → его `autoDispose` провайдеры не пересоздавались. Добавлен сигнал `habitsRevisionProvider` (`Notifier<int>` в `database_provider.dart`). Его смотрят `dayHabitsProvider`, `_monthDataProvider`, `_allActiveProvider`, `_allHabitsProvider`, `_statsProvider`. Бамп (`.bump()`) на всех мутациях: создание/редактирование (form `_save`), reorder (all_habits), удаление и toggle-active (detail).
- Версия: `pubspec.yaml` → **1.0.0+1** (было 0.1.0).
- Проверка: flutter analyze без ошибок; flutter test — 49 зелёных.
- Не верифицировано визуально: тёмная тема (нужен прогон на устройстве).
- Устранено ограничение: переключение отметки «выполнено» и сброс/удаление отметки на Главной теперь бампит `habitsRevisionProvider`, на который смотрит `_statsProvider` — экран Статистики обновляется мгновенно (оба таба живут в IndexedStack, провайдер остаётся живым и автоматически пересчитывается).

---

## 12. Следующий шаг

Проект готов к публикации. Перед RuStore:
1. Production-подпись уже настроена: `android/habitify-release.jks` (alias `habitify`) + `android/key.properties`, release-сборка подписывается автоматически. Оба файла gitignored — при публикации на новой машине не забудьте перенести их (иначе release-сборка упадёт).
2. Активировать рекламный блок `R-M-19502100-1` в Яндекс.Паблишер (приложение выведено из тестового режима, добавлена ссылка на приложение) — иначе баннеры не будут отдаваться
3. Прогнать тёмную тему на реальном устройстве (визуально не верифицирована).
4. Первая публикация в RuStore — вручную (автопубликация с GitHub требует хотя бы одного ручного релиза).

Примечание: нативная реклама через `yandex_mobileads` недоступна (плагин поддерживает только Banner/Interstitial/Rewarded/AppOpen); используется баннер.
