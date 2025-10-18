import 'package:flutter/material.dart';
import '../../state/gif_notifier.dart';
import '../widgets/gif_grid.dart';

class FavoritesPage extends StatelessWidget {
  final GifNotifier notifier;
  const FavoritesPage({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final favs = notifier.favorites;

    if (favs.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Nenhum GIF favoritado ainda 😢')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: GifGrid(gifs: favs),
    );
  }
}
