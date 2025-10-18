import 'package:hive/hive.dart';
import '../models/gif_model.dart';

class GifModelAdapter extends TypeAdapter<GifModel> {
  @override
  final int typeId = 1;

  @override
  GifModel read(BinaryReader reader) {
    return GifModel(
      id: reader.readString(),
      title: reader.readString(),
      url: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, GifModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.url);
  }
}
