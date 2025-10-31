// lib/ui/widgets/gif_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/gif_model.dart';
import '../../state/gif_notifier.dart';

class GifCard extends StatelessWidget {
  final GifModel gif;

  const GifCard({super.key, required this.gif});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            gif.url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stack) =>
                const Center(child: Icon(Icons.error_outline)),
          ),
          // Título na base
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              color: Colors.black45,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                gif.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          // Botão de favorito no topo direito
          Positioned(
            top: 8,
            right: 8,
            child: FutureBuilder<bool>(
              future: context.read<GifNotifier>().isFavorite(gif),
              builder: (context, snapshot) {
                final isFav = snapshot.data ?? false;
                return FloatingActionButton(
                  mini: true,
                  backgroundColor: isFav ? Colors.red : Colors.white,
                  onPressed: () async {
                    await context.read<GifNotifier>().toggleFavorite(gif);
                  },
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.white : Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}