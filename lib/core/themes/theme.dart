import 'package:flutter/material.dart';
import 'package:n_leaks/core/constants/app_fonts.dart';
import 'package:n_leaks/core/constants/app_colors.dart';

ThemeData get appTheme => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: backgroundColor,
    primary: primaryColor,
    secondary: informationColor,
    tertiary: lightGrayColor,
    tertiaryFixed: mutedGrayColor,
    surface: backgroundColor,
    onSurface: onBackgroundColor,
  ),
  datePickerTheme: const DatePickerThemeData(
    rangeSelectionBackgroundColor: onBackgroundColor,
    rangePickerHeaderForegroundColor: lightGrayColor,
  ),
  textTheme: TextTheme(
    displayMedium: grotesk32w600,
    titleLarge: inter24w600,
    titleMedium: inter20w500,
    titleSmall: inter18w500,
    bodyMedium: inter16w400,
    bodySmall: inter14w400,
    labelMedium: inter12w500,
  ),
);
