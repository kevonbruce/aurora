import 'dart:async';
import 'package:flutter/material.dart';
import '../data/image_api_service.dart';
import '../models/random_image.dart';
import '../utils/color_scheme_helper.dart';
import 'widgets/image_square.dart';

class RandomImageScreen extends StatefulWidget {
  const RandomImageScreen({super.key});

  @override
  State<RandomImageScreen> createState() => _RandomImageScreenState();
}

class _RandomImageScreenState extends State<RandomImageScreen> {
  final _api = ImageApiService();

  RandomImage? _image;
  bool _loading = true;
  String? _error;

  bool _imageLoadFailed = false;

  Color _backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    setState(() {
      _loading = true;
      _error = null;
      _imageLoadFailed = false;
    });

    try {
      final image = await _api.fetchRandomImage();

      if (!mounted) return;

      setState(() {
        _image = image;
        _loading = false;
      });

      final brightness = Theme.of(context).brightness;

      ColorScheme scheme;
      try {
        scheme = await ColorSchemeHelper.fromImageUrl(
          image.url,
          brightness,
        ).timeout(const Duration(seconds: 3));
      } catch (_) {
        scheme = ColorScheme.fromSeed(
          seedColor: brightness == Brightness.dark ? Colors.black : Colors.grey,
          brightness: brightness,
        );
      }

      if (!mounted) return;

      final adaptiveBg = brightness == Brightness.dark
          ? scheme.primaryContainer
          : scheme.secondaryContainer;

      setState(() {
        _backgroundColor = adaptiveBg;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'Couldn’t load image. Please try again.';
        _loading = false;
      });
    }
  }

  Widget _errorSquare(BuildContext context, String message) {
    final brightness = Theme.of(context).brightness;
    final fg = brightness == Brightness.dark ? Colors.white : Colors.black;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black.withValues(
            alpha: brightness == Brightness.dark ? 0.22 : 0.10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 40, color: fg),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: fg),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _loading ? null : _loadImage,
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final inlineErrorColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: _backgroundColor,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_image != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ImageSquare(
                          imageUrl: _image!.url,
                          isLoading: _loading,

                          onImageError: () {
                            if (!mounted) return;

                            setState(() {
                              _imageLoadFailed = true;
                            });
                          },
                        ),
                      ),

                      if (_imageLoadFailed) ...[
                        const SizedBox(height: 12),
                        Text(
                          'That image couldn’t be loaded. Try Another.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: inlineErrorColor),
                        ),
                      ],
                    ] else if (_error != null)
                      _errorSquare(context, _error!)
                    else
                      const SizedBox(
                        width: 220,
                        height: 220,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : _loadImage,
                        child: Text(_loading ? 'Loading...' : 'Another'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}