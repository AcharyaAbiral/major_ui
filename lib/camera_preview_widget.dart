import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  const CameraPreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade700,
            Colors.tealAccent
          ], // Gradient for the background
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(20), // Rounded corners for the background
        border: Border.all(
          color: Colors.tealAccent, // Solid teal border around the container
          width: 3, // Border width
        ),
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 20), // Margin around the preview
      clipBehavior: Clip.antiAlias, // Ensures rounded corners are applied
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: controller.value.isInitialized
            ? 1
            : 0.5, // Fade effect for camera preview
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              18), // Further rounded corners for the preview
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
