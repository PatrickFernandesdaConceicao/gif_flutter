import 'package:flutter/material.dart';
import '../../data/repositories/gif_repository.dart';
import '../../services/giphy_service.dart';
import '../../state/gif_notifier.dart';
import '../widgets/gif_card.dart';

const _apiKey = 'ZmQjBKeltbRmRkTtDqwSP7bI5xfEvIjp';

class RandomGifPage extends StatefulWidget {
  const RandomGifPage({super.key});

  @override
  State<RandomGifPage> createState() => _RandomGifPageState();
}

class _RandomGifPageState extends State<RandomGifPage> {
  late final GifNotifier notifier;
  final tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notifier = GifNotifier(GifRepository(GiphyService(_apiKey)));
    notifier.fetchRandom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GIF Aleatório')),
      body: AnimatedBuilder(
        animation: notifier,
        builder: (context, _) {
          if (notifier.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.error != null) {
            return Center(child: Text('Erro: ${notifier.error}'));
          }
          if (notifier.currentGif == null) {
            return const Center(child: Text('Nenhum GIF disponível.'));
          }
          return Center(
            child: GifCard(gif: notifier.currentGif!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.fetchRandom(tag: tagController.text),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
