import 'package:flutter/material.dart';

void navegacao(BuildContext context, Widget pagina) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => pagina));
}
