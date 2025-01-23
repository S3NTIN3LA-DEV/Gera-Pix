import 'package:flutter/material.dart';

class Cuidados extends StatelessWidget {
  const Cuidados({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuidados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: const [
            Text(
              'Isenção de responsabilidade',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Os QR Codes gerados por este aplicativo não foram testados em todos os bancos. Por isso, antes de confirmar qualquer transação, verifique cuidadosamente se todos os dados estão corretos.\n\nNão nos responsabilizamos por eventuais erros de transferência cometidos pelos usuários. Caso ocorra uma transferência incorreta ou por engano, entre em contato com o banco responsável para receber as devidas orientações.',
            ),
            SizedBox(
              height: 20,
            ),
            SelectableText(
                'Os QRCodes foram programados a partir da documentação do BACEN BRCode 2.0.1 https://www.bcb.gov.br/content/estabilidadefinanceira/spb_docs/ManualBRCode.pdf'),
            SizedBox(
              height: 20,
            ),
            Text(
              'O aplicativo compartilha meus dados bancários?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Este aplicativo não possui conexão com servidores externos e pode ser utilizado sem acesso à internet. Assim, todos os dados inseridos no aplicativo permanecerão restritos exclusivamente ao seu dispositivo.',
            ),
          ],
        ),
      ),
    );
  }
}
