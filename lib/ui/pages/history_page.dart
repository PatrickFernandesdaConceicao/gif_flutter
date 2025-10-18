// lib/ui/pages/history_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/gif_notifier.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Buscas')),
      body: Consumer<GifNotifier>(
        builder: (context, notifier, _) {
          if (notifier.searchHistory.isEmpty) {
            return const Center(
              child: Text('Nenhuma busca no histórico 📝'),
            );
          }

          return ListView.builder(
            itemCount: notifier.searchHistory.length,
            itemBuilder: (context, index) {
              final tag = notifier.searchHistory[index];
              return ListTile(
                title: Text(tag),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => notifier.removeFromHistory(tag),
                ),
                onTap: () => notifier.fetchRandom(tag: tag),
              );
            },
          );
        },
      ),
    );
  }
}