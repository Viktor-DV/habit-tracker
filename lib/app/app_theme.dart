import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Notion DESIGN.md tokens (docs/notion_DESIGN.md)
// Canonical values extracted 2026-06-24.
// ---------------------------------------------------------------------------

// Surfaces
const _bgColor        = Color(0xFFFAFAF9); // surface-soft
const _surfaceColor   = Color(0xFFFFFFFF); // canvas
const _cardColor      = Color(0xFFF6F5F4); // surface
const _hairline       = Color(0xFFE5E3DF); // hairline

// Ink
const _ink            = Color(0xFF1A1A1A); // ink
const _charcoal       = Color(0xFF37352F); // charcoal
const _steel          = Color(0xFF787671); // steel (secondary text)

// Brand — we keep blue accent matching product spec (Notion purple reserved
// for marketing pages, not app UI). Closest Notion blue-ish is link-blue.
// ponytail: if brand pivot to Notion purple is needed, swap to #5645D4.
const _primaryColor         = Color(0xFF2383E2); // link-blue (app primary)
const _primaryContainerColor = Color(0xFFD6E8FA);

// Notion rounded scale
const _radiusMd = Radius.circular(8);   // rounded.md  ← buttons
const _radiusLg = Radius.circular(12);  // rounded.lg  ← cards

const _borderRadiusLg = BorderRadius.all(_radiusLg);
const _borderRadiusMd = BorderRadius.all(_radiusMd);

AppTheme buildAppTheme() => const AppTheme._();

class AppTheme {
  const AppTheme._();

  static const cardRadius    = _borderRadiusLg; // 12px — Notion card
  static const chipRadius    = _borderRadiusMd; // 8px  — Notion button / NOT pill
  static const inputRadius   = _borderRadiusMd;
  static const buttonRadius  = _borderRadiusMd;

  static const textSecondary = _steel;          // steel #787671
  static const textMuted     = Color(0xFFBBB8B1); // muted
  static const dividerColor  = _hairline;
  static const cardBackground = _cardColor;
  static const surfaceColor  = _surfaceColor;
  static const bgColor       = _bgColor;
  static const primaryColor  = _primaryColor;

  // Notion pastel card tints — used for habit colour palette
  static const tintPeach    = Color(0xFFFFE8D4);
  static const tintRose     = Color(0xFFFDE0EC);
  static const tintMint     = Color(0xFFD9F3E1);
  static const tintLavender = Color(0xFFE6E0F5);
  static const tintSky      = Color(0xFFDCECFA);
  static const tintYellow   = Color(0xFFFEF7D6);
  static const tintCream    = Color(0xFFF8F5E8);
  static const tintGray     = Color(0xFFF0EEEC);
}

ThemeData appThemeData() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.light,
    surface: _surfaceColor,
    onSurface: _ink,
    onSurfaceVariant: _steel,
    outline: _hairline,
    primary: _primaryColor,
    primaryContainer: _primaryContainerColor,
  ).copyWith(
    surfaceContainerLowest: _bgColor,
    surfaceContainerLow: _bgColor,
    surfaceContainer: _cardColor,
    surfaceContainerHigh: _cardColor,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: _bgColor,

    cardTheme: const CardThemeData(
      color: _surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: _borderRadiusLg),
      margin: EdgeInsets.zero,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: _bgColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: _hairline,
      titleTextStyle: TextStyle(
        color: _ink,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: _charcoal),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _surfaceColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: _hairline,
      indicatorColor: _primaryContainerColor,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? _primaryColor : _steel,
          letterSpacing: 0,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? _primaryColor : _steel,
          size: 22,
        );
      }),
    ),

    dividerTheme: const DividerThemeData(
      color: _hairline,
      thickness: 1,
      space: 1,
    ),

    // Notion input: rounded.md (8px), hairline border, canvas bg
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceColor,
      border: OutlineInputBorder(
        borderRadius: AppTheme.inputRadius,
        borderSide: const BorderSide(color: _hairline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTheme.inputRadius,
        borderSide: const BorderSide(color: _hairline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTheme.inputRadius,
        borderSide: const BorderSide(color: _primaryColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: const TextStyle(color: _steel, fontSize: 14),
    ),

    // Notion button: rounded.md (8px), NOT pill
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
        shape: const RoundedRectangleBorder(borderRadius: _borderRadiusMd),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: _borderRadiusMd),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: _borderRadiusLg),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _cardColor,
      selectedColor: _primaryContainerColor,
      labelStyle: const TextStyle(fontSize: 13, color: _charcoal),
      shape: const RoundedRectangleBorder(borderRadius: _borderRadiusMd),
      side: const BorderSide(color: _hairline),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),

    // Notion typography — Notion Sans is Inter-based; we use system font.
    // Sizes and weights match notion_DESIGN.md typography scale.
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: _ink,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: _ink,
        letterSpacing: -0.3,
        height: 1.25,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _ink,
        letterSpacing: -0.2,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _ink,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _ink,
        height: 1.45,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _ink,
        height: 1.4,
      ),
      // body-md (16px, 1.55) — Notion body
      bodyLarge: TextStyle(
        fontSize: 15,
        color: _charcoal,
        height: 1.55,
      ),
      // body-sm (14px, 1.50)
      bodyMedium: TextStyle(
        fontSize: 14,
        color: _charcoal,
        height: 1.5,
      ),
      // caption (13px, 1.40)
      bodySmall: TextStyle(
        fontSize: 12,
        color: _steel,
        height: 1.4,
      ),
      // micro-uppercase (11px, 0.6 spacing)
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _ink,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _steel,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: _steel,
        letterSpacing: 0.6,
        height: 1.4,
      ),
    ),
  );
}
