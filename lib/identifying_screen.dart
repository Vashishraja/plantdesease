import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantdesease/identifying_store.dart';

class IdentifyingScreen extends StatefulWidget {
  final XFile image;

  const IdentifyingScreen({super.key, required this.image});

  @override
  State<IdentifyingScreen> createState() => _IdentifyingScreenState();
}

class _IdentifyingScreenState extends State<IdentifyingScreen>
    with SingleTickerProviderStateMixin {
  final IdentifyingStore _identifyingStore = IdentifyingStore();
  late AnimationController _animationController;
  late Animation<Offset> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scanLineAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 1.0),
    ).animate(_animationController);

    _animationController.repeat(reverse: true);

    _identifyImage();
  }

  Future<void> _identifyImage() async {
    await _identifyingStore.identifyImage(widget.image);
    _animationController.stop();

    if (_identifyingStore.response != null) {
      _showTextBottomSheet();
    }
  }

  Future<void> _showTextBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.7,
          maxChildSize: 1,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Markdown(
                data: _identifyingStore.response?.text ?? 'No response available.',
                controller: scrollController,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identifying Plant'),
      ),
      body: Stack(
        children: [
          Image.file(
            File(widget.image.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Observer(builder: (_) {
            if (_identifyingStore.response != null) {
              return const SizedBox.shrink();
            }

            return AnimatedBuilder(
              animation: _scanLineAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ScanLinePainter(
                    offset: _scanLineAnimation.value,
                    lineWidth: 4,
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class ScanLinePainter extends CustomPainter {
  final Offset offset;
  final double lineWidth;

  const ScanLinePainter({required this.offset, required this.lineWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = lineWidth;

    canvas.drawLine(
      Offset(0, size.height * (offset.dy + 0.5)),
      Offset(size.width, size.height * (offset.dy + 0.5)),
      paint,
    );
  }

  @override
  bool shouldRepaint(ScanLinePainter oldDelegate) =>
      oldDelegate.offset != offset;
}
