import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantdesease/identifying_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => IdentifyingScreen(image: image),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indus Lens'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(context, ImageSource.camera),
              icon: const Icon(Icons.camera),
              label: const Text('Take Photo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickImage(context, ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
