import 'package:flutter/material.dart';
import 'package:gera_pix/styles/cores.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData temaPadrao = ThemeData(
  scaffoldBackgroundColor: MinhasCores.primaria,
  appBarTheme: const AppBarTheme(
    backgroundColor: MinhasCores.primaria,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.baumans(color: MinhasCores.secundaria),
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: MinhasCores.secundaria,
        width: 2,
      ),
    ),
  ),
  switchTheme: const SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(Colors.white),
    trackColor: WidgetStatePropertyAll(MinhasCores.secundaria),
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.baumans(),
    bodyMedium: GoogleFonts.baumans(),
    bodySmall: GoogleFonts.baumans(),
    titleLarge: GoogleFonts.baumans(),
  ),
);
