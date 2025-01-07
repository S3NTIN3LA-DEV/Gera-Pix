import 'package:flutter/material.dart';
import 'package:gera_pix/styles/cores.dart';

final ThemeData temaPadrao = ThemeData(
  scaffoldBackgroundColor: MinhasCores.primaria,
  appBarTheme: const AppBarTheme(
    backgroundColor: MinhasCores.primaria,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: MinhasCores.secundaria),
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
      trackColor: WidgetStatePropertyAll(MinhasCores.secundaria)),
);
