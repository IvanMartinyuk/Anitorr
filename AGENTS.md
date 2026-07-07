# Overview

Anime Tracker built with Flutter.

Current goal is a pc-first application.

Backend/media server features will come later.

# Platform priority

Start with desktop layouts first: Linux and Windows.

Mobile layouts should be adapted later from the same design system.

Do not assume mobile-only UI patterns.

# State Management

Use Riverpod.

Avoid setState except for simple local widget state.

# Architecture

Keep UI, business logic, and data layers separate.

Business logic belongs in providers/services.

Widgets should remain small and reusable.

# Navigation

Use GoRouter.

# Styling

Reuse theme values.

Avoid hardcoded colors.

Use Material 3.

# Design

Use the provided light and dark UI mockups as the visual direction.

Support both light and dark themes from the start.

Prefer responsive layouts instead of separate duplicated desktop/mobile screens.

# Before implementing

Search for existing components.

Reuse widgets whenever possible.

Keep changes minimal.

# Before finishing

Run

flutter analyze

flutter test