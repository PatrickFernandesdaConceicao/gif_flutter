import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/gif_notifier.dart';
import '../widgets/gif_card.dart';

class RandomGifPage extends StatefulWidget {
  const RandomGifPage({super.key});

  @override
  State<RandomGifPage> createState() => _RandomGifPageState();
}

class _RandomGifPageState extends State<RandomGifPage> {
  final tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GifNotifier>().fetchRandom();
      context.read<GifNotifier>().loadFavorites();
    });
  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GIF Aleatório')),
      body: Consumer<GifNotifier>(
        builder: (context, notifier, _) {
          if (notifier.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.error != null) {
            return Center(child: Text('Erro: ${notifier.error}'));
          }
          if (notifier.currentGif == null) {
            return const Center(child: Text('Nenhum GIF disponível.'));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: GifCard(gif: notifier.currentGif!)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: tagController,
                  onChanged: (value) {
                    // Debounce automático ao digitar
                    notifier.searchWithDebounce(tag: value.isEmpty ? null : value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Digite uma tag (busca automática)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<GifNotifier>().fetchRandom(
          tag: tagController.text.isEmpty ? null : tagController.text,
        ),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}