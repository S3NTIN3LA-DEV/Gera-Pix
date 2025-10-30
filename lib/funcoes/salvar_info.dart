import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalvarInfo with ChangeNotifier {
  bool _podeSalvar = false;

  bool get podeSalvar => _podeSalvar;

  SalvarInfo() {
    funcaoSalvar();
  }

  Future<void> funcaoSalvar() async {
    final prefs = await SharedPreferences.getInstance();
    _podeSalvar = prefs.getBool('podeSalvar') ?? false;
    notifyListeners();
  }

  Future<void> permitirSalvar(bool salvar) async {
    _podeSalvar = !_podeSalvar;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('podeSalvar', _podeSalvar);
    notifyListeners();
  }
}
