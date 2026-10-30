import 'package:flutter/material.dart';
import 'package:habit_tracker/features/settings/domain/theme_mode.dart';

// ---------------------------------------------------------------------------
// Notion DESIGN.md tokens (docs/notion_DESIGN.md)
// Canonical values extracted 2026-06-24. Light tokens only — dark tokens are
// derived (design doc explicitly has no dark-mode token values).
// ---------------------------------------------------------------------------

// Light surfaces
const _bgColor = Color(0xFFFAFAF9); // surface-soft
const _surfaceColor = Color(0xFFFFFFFF); // canvas
const _cardColor = Color(0xFFF6F5F4); // surface
const _hairline = Color(0xFFE5E3DF); // hairline

// Light ink
const _ink = Color(0xFF1A1A1A); // ink
const _charcoal = Color(0xFF37352F); // charcoal
const _steel = Color(0xFF787671); // steel (secondary text)

// Light brand — blue accent matching product spec (Notion purple reserved
// for marketing pages, not app UI).
const _primaryColor = Color(0xFF2383E2); // link-blue (app primary)
const _primaryContainerColor = Color(0xFFD6E8FA);

// Dark surfaces (derived, Notion-ish — not in design doc)
const _dBg = Color(0xFF191919);
const _dSurface = Color(0xFF202020);
const _dCard = Color(0xFF262626);
const _dHairline = Color(0xFF2E2E2E);

// Dark ink
const _dInk = Color(0xFFEDEDEC);
const _dCharcoal = Color(0xFFC8C6C0);
const _dSteel = Color(0xFF9A9890);

// Dark brand — brighter blue for contrast on dark
const _dPrimary = Color(0xFF4DA3FF);
const _dPrimaryContainer = Color(0xFF1E3A52);

// Notion rounded scale
const _radiusMd = Radius.circular(8); // rounded.md  ← buttons
const _radiusLg = Radius.circular(12); // rounded.lg  ← cards

const _borderRadiusLg = BorderRadius.all(_radiusLg);
const _borderRadiusMd = BorderRadius.all(_radiusMd);

// Active theme mode — drives AppTheme getters below. Set from App.build.
ThemeModeOption _currentMode = ThemeModeOption.light;
void setAppThemeMode(ThemeModeOption mode) => _currentMode = mode;

AppTheme buildAppTheme() => const AppTheme._();

class AppTheme {
  const AppTheme._();

  static const cardRadius = _borderRadiusLg; // 12px — Notion card
  static const chipRadius = _borderRadiusMd; // 8px  — Notion button / NOT pill
  static const inputRadius = _borderRadiusMd;
  static const buttonRadius = _borderRadiusMd;

  // Mode-aware colours so every screen recolours automatically.
  static Color get textSecondary =>
      _currentMode == ThemeModeOption.dark ? _dSteel : _steel;
  static Color get textMuted => _currentMode == ThemeModeOption.dark
      ? const Color(0xFF6F6D68)
      : const Color(0xFFBBB8B1);
  static Color get dividerColor =>
      _currentMode == ThemeModeOption.dark ? _dHairline : _hairline;
  static Color get cardBackground =>
      _currentMode == ThemeModeOption.dark ? _dCard : _cardColor;
  static Color get surfaceColor =>
      _currentMode == ThemeModeOption.dark ? _dSurface : _surfaceColor;
  static Color get bgColor =>
      _currentMode == ThemeModeOption.dark ? _dBg : _bgColor;
  static Color get primaryColor =>
      _currentMode == ThemeModeOption.dark ? _dPrimary : _primaryColor;

  // Notion pastel card tints — used for habit colour palette (kept identical
  // across themes; they act as habit colour chips, not app surfaces).
  static const tintPeach = Color(0xFFFFE8D4);
  static const tintRose = Color(0xFFFDE0EC);
  static const tintMint = Color(0xFFD9F3E1);
  static const tintLavender = Color(0xFFE6E0F5);
  static const tintSky = Color(0xFFDCECFA);
  static const tintYellow = Color(0xFFFEF7D6);
  static const tintCream = Color(0xFFF8F5E8);
  static const tintGray = Color(0xFFF0EEEC);
}

ThemeData appThemeData() => _buildTheme(
      brightness: Brightness.light,
      bg: _bgColor,
      surface: _surfaceColor,
      card: _cardColor,
      hairline: _hairline,
      ink: _ink,
      charcoal: _charcoal,
      steel: _steel,
      primary: _primaryColor,
      primaryContainer: _primaryContainerColor,
    );

ThemeData darkAppThemeData() => _buildTheme(
      brightness: Brightness.dark,
      bg: _dBg,
      surface: _dSurface,
      card: _dCard,
      hairline: _dHairline,
      ink: _dInk,
      charcoal: _dCharcoal,
      steel: _dSteel,
      primary: _dPrimary,
      primaryContainer: _dPrimaryContainer,
    );

ThemeData _buildTheme({
  required Brightness brightness,
  required Color bg,
  required Color surface,
  required Color card,
  required Color hairline,
  required Color ink,
  required Color charcoal,
  required Color steel,
  required Color primary,
  required Color primaryContainer,
}) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: brightness,
    surface: surface,
    onSurface: ink,
    onSurfaceVariant: steel,
    outline: hairline,
    primary: primary,
    primaryContainer: primaryContainer,
  ).copyWith(
    surfaceContainerLowest: bg,
    surfaceContainerLow: bg,
    surfaceContainer: card,
    surfaceContainerHigh: card,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: bg,

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: _borderRadiusLg),
      margin: EdgeInsets.zero,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: hairline,
      titleTextStyle: TextStyle(
        color: ink,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: charcoal),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: hairline,
      indicatorColor: primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? primary : steel,
          letterSpacing: 0,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? primary : steel,
          size: 22,
        );
      }),
    ),

    dividerTheme: DividerThemeData(
      color: hairline,
      thickness: 1,
      space: 1,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: AppTheme.inputRadius,
        borderSide: BorderSide(color: hairline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTheme.inputRadius,
        borderSide: BorderSide(color: hairline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTheme.inputRadius,
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: TextStyle(color: steel, fontSize: 14),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: _borderRadiusMd),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: _borderRadiusMd),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: _borderRadiusLg),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: card,
      selectedColor: primaryContainer,
      labelStyle: TextStyle(fontSize: 13, color: charcoal),
      shape: RoundedRectangleBorder(borderRadius: _borderRadiusMd),
      side: BorderSide(color: hairline),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: ink,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ink,
        letterSpacing: -0.3,
        height: 1.25,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ink,
        letterSpacing: -0.2,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ink,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: ink,
        height: 1.45,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: ink,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        color: charcoal,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: charcoal,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: steel,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: steel,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: steel,
        letterSpacing: 0.6,
        height: 1.4,
      ),
    ),
  );
}
