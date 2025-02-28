// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:major_ui/camera_preview_widget.dart';
// import 'package:major_ui/image_viewer_screen.dart';

// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   CameraScreen({super.key, required this.cameras});
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   void _initializeCamera() async {
//     _controller = CameraController(
//       widget.cameras[0],
//       ResolutionPreset.high,
//     );

//     await _controller.initialize();
//     if (mounted) setState(() {});
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _captureImage() async {
//     XFile picture = await _controller.takePicture();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ImageViewerScreen(picture: picture),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text("Smart Vision")),
//       body: Stack(
//         children: [
//           CameraPreviewWidget(controller: _controller),
//           Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: FloatingActionButton(
//                 onPressed: _captureImage,
//                 child: Icon(Icons.camera_alt),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:major_ui/camera_preview_widget.dart';
import 'package:major_ui/face_registration_screen.dart';
import 'package:major_ui/image_viewer_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final AudioPlayer player = AudioPlayer();
  final FlutterTts tts;
  int mode;
  CameraScreen(
      {super.key,
      required this.cameras,
      required this.mode,
      required this.tts});
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    widget.tts.speak("वातावरण को समझ प्राप्त गर्न फोटो क्लिक गर्नुहोस्");
  }

  void _initializeCamera() async {
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );

    await _controller.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _captureImage() async {
    XFile picture = await _controller.takePicture();

    if (widget.mode == 0) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewerScreen(
              picture: picture, player: widget.player, tts: widget.tts),
        ),
      );
      widget.tts.speak("वातावरण को समझ प्राप्त गर्न फोटो क्लिक गर्नुहोस्");
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FaceRegistrationScreen(
              picture: picture, player: widget.player, tts: widget.tts),
        ),
      );
      widget.tts
          .speak("कार्य सम्पन्न भयो अब अनुहार दर्ता गर्न फोटो क्लिक गर्नुहोस्");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Camera preview with the custom widget
        CameraPreviewWidget(controller: _controller),

        // Floating Action Button for capturing an image
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              onPressed: _captureImage,
              backgroundColor:
                  Colors.tealAccent, // Gradient or solid color for the FAB
              elevation: 6,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
