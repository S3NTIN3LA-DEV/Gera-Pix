import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OQueEPix extends StatelessWidget {
  const OQueEPix({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o pix',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              'O que é o pix?',
              style: GoogleFonts.baumans(
                  fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Pix é o pagamento instantâneo brasileiro. O meio de pagamento criado pelo Banco Central (BC) em que os recursos são transferidos entre contas em poucos segundos, a qualquer hora ou dia. É prático, rápido e seguro. O Pix pode ser realizado a partir de uma conta corrente, conta poupança ou conta de pagamento pré-paga.\n\nAlém de aumentar a velocidade em que pagamentos ou transferências são feitos e recebidos, o Pix tem o potencial de:\n\n- Alavancar a competitividade e a eficiência do mercado;\n- Baixar o custo, aumentar a segurança e aprimorar a experiência dos clientes;\n- Incentivar a "eletronização" do mercado de pagamentos de varejo;\n- Promover a inclusão financeira;\n- Preencher uma série de lacunas existentes na cesta de instrumentos de pagamentos disponíveis atualmente à população.',
              style: GoogleFonts.baumans(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
