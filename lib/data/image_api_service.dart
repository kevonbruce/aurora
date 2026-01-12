import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/random_image.dart';

class ImageApiService {
  static const _endpoint =
      'https://november7-730026606190.europe-west1.run.app/image';

  Future<RandomImage> fetchRandomImage() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode != 200) {
      throw Exception('Failed to load image');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return RandomImage.fromJson(decoded);
  }
}
