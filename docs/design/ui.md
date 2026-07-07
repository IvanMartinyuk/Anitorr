# UI Direction

The app supports light and dark themes.

Use the provided mockups as visual reference, but do not copy them as fixed mobile-only layouts.

Desktop should use the same visual language with a wider responsive layout.

# Visual Style

- Soft rounded cards
- Warm beige light theme
- Dark gray dark theme
- Minimal borders
- Calm colors
- Large spacing
- Card-based anime list
- Bottom navigation on mobile
- Sidebar navigation on desktop

# Layout

## Desktop

Use a two-column layout:

- Left sidebar navigation
- Main content area with anime list
- Optional right panel later for details/statistics

## Mobile

Use bottom navigation.

# Anime Card

Each anime card should contain:

- Poster image on the left
- Status label, for example "Watching"
- Anime title
- Episode info
- Progress bar
- Play/continue button
- Details arrow/action button

# Navigation Items

- My list
- Seasonal
- Browse
- Settings/Profile

# Theme Colors

Light theme:
- Background: warm cream
- Surface/card: beige
- Primary/accent: muted green or golden brown
- Text: dark brown/gray

Dark theme:
- Background: near black / dark gray
- Surface/card: dark charcoal
- Primary/accent: cyan/turquoise
- Text: white/light gray

# Rules

- Do not hardcode colors inside widgets.
- Use ThemeData and color scheme.
- Keep widgets reusable.
- Build responsive UI from the start.