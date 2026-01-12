import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ColorSchemeHelper {
  static Future<ColorScheme> fromImageUrl(
      String imageUrl,
      Brightness brightness,
      ) {
    final provider = CachedNetworkImageProvider(imageUrl);

    return ColorScheme.fromImageProvider(
      provider: provider,
      brightness: brightness,
    );
  }
}
