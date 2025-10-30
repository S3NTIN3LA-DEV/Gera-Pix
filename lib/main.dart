import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gera_pix/funcoes/salvar_info.dart';
import 'package:gera_pix/paginas/intro.dart';
import 'package:gera_pix/styles/temas.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fontes/OFL.txt');
    yield LicenseEntryWithLineBreaks(['baumans'], license);
  });
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => SalvarInfo(),
      ),
    ], child: (const MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: temaPadrao,
      home: const AppIntro(),
    );
  }
}
