import 'dart:convert';
import 'dart:typed_data';

class ImageService {
  static Uint8List imageFromBase64String(String base64String) {
    return const Base64Decoder().convert(base64String);
  }
}
