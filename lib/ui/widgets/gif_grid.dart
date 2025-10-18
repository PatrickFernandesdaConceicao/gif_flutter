import 'package:flutter/material.dart';
import '../../../data/models/gif_model.dart';
import 'gif_card.dart';

class GifGrid extends StatelessWidget {
  final List<GifModel> gifs;
  final bool isLoading;
  final bool isError;
  final VoidCallback onRetry;

  const GifGrid({
    super.key,
    required this.gifs,
    required this.isLoading,
    required this.isError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Erro ao carregar GIFs.'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (gifs.isEmpty) {
      return const Center(child: Text('Nenhum GIF encontrado.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: gifs.length,
      itemBuilder: (context, index) {
        return GifCard(gif: gifs[index]);
      },
    );
  }
}
