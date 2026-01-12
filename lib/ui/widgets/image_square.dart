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

    if (oldWidget.imageUrl != widget.imageUrl) {
      _reportedError = false;
    }
  }

  void _reportErrorOnce() {
    if (_reportedError) return;
    _reportedError = true;

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
          fadeInDuration: const Duration(milliseconds: 500),
          fadeOutDuration: const Duration(milliseconds: 500),
          fadeInCurve: Curves.easeInOut,
          fadeOutCurve: Curves.easeInOut,
            placeholder: (_, __) => const LoadingOverlay(),
            errorWidget: (_, __, ___) {
    _reportErrorOnce();
    return const Center(child: Icon(Icons.broken_image, size: 40));
    },
    ),
    ],
    ),
    );
  }
}