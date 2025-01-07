import 'package:flutter/material.dart';
import 'package:gera_pix/styles/cores.dart';

class MeusBotoes {
  static ButtonStyle botaoGerar = ElevatedButton.styleFrom(
    backgroundColor: MinhasCores.secundaria,
    fixedSize: const Size(double.infinity, 40),
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  static ButtonStyle botaoCopiar = ElevatedButton.styleFrom(
    fixedSize: const Size(110, 20),
    backgroundColor: MinhasCores.secundaria,
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
  );
}
