import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/gif_model.dart';

class GiphyService {
  static const _baseUrl = 'https://api.giphy.com/v1';
  final String apiKey;

  GiphyService(this.apiKey);

  Future<GifModel?> fetchRandom({String? tag, String rating = 'g'}) async {
    final uri = Uri.parse(
      '$_baseUrl/gifs/random?api_key=$apiKey&tag=${tag ?? ''}&rating=$rating',
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      return GifModel.fromJson(data);
    } else {
      throw Exception('Erro ${res.statusCode} ao buscar GIF');
    }
  }
}
