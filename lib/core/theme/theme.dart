import 'package:flutter/material.dart';
import 'package:spendwise/core/theme/colors.dart';

class SpendWiseTheme {
  static ColorScheme lightColorScheme = const ColorScheme(
    // Sets the overall brightness to light mode
    brightness: Brightness.light,

    // Main color used for primary elements
    primary: SpendWiseColors.primary,

    // Color used for text/icons on primary color
    onPrimary: SpendWiseColors.white,

    // Secondary color for accents
    secondary: SpendWiseColors.secondary,

    // Color for text/icons on secondary color
    onSecondary: SpendWiseColors.white,

    // Color used to indicate errors
    error: SpendWiseColors.red,

    // Color for text/icons on error color
    onError: SpendWiseColors.white,

    // Background color for surfaces
    surface: SpendWiseColors.white,

    // Color for text/icons on surface color
    onSurface: SpendWiseColors.black,
  );
}
