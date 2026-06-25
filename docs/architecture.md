# Архитектура Flutter-приложения «Трекер привычек»

## 1. Общий контекст

Приложение — полностью offline-трекер привычек для Android / RuStore.

### Основные требования
- Flutter
- Android only
- Android 8.0+ / API 26+
- RuStore
- телефоны + планшеты
- 100% offline
- без аккаунтов, серверов, синхронизации, аналитики
- локальная БД
- локальные уведомления
- Premium через RuStore Billing
- реклама через Яндекс Mobile Ads
- по возможности без зависимости от Google Play Services

### Главные документы
- `docs/product_spec.md` — продуктовые требования
- `docs/design.md` — дизайн-направление
- `docs/agent_rules.md` — правила для агента
- `docs/implementation_plan.md` — план по этапам
- `docs/project_state.md` — текущее состояние проекта

---

## 2. Базовый стек

### UI / App
- Flutter
- Dart
- Material 3 как база
- кастомная тема поверх Material 3

### State management и DI
Использовать:
- **Riverpod**

Riverpod используется и для:
- состояния UI
- dependency injection
- доступа к репозиториям и сервисам
- асинхронных состояний

Отдельный `get_it` не использовать.

### Роутинг
Использовать:
- **go_router**

Причины:
- удобно для bottom navigation
- удобно для переходов из уведомлений
- удобно для shell-структуры приложения

### Локальное хранение
Использовать:
- **Drift / SQLite** — для привычек, истории и связанных сущностей
- **SharedPreferences** — для глобальных настроек

### Code generation
Разрешён умеренный codegen там, где он действительно полезен:
- Drift
- Riverpod generator, если это упрощает код
- immutable / serializable подходы, если они не раздувают проект

Codegen не использовать без необходимости.

---

## 3. Архитектурный стиль

Использовать:
- **feature-first**
- **прагматичная Clean Architecture**

Внутри фич допустимы слои:
- `presentation`
- `domain`
- `data`

### Принципы
- не делать use case на каждый простой вызов
- не плодить лишние абстракции
- не писать тяжёлую бизнес-логику в UI
- не смешивать SQL, UI и SDK вызовы

---

## 4. Рекомендуемая структура проекта

~~~text
lib/
  main.dart

  app/
    app.dart
    app_router.dart
    app_theme.dart

  core/
    constants/
    errors/
    utils/
    database/
    preferences/
    time/
    notifications/
    monetization/

  shared/
    widgets/
    ui/
    extensions/
    formatters/

  features/
    app_shell/
      presentation/

    habits/
      data/
      domain/
      presentation/

    statistics/
      data/
      domain/
      presentation/

    notifications/
      data/
      domain/
      presentation/

    settings/
      data/
      domain/
      presentation/

    monetization/
      data/
      domain/
      presentation/
~~~

### Назначение директорий

#### `app/`
Глобальная сборка:
- `MaterialApp`
- `go_router`
- тема
- корневая конфигурация приложения

#### `core/`
Общие технические компоненты:
- БД
- SharedPreferences
- работа со временем
- низкоуровневые адаптеры
- ошибки
- утилиты

#### `shared/`
Переиспользуемый UI:
- карточки
- кнопки
- элементы календаря
- заглушки
- форматтеры
- небольшие shared widgets

#### `features/`
Фичи продукта.

---

## 5. Основные модули

### 5.1 `app_shell`
Отвечает за:
- 4 вкладки
- нижнюю навигацию
- shell layout
- FAB создания привычки

Вкладки:
1. Главная
2. Все привычки
3. Статистика
4. Настройки

### 5.2 `habits`
Главная фича приложения.

Отвечает за:
- создание привычки
- редактирование
- удаление
- активность / неактивность
- список привычек
- карточки привычек
- выполнение привычек
- календарь / план
- историю выполнения
- расписания
- редактирование прошлых дней

### 5.3 `statistics`
Отвечает за:
- глобальную статистику
- статистику по одной привычке
- графики
- серии
- процент успешности
- идеальные дни
- расчёты за периоды

### 5.4 `notifications`
Отдельный модуль уведомлений.

Отвечает за:
- локальные уведомления
- точные уведомления
- общее утреннее уведомление
- индивидуальные уведомления привычек
- автоповтор
- snooze
- отмену пушей
- восстановление после перезагрузки
- пересборку расписания уведомлений

### 5.5 `settings`
Отвечает за:
- время начала нового дня
- общее уведомление
- интервал snooze / автоповтора
- DND
- управление историей
- отображение объёма истории
- раздел Premium в настройках

### 5.6 `monetization`
Отвечает за:
- RuStore Billing
- Premium-статус
- локальный кэш Premium
- Яндекс рекламу
- Paywall

---

## 6. Слои внутри фич

### `presentation`
Содержит:
- screens
- widgets
- providers / controllers
- UI state
- loading / error / empty states

Не должно содержать:
- SQL
- тяжёлую бизнес-логику статистики
- логику repeat rules
- прямые вызовы SDK рекламы / биллинга / уведомлений

### `domain`
Содержит:
- entities
- enums
- value objects
- calculators
- rules
- чистую бизнес-логику

Примеры:
- `HabitDayResolver`
- `RepeatRuleEvaluator`
- `ExpectedDaysCalculator`
- `StreakCalculator`
- `BestStreakCalculator`
- `CompletionRateCalculator`
- `PeriodStatsCalculator`
- `IdealDaysCalculator`
- `HistoryCleanupPolicy`

### `data`
Содержит:
- Drift таблицы
- DAO
- data models
- converters
- реализации репозиториев
- mapping между data и domain

---

## 7. Репозитории

Использовать отдельные репозитории по контекстам.

Пример:
- `HabitsRepository`
- `SettingsRepository`
- `NotificationsScheduler` / `NotificationsRepository`
- `PremiumRepository`
- `AdsRepository`

Не делать один большой `AppRepository`.

### Статистика
Статистику в MVP считать на лету.
Отдельный `StatisticsRepository` добавлять только если реально понадобится.

---

## 8. База данных

### Общий принцип
Использовать Drift / SQLite.

Правила:
- отдельные таблицы по сущностям
- DAO по контекстам
- converters для JSON-полей
- миграции Drift при изменении схемы

---

## 9. Таблица `habits`

### Смысловые поля
- `id`
- `title`
- `description`
- `habit_kind`
- `completion_type`
- `visual_type`
- `icon_name`
- `emoji`
- `photo_path`
- `color_value`
- `target_value`
- `target_unit`
- `repeat_type`
- `repeat_days_json`
- `repeat_interval`
- `repeat_goal_count`
- `repeat_period_days`
- `repeat_start_date`
- `is_active`
- `created_at`
- `notification_mode`
- `notification_times_json`
- `timer_enabled`
- `sort_order`

### Пояснения

#### `habit_kind`
- `positive`
- `negative`

#### `completion_type`
- `yes_no`
- `quantity`
- `time`
- `avoidance`

#### `visual_type`
- `icon`
- `emoji`
- `photo`

#### `repeat_type`
- `every_day`
- `selected_weekdays`
- `every_n_days`
- `n_times_per_n_days`

#### `repeat_days_json`
Пример:
~~~text
[1,3,5]
~~~

Где:
- 1 = Monday
- 7 = Sunday

#### `repeat_interval`
Для режима `every_n_days`.

#### `repeat_goal_count`
Для режима `n_times_per_n_days`, например 3.

#### `repeat_period_days`
Для режима `n_times_per_n_days`, например 5.

#### `repeat_start_date`
Дата старта привычки. От неё считаются периоды.

#### `notification_times_json`
Пример:
~~~text
["09:00", "20:00"]
~~~

---

## 10. Таблица `habit_entries`

Хранить только явные действия пользователя.

Если ожидаемый день прошёл и записи нет:
- для позитивной привычки это считается `not_done`
- для негативной привычки это считается `failure`

### Смысловые поля
- `id`
- `habit_id`
- `date`
- `status`
- `value`
- `created_at`
- `updated_at`

### `date`
Хранить дату habit-day без точного времени.
Нужно учитывать глобальное время начала дня.

### `status`
Для позитивных:
- `done`
- `skipped`

Для негативных:
- `success`
- `failure`
- `skipped`

Отсутствие записи обрабатывается бизнес-логикой.

### `value`
- для yes/no: можно хранить 1
- для quantity: фактическое число
- для time: фактические минуты
- для avoidance: значение по смыслу статуса

Перевыполнение допускается.

---

## 11. История и очистка

История хранится в `habit_entries`.

### Правила
- история включена по умолчанию
- при превышении 50 МБ автоматически удаляются самые старые записи
- пользователь может:
  - очистить всё
  - очистить последние N записей
  - выключить хранение истории

Если история выключена:
- приложение продолжает работать
- долгосрочная статистика может быть ограничена
- UI должен это корректно объяснять

---

## 12. Настройки

Настройки хранить в SharedPreferences.

### Ключевые настройки
- `day_start_time`
- `morning_summary_enabled`
- `snooze_interval_minutes`
- `dnd_mode`
- `dnd_until`
- `history_enabled`
- `history_auto_limit_mb`
- `premium_cached_status`
- `ads_enabled`

---

## 13. Время и habit-day

Нужен единый компонент для расчёта habit-day.

Пример:
- `HabitDayResolver`

Он должен:
- определять текущий habit-day
- определять, к какому habit-day относится timestamp
- учитывать время начала дня, по умолчанию 06:00

