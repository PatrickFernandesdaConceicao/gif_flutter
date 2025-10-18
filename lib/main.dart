import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/db/hive_manager.dart';
import 'core/prefs/app_preferences.dart';
import 'data/repositories/gif_repository.dart';
import 'data/repositories/local_repository.dart';
import 'services/giphy_service.dart';
import 'state/gif_notifier.dart';
import 'ui/pages/home_page.dart';
import 'ui/theme/app_theme.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await HiveManager.init();

  runApp(const GiphyRandomApp());
}

class GiphyRandomApp extends StatelessWidget {
  const GiphyRandomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => LocalRepository()),
        Provider(create: (context) => GiphyService(AppConfig.giphyApiKey)),
        Provider(create: (context) => GifRepository(context.read<GiphyService>())),
        ChangeNotifierProvider(
          create: (context) => GifNotifier(
            remoteRepo: context.read<GifRepository>(),
            localRepo: context.read<LocalRepository>(),
          ),
        ),
        Provider(create: (context) => AppPreferences(context.read<LocalRepository>())),
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