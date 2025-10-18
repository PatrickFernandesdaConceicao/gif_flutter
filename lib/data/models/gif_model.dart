class GifModel {
  final String id;
  final String title;
  final String url;

  GifModel({
    required this.id,
    required this.title,
    required this.url,
  });

  factory GifModel.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] ?? {}) as Map<String, dynamic>;
    final downsized = images['downsized_medium'] ?? images['original'];
    return GifModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Sem título',
      url: downsized?['url'] ?? '',
    );
  }
}
