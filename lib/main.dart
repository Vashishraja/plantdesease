import 'package:flutter/material.dart';
import 'package:plantdesease/home_screen.dart';

void main() {
  runApp(const IndusApp());
}

class IndusApp extends StatelessWidget {
  const IndusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indus Plant Disease Detector',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}
