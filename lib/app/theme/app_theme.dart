import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF5F7848),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFD2BEA2),
      onPrimaryContainer: Color(0xFF262019),
      secondary: Color(0xFF936B00),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFF7EEDC),
      onSurface: Color(0xFF262019),
      surfaceContainer: Color(0xFFE4D5BE),
    );

    return _theme(colorScheme);
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF25E0D3),
      onPrimary: Color(0xFF003735),
      primaryContainer: Color(0xFF303039),
      onPrimaryContainer: Color(0xFFE5E1E8),
      secondary: Color(0xFFB9B4C4),
      onSecondary: Color(0xFF302D38),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: Color(0xFF1B1B20),
      onSurface: Color(0xFFE5E1E8),
      surfaceContainer: Color(0xFF3E3E46),
    );

    return _theme(colorScheme);
  }

  static ThemeData _theme(ColorScheme colorScheme) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
    );

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        selectedLabelTextStyle: TextStyle(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        unselectedLabelTextStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