Эта логика не должна дублироваться по UI.

---

## 14. Repeat rules и expected days

Логика определения, ожидается ли привычка в конкретный день, должна жить в `domain`.

Нужны компоненты:
- `RepeatRuleEvaluator`
- `ExpectedDaysCalculator`

### Правила

#### `every_day`
Привычка ожидается каждый habit-day.

#### `selected_weekdays`
Ожидается только в выбранные дни недели.

#### `every_n_days`
Отсчёт идёт от `repeat_start_date`.

#### `n_times_per_n_days`
Используются фиксированные периоды от `repeat_start_date`.

Пример:
- 3 раза в 5 дней
- старт 1 января
- период 1: 1–5 января
- период 2: 6–10 января

Серия считается по завершённым периодам.

---

## 15. Статистика

### Общий принцип
Статистика считается на лету из:
- привычек
- расписаний
- entries
- периодов активности / неактивности

Предрасчитанные агрегаты в MVP не хранить.

### Обязательные calculators
- `StreakCalculator`
- `BestStreakCalculator`
- `CompletionRateCalculator`
- `PeriodStatsCalculator`
- `IdealDaysCalculator`
- `ExpectedDaysCalculator`

### Что учитывать
- пропуск без штрафа замораживает серию
- неактивные периоды исключаются
- отсутствие записи в прошедший ожидаемый день = not done / failure
- изменение расписания влияет только на будущее
- перевыполнение отражается в статистике

---

## 16. Уведомления

### Архитектурный подход
Использовать отдельный сервис:
- `NotificationScheduler`
- или `NotificationOrchestrator`

Он отвечает за:
- постановку уведомлений
- отмену уведомлений
- пересборку расписания
- восстановление после перезагрузки
- snooze
- автоповтор
- утреннее общее уведомление
- индивидуальные уведомления

### Когда пересобирать уведомления
Обязательные триггеры:
- создание привычки
- редактирование привычки
- удаление привычки
- активация привычки
- деактивация привычки
- выполнение привычки
- изменение глобальных настроек уведомлений
- изменение времени начала дня
- изменение DND
- запуск приложения
- перезагрузка устройства

### Утреннее уведомление
- одно в день
- в момент начала нового дня
- по умолчанию 06:00
- содержит список привычек на сегодня
- тап открывает Главную

### Индивидуальные уведомления
- несколько времён на привычку
- при выполнении привычки оставшиеся уведомления на день отменяются

### Snooze / автоповтор
Один глобальный интервал:
- по умолчанию 10 минут
- используется и для автоповтора
- и для кнопки «Напомнить позже»

### DND
Поддерживать:
- заглушить полностью
- заглушить на период

---

## 17. Монетизация

### Подход
Модуль `monetization` разделяется на:
- Premium / Billing
- Ads

UI не должен напрямую работать с SDK.

### Premium
Источник истины:
- RuStore Billing
- локальный кэш — для быстрого offline-старта

### Поведение
- при запуске использовать локальный кэш
- при возможности сверять статус через billing
- Premium навсегда
- цена 100 ₽
- можно показывать как «было 150 ₽, сейчас 100 ₽»

### Premium даёт
- убрать рекламу
- безлимит привычек

### Free
- максимум 5 привычек
- считаются все: активные и неактивные

### Ads
Использовать:
- Banner
- Native

Не использовать:
- Interstitial
- App Open
- Rewarded

### Экраны с рекламой
- Все привычки
- Статистика
- Настройки

### Экраны без рекламы
- Главная
- Детали привычки
- Создание / редактирование
- Paywall

### Размещение Banner
- сверху экрана

---

## 18. Дизайн

### База
- Material 3
- кастомная тема
- light theme first
- Notion-style

### Источник
Использовать `docs/design.md`.

### Принципы
- warm minimalism
- мягкие поверхности
- скруглённые карточки
- спокойные цвета
- calendar-first UI
- аккуратная типографика
- без glassmorphism
- без кислотных градиентов
- без перегруженных анимаций

---

## 19. Тестовая стратегия

### Обязательные unit tests
- repeat rules
- expected days
- streak calculation
- best streak
- completion rate
- period stats
- ideal days
- history cleanup policy
- habit-day resolver

### Widget tests
- минимально
- только для критичных сценариев при необходимости

### Integration tests
- не обязательны для MVP

Главный приоритет — доменная логика.

---

## 20. Архитектурные запреты

Нельзя:
- писать SQL в UI
- считать streak в widgets
- напрямую вызывать SDK рекламы из экранов
- напрямую вызывать SDK биллинга из экранов
- напрямую планировать уведомления из экранов
- генерировать пустые `habit_entries` заранее
- пересчитывать прошлую статистику при изменении расписания
- менять архитектуру без явного запроса
- блокировать в Premium что-то кроме рекламы и лимита привычек