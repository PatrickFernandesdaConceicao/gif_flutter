// lib/main.dart
import 'package:aula04/services/mysql_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/prefs/app_preferences.dart';
import 'data/repositories/gif_repository.dart';
import 'data/repositories/mysql_repository.dart';
import 'services/giphy_service.dart';
import 'state/gif_notifier.dart';
import 'ui/pages/home_page.dart';
import 'ui/theme/app_theme.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar MySQL
  final mysqlService = MySQLService();
  try {
    await mysqlService.connect();
    print('✅ MySQL conectado com sucesso!');
  } catch (e) {
    print('❌ Erro ao conectar ao MySQL: $e');
    print('⚠️  Verifique as configurações em lib/core/config/mysql_config.dart');
  }

  runApp(GiphyRandomApp(mysqlService: mysqlService));
}

class GiphyRandomApp extends StatelessWidget {
  final MySQLService mysqlService;

  const GiphyRandomApp({
    super.key,
    required this.mysqlService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: mysqlService),
        Provider(create: (_) => MySQLRepository(mysqlService)),
        Provider(create: (_) => GiphyService(AppConfig.giphyApiKey)),
        Provider(create: (context) => GifRepository(context.read<GiphyService>())),
        ChangeNotifierProvider(
          create: (context) => GifNotifier(
            remoteRepo: context.read<GifRepository>(),
            mysqlRepo: context.read<MySQLRepository>(),
          ),
        ),
        Provider(create: (context) => AppPreferences(context.read<MySQLRepository>())),
      ],
      child: MaterialApp(
        title: 'Buscador de GIF 2.0',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}