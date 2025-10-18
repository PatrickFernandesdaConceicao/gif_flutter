import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/gif_notifier.dart';
import '../widgets/gif_grid.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Consumer<GifNotifier>(
        builder: (context, notifier, _) {
          final favs = notifier.favorites;

          if (favs.isEmpty) {
            return const Center(child: Text('Nenhum GIF favoritado ainda 😢'));
          }

          return GifGrid(
            gifs: favs,
            isLoading: false,
            isError: false,
            onRetry: () => notifier.loadFavorites(),
          );
        },
      ),
    );
  }
}