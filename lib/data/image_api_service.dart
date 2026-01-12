import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/random_image.dart';

class ImageApiService {
  static const _endpoint =
      'https://november7-730026606190.europe-west1.run.app/image';

  Future<RandomImage> fetchRandomImage() async {
    try {
      final response = await http
          .get(Uri.parse(_endpoint))
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        throw Exception('Failed to load image');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      log(decoded.toString(), name: 'ImageApiService');
      return RandomImage.fromJson(decoded);
    } catch (e) {
      if (e is http.ClientException || e is TimeoutException) {
        throw Exception('Network error: $e');
      }
      throw Exception('Error fetching image: $e');
    }
  }
}