import 'package:flutter/material.dart';
import '../../../data/models/gif_model.dart';

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
        ],
      ),
    );
  }
}
