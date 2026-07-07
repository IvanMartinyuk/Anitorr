# Architecture

Anime Tracker is a Flutter desktop-first application.

The app should be built as a clean, modular Flutter app that can later support mobile and media-server features.

## Main principles

- Keep UI, state, and data access separate.
- Prefer small reusable widgets.
- Avoid putting business logic inside widgets.
- Use Riverpod for state management.
- Use GoRouter for navigation.
- Use mock/local data first.
- Add real APIs later behind repository/service abstractions.

## Suggested folder structure

lib/
  main.dart
  app/
    app.dart
    router.dart
    theme/
      app_theme.dart
      app_colors.dart
  features/
    anime_list/
      data/
      domain/
      presentation/
    anime_details/
      data/
      domain/
      presentation/
    seasonal/
      data/
      domain/
      presentation/
    browse/
      data/
      domain/
      presentation/
    settings/
      presentation/
  shared/
    widgets/
    models/
    services/
    utils/

## Layers

### Presentation

Contains screens, pages, and widgets.

Widgets should only handle UI and user interaction.

### Domain

Contains app models and business rules.

Example:

- Anime
- EpisodeProgress
- WatchStatus

### Data

Contains API clients, repositories, local storage, and DTOs.

External APIs like Jikan should be hidden behind repositories.

## State management

Use Riverpod providers.

Prefer:

- Provider
- FutureProvider
- StateNotifier / Notifier

Avoid global mutable state.

## Navigation

Use GoRouter.

Initial routes:

- /my-list
- /seasonal
- /browse
- /settings

## Data strategy

Phase 1 should use mock data or local storage.

Later, add:

- Jikan API
- local database
- media library scanner
- optional download automation

## Desktop-first layout

Desktop should use:

- sidebar navigation
- main content area
- responsive card/grid/list layout

Mobile later should use:

- bottom navigation
- single-column layout

Do not duplicate business logic between desktop and mobile UI.

## Theming

Use ThemeData and ColorScheme.

Support light and dark themes from the beginning.

Do not hardcode colors inside widgets.

## Testing

Business logic should be easy to test without rendering UI.

Run before finishing:

flutter analyze
flutter test