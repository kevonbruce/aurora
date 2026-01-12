import 'package:flutter/material.dart';
import 'ui/random_image_screen.dart';

void main() {
  runApp(const RandomImageApp());
}

class RandomImageApp extends StatelessWidget {
  const RandomImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Image',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const RandomImageScreen(),
    );
  }
}