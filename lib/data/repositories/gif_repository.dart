import '../models/gif_model.dart';
import '../../services/giphy_service.dart';

class GifRepository {
  final GiphyService _service;

  GifRepository(this._service);

  Future<GifModel?> getRandomGif({String? tag, String rating = 'g'}) {
    return _service.fetchRandom(tag: tag, rating: rating);
  }
}
