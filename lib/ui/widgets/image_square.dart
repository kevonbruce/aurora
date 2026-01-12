import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'loading_overlay.dart';

class ImageSquare extends StatefulWidget {
  final String imageUrl;
  final bool isLoading;
  final VoidCallback? onImageError;

  const ImageSquare({
    super.key,
    required this.imageUrl,
    required this.isLoading,
    this.onImageError,
  });

  @override
  State<ImageSquare> createState() => _ImageSquareState();
}

class _ImageSquareState extends State<ImageSquare> {
  bool _reportedError = false;

  @override
  void didUpdateWidget(covariant ImageSquare oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset the one-time error reporting when a NEW url is shown
    if (oldWidget.imageUrl != widget.imageUrl) {
      _reportedError = false;
    }
  }

  void _reportErrorOnce() {
    if (_reportedError) return;
    _reportedError = true;

    // Call after frame to avoid setState during build warnings
    if (widget.onImageError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onImageError?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 250),
            placeholder: (_, __) => const LoadingOverlay(),
            errorWidget: (_, __, ___) {
              _reportErrorOnce();
              return const Center(
                child: Icon(Icons.broken_image, size: 40),
              );
            },
          ),
          if (widget.isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const LoadingOverlay(),
            ),
        ],
      ),
    );
  }
}
