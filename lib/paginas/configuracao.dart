import 'package:flutter/material.dart';
import 'package:gera_pix/funcoes/navegacao.dart';
import 'package:gera_pix/funcoes/salvar_info.dart';
import 'package:gera_pix/paginas/cuidados.dart';
import 'package:gera_pix/paginas/sobre_pix.dart';
import 'package:gera_pix/styles/cores.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vibration/vibration.dart';

class Informacoes extends StatefulWidget {
  const Informacoes({super.key});

  @override
  State<Informacoes> createState() => _InformacoesState();
}

class _InformacoesState extends State<Informacoes> {
  String linkDoApp =
      'https://play.google.com/store/apps/details?id=com.gera.pix';

  void compartilharApp() {
    Share.share(linkDoApp);
  }

  @override
  Widget build(BuildContext context) {
    final podeSalvar = context.watch<SalvarInfo>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ListTile(
              title: Text(
                'Configurações do app',
                style: TextStyle(
                  color: MinhasCores.secundaria,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                  podeSalvar.podeSalvar ? Icons.save : Icons.save_as_outlined),
              title: const Text('Salvar informações?'),
              trailing: Switch(
                inactiveTrackColor: Colors.grey,
                value: podeSalvar.podeSalvar,
                onChanged: (value) {
                  Vibration.vibrate(duration: 50);
                  podeSalvar.permitirSalvar(value);
                },
              ),
            ),
            const ListTile(
              title: Text(
                'Sobre',
                style: TextStyle(
                  color: MinhasCores.secundaria,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('O que é o pix?'),
              onTap: () {
                Vibration.vibrate(duration: 50);
                navegacao(context, const OQueEPix());
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_amber_outlined),
              title: const Text('Cuidados a tomar'),
              onTap: () {
                Vibration.vibrate(duration: 50);
                navegacao(context, const Cuidados());
              },
            ),
            const ListTile(
              title: Text(
                'Ajude-nos',
                style: TextStyle(
                  color: MinhasCores.secundaria,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Avalie-nos'),
              onTap: () async {
                Vibration.vibrate(duration: 50);
                if (await canLaunchUrlString(linkDoApp)) {
                  await launchUrlString(linkDoApp);
                } else {
                  throw 'Não foi possível realizar a ação!';
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Compartilhe o app'),
              onTap: () {
                Vibration.vibrate(duration: 50);
                compartilharApp();
              },
            ),
            const ListTile(
              leading: Icon(Icons.system_update_sharp),
              title: Text('Versão'),
              subtitle: Text('1.1.4'),
            )
          ],
        ),
      ),
    );
  }
}
