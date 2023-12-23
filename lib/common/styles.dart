import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFFFE033);
const Color secondaryColor = Color(0xFF000000);

const double cIconSize = 30;
const double cPaddingHorizontalSize = 13;

ColorScheme cColorScheme(BuildContext context) =>
    Theme.of(context).colorScheme.copyWith(
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: secondaryColor,
          onSecondary: Colors.white,
        );

const AppBarTheme cAppBarTheme = AppBarTheme(
  elevation: 0,
  color: primaryColor,
);

ElevatedButtonThemeData cElevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(50),
    backgroundColor: secondaryColor,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(),
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
  ),
);
TextButtonThemeData cTextButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
  ),
);

final TextTheme cTextTheme = TextTheme(
  displayLarge: GoogleFonts.teko(
      fontSize: 94, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.teko(
      fontSize: 59, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  displaySmall: GoogleFonts.teko(fontSize: 47, fontWeight: FontWeight.w400),
  headlineMedium: GoogleFonts.teko(
      fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: GoogleFonts.teko(fontSize: 24, fontWeight: FontWeight.w400),
  titleLarge: GoogleFonts.teko(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: GoogleFonts.teko(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  titleSmall: GoogleFonts.teko(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  bodySmall: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  labelLarge: GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.poppins(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
