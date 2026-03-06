import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:n_leaks/core/constants/app_colors.dart';

ThemeData get appTheme => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: backgroundColor,
    primary: primaryColor,
    secondary: informationColor,
    tertiary: lightGrayColor,
    surface: backgroundColor,
  ),
  textTheme: TextTheme(
    displayMedium: GoogleFonts.spaceGrotesk(
      color: lightGrayColor,
      fontSize: 32.sp,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.inter(
      color: lightGrayColor,
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      color: lightGrayColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: GoogleFonts.inter(
      color: lightGrayColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.inter(
      color: lightGrayColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),
    labelMedium: GoogleFonts.inter(
      color: backgroundColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    ),
  ),
);
