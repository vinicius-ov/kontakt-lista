import 'dart:convert';
import 'dart:io';

class Base64Service {
  static String imagePathToBase64String(String imagePath) {
    final bytes = File(imagePath).readAsBytesSync();
    return base64Encode(bytes);
  }
}
