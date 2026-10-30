# Трекер привычек

Офлайн-трекер привычек для Android на **Flutter**. Без регистрации, облака и
интернета — все данные только на телефоне.

[![RuStore](https://img.shields.io/badge/RuStore-скачать-0077FF)](https://www.rustore.ru/catalog/app/ru.habitify.tracker)
![Flutter](https://img.shields.io/badge/Flutter-3.38-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/Android-8.0+-3DDC84?logo=android)
![CI](https://github.com/Viktor-DV/habit-tracker/actions/workflows/rustore_deploy.yml/badge.svg)

## Возможности

- **Типы привычек:** да/нет, количество, время (с секундомером), негативные
  привычки (успех / срыв / пропуск).
- **Гибкое расписание:** каждый день, по дням недели, раз в N дней, N раз за
  N дней; настраиваемое время начала дня.
- **Главная:** месячный календарь со статусом каждого дня и быстрая отметка.
- **19 шаблонов** в категориях «Здоровье», «Разум», «Продуктивность».
- **Статистика:** текущая и лучшая серия, процент выполнения, графики за
  неделю / месяц / 3 месяца / год.
- **Уведомления:** утренняя сводка, напоминания с действиями «Выполнено» /
  «Напомнить позже», режим «Не беспокоить»; восстанавливаются после перезагрузки.
- Поиск, фильтры, сортировка перетаскиванием, светлая / тёмная тема.

## Технические детали

- Feature-first структура: `core/` (БД, уведомления, расчёт расписаний),
  `features/` (habits, statistics, notifications, settings, monetization).
- `drift` + SQLite с кодогенерацией, реактивные запросы в Riverpod.
- Расчёт серий и расписаний покрыт unit-тестами (`test/core`, `test/features`).
- **CI/CD:** публикация в RuStore через GitHub Actions
  ([rustore_deploy.yml](.github/workflows/rustore_deploy.yml)), ключи — в секретах репозитория.
- Без Google-сервисов: реклама через Yandex Mobile Ads.

## Стек

Flutter 3.38 / Dart 3.10 · Material 3 · Riverpod · go_router · drift (SQLite) ·
flutter_local_notifications · timezone · shared_preferences · yandex_mobileads

## Сборка

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # код drift
flutter test
flutter build appbundle --release
```

Для подписи релиза нужен `android/key.properties`
(пример — `android/key.properties.example`, сам файл в репозиторий не входит).

## Структура

```
lib/
├── app/        # MaterialApp, роутер, тема
├── core/       # база данных, уведомления, расчёт расписаний
├── features/   # habits, statistics, notifications, settings, monetization
├── l10n/       # локализация
└── shared/     # общие виджеты
```
