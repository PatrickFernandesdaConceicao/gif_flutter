import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'state/gif_notifier.dart';
import 'ui/pages/random_gif_page.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await Hive.openBox('settings');

  runApp(const GiphyRandomApp());
}

class GiphyRandomApp extends StatelessWidget {
  const GiphyRandomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GifNotifier(),
      child: MaterialApp(
        title: 'Buscador de GIF 2.0',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const RandomGifPage(),
      ),
    );
  }
}
