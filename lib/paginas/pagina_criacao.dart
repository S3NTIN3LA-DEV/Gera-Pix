import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gera_pix/funcoes/estrutura_criar.dart';
import 'package:gera_pix/funcoes/salvar_info.dart';
import 'package:gera_pix/paginas/configuracao.dart';
import 'package:gera_pix/styles/botoes.dart';
import 'package:gera_pix/styles/cores.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PixFormScreen extends StatefulWidget {
  const PixFormScreen({super.key});

  @override
  State<PixFormScreen> createState() => _PixFormScreenState();
}

class _PixFormScreenState extends State<PixFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String chaveSelecionada = 'Telefone';
  final List<String> chaves = [
    'Telefone',
    'E-mail',
    'CPF/CNPJ',
    'Chave Aleatória'
  ];

  final BannerAd _bannerAd = BannerAd(
      size: const AdSize(width: 320, height: 100),
      adUnitId: 'ca-app-pub-4885597820003497/4127806090',
      listener: AdManagerBannerAdListener(),
      request: const AdManagerAdRequest());

  // Controladores para os campos de texto
  TextEditingController pixKeyController = TextEditingController();
  final _transactionAmountController = TextEditingController();
  final _merchantNameController = TextEditingController();
  final _merchantCityController = TextEditingController();

  String? _generatedQrCode; // Armazena o QR Code gerado

  void _generateQrCode() {
    _merchantNameController.text =
        removeDiacritics(_merchantNameController.text);
    _merchantCityController.text =
        removeDiacritics(_merchantCityController.text);
    if (_formKey.currentState!.validate()) {
      final pixBrCode = PixBrCode(
        payloadFormatIndicator: '01',
        pixKey: pixKeyController.text.trim(),
        merchantCategoryCode: '0000',
        transactionCurrency: '986',
        transactionAmount: _transactionAmountController.text.length >= 8
            ? _transactionAmountController.text
                .trim()
                .replaceFirst(',', '.')
                .replaceFirst('.', '')
            : _transactionAmountController.text.trim().replaceFirst(',', '.'),
        countryCode: 'BR',
        merchantName: _merchantNameController.text.trim(),
        merchantCity: _merchantCityController.text.trim(),
      );

      //final brCode = pixBrCode.generate();
      // ignore: avoid_print
      //print('BR Code Gerado:\n$brCode');

      setState(() {
        _generatedQrCode = pixBrCode.generate();
      });
    }
  }

  verificaChave() {
    if (chaveSelecionada == 'Telefone') {
      return 'Telefone* (com DDD, apenas números),';
    } else if (chaveSelecionada == 'CPF/CNPJ') {
      return 'CPF/CNPJ* (apenas números)';
    } else {
      return 'Chave pix*';
    }
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    // Remove caracteres não numéricos
    final numericValue =
        int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    // Formata o número para o formato monetário brasileiro
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
      decimalDigits: 2,
    ).format(numericValue / 100);
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      chaveSelecionada = prefs.getString('keyType') ?? 'Telefone';
      pixKeyController.text = prefs.getString('pixKey') ?? '';
      _merchantNameController.text = prefs.getString('name') ?? '';
      _merchantCityController.text = prefs.getString('city') ?? '';
    });
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('keyType', chaveSelecionada);
    await prefs.setString('pixKey', pixKeyController.text);
    await prefs.setString('name', _merchantNameController.text);
    await prefs.setString('city', _merchantCityController.text);
  }

  void compartilharQrGerado() {
    Share.share(_generatedQrCode.toString());
  }

  @override
  void initState() {
    _bannerAd.load();
    super.initState();
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    final salvarChave = context.watch<SalvarInfo>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            'assets/icon-gera-pix.png',
          ),
          title: Text(
            'GeraPix',
            style: GoogleFonts.baumans(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Vibration.vibrate(duration: 50);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Informacoes(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 320,
                    height: 100,
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      if (_generatedQrCode != null)
                        Center(
                          child: Column(
                            children: [
                              QrImageView(
                                backgroundColor: Colors.white,
                                gapless: true,
                                data: _generatedQrCode!,
                                version: QrVersions.auto,
                                size: 300.0,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    // style: MeusBotoes.botaoCopiar,
                                    onPressed: () {
                                      Vibration.vibrate(duration: 50);
                                      Clipboard.setData(ClipboardData(
                                              text:
                                                  _generatedQrCode.toString()))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor:
                                                MinhasCores.secundaria,
                                            content: Text(
                                                'Código Pix copiado para a área de transferência!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      });
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      size: 25,
                                      color: Colors.black,
                                    ), /*const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.copy,
                                          size: 15,
                                          color: MinhasCores.primaria,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Copiar',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),*/
                                  ),
                                  IconButton(
                                    //style: MeusBotoes.botaoCopiar,
                                    onPressed: () {
                                      Vibration.vibrate(duration: 50);
                                      compartilharQrGerado();
                                    },
                                    icon: Icon(
                                      Icons.share_outlined,
                                      size: 25,
                                      color: Colors.black,
                                    ), /*Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.share_outlined,
                                          size: 18,
                                        ),
                                        Text(
                                          'Compartilhar',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),*/
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: chaveSelecionada,
                        items: chaves.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: GoogleFonts.baumans(),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          Vibration.vibrate(duration: 50);
                          setState(() {
                            chaveSelecionada = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        cursorColor: MinhasCores.secundaria,
                        controller: pixKeyController,
                        decoration: InputDecoration(
                          labelText: verificaChave(),
                        ),
                        keyboardType: chaveSelecionada == 'Telefone' ||
                                chaveSelecionada == 'CPF/CNPJ'
                            ? TextInputType.number
                            : TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a chave Pix';
                          }
                          if (chaveSelecionada == 'Telefone' &&
                              !_validatePhone(value)) {
                            return 'Número de telefone inválido';
                          }
                          if (chaveSelecionada == 'CPF/CNPJ' &&
                              !_validateCpfCnpj(value)) {
                            return 'CPF ou CNPJ inválido';
                          }
                          if (chaveSelecionada == 'E-mail' &&
                              !pixKeyController.text.contains('@')) {
                            return 'Um e-mail precisa ter um "@"';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (chaveSelecionada == 'Telefone' &&
                              !value.startsWith('+55')) {
                            setState(() {
                              pixKeyController.text = '+55$value';
                              pixKeyController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: pixKeyController.text.length),
                              );
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              final formatted = _formatCurrency(newValue.text);
                              return newValue.copyWith(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                    offset: formatted.length),
                              );
                            },
                          ),
                        ],
                        cursorColor: MinhasCores.secundaria,
                        controller: _transactionAmountController,
                        decoration: InputDecoration(
                          labelText: 'Valor (opcional)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        cursorColor: MinhasCores.secundaria,
                        controller: _merchantNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do beneficiário*',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o nome do beneficiário';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        cursorColor: MinhasCores.secundaria,
                        controller: _merchantCityController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade do beneficiário*',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a cidade do beneficiário';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: MeusBotoes.botaoGerar,
                        onPressed: () async {
                          if (salvarChave.podeSalvar == true) {
                            _salvarDados();
                          }
                          if (salvarChave.podeSalvar == false) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('pixKey', '');
                            await prefs.setString('name', '');
                            await prefs.setString('city', '');
                          }
                          Vibration.vibrate(duration: 50);
                          _generateQrCode();
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          'Gerar QR Code',
                          style:
                              GoogleFonts.baumans(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  bool _validatePhone(String phone) {
    final phoneRegExp = RegExp(r'^\+55\d{10,11}$');
    return phoneRegExp.hasMatch(phone);
  }

  // Validação de CPF ou CNPJ
  bool _validateCpfCnpj(String value) {
    final cpfCnpjRegExp = RegExp(r'^\d{11}$|^\d{14}$');
    return cpfCnpjRegExp.hasMatch(value);
  }

  // Geração do QR Code Pix (simulação)
}
