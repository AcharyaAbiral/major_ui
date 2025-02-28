import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:major_ui/api_service.dart';
import 'package:major_ui/object.dart';
import 'package:vibration/vibration.dart';

class ImageViewerScreen extends StatefulWidget {
  final XFile picture;
  final AudioPlayer player;
  final FlutterTts tts;

  const ImageViewerScreen(
      {super.key,
      required this.picture,
      required this.player,
      required this.tts});

  @override
  _ImageViewerScreenState createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  bool _isLoading = true;
  List<DetectedObject> detectedObjects = [];
  DetectedObject? lastPressed;
  bool _firstTouch = true;

  @override
  void initState() {
    super.initState();
    playProcessingMusic();
    _processImage();
    widget.tts.speak("काम भइरहेको छ");
  }

  Future<void> _processImage() async {
    detectedObjects =
        await ApiServiceProcessImage.uploadImage(image: widget.picture);
    stopAudio();
    playCompletedMusic();
    setState(() {
      _isLoading = false;
    });
    // widget.tts.speak("कार्य सम्पन्न भयो");
    widget.tts.speak(
        "कार्य सम्पन्न भयो अब विवरण प्राप्त गर्न पर्दामाथि औंला तान्नुहोस्");
  }

  void stopAudio() async {
    await widget.player.stop();
  }

  bool _isPointInsideRect(Offset point, Rect rect) {
    return rect.contains(point);
  }

  void playProcessingMusic() async {
    await widget.player.setReleaseMode(ReleaseMode.loop);
    await widget.player.play(AssetSource('audio/processing.mp3'));
  }

  void playCompletedMusic() async {
    await widget.player.setReleaseMode(ReleaseMode.loop);
    await widget.player.play(AssetSource('audio/completed.mp3'));
  }

  @override
  void dispose() {
    stopAudio();
    super.dispose();
    print("popped");
  }

  void _handleTouch(PointerMoveEvent event) {
    if (_firstTouch) {
      _firstTouch = false;
      stopAudio();
    }
    final localPosition = event.localPosition;
    for (var object in detectedObjects) {
      var temp = BoundingBoxWidget(obj: object);
      if (_isPointInsideRect(localPosition,
          temp._scaleBoundingBox(context, temp.obj.boundingBox))) {
        Vibration.vibrate(pattern: [10, 50]);
        if (lastPressed == null || lastPressed != object) {
          lastPressed = object;
          widget.tts.speak("${object.label} ${object.distance} meters away");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${object.label} ${object.distance} meters away"),
              duration: const Duration(milliseconds: 300),
            ),
          );
        }
        return;
      }
    }
    lastPressed = null;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detected Objects",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.teal, // Consistent with the camera screen theme
        elevation: 5,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Listener(
              onPointerMove: _handleTouch,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                      child: Image.file(
                        File(widget.picture.path),
                        width: screenWidth - 20,
                        height: screenHeight * 0.8,
                        fit: BoxFit.cover, // Ensures proper scaling
                      ),
                    ),
                  ),
                  ...detectedObjects.map((obj) => BoundingBoxWidget(obj: obj)),
                ],
              ),
            ),
    );
  }
}

class BoundingBoxWidget extends StatelessWidget {
  final DetectedObject obj;
  BoundingBoxWidget({super.key, required this.obj});

  Rect _scaleBoundingBox(BuildContext context, Rect boundingBox) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = 720;
    double imageHeight = 1280;
    double displayWidth = screenWidth - 20;
    double displayHeight = screenHeight * 0.8;
    final left = (boundingBox.left / imageWidth) * (displayWidth) + 10;
    final width = (boundingBox.width / imageWidth) * (displayWidth);

    final top = (boundingBox.top / imageHeight) * (displayHeight) + 10;
    final height = (boundingBox.height / imageHeight) * displayHeight;
    return Rect.fromLTWH(left, top, width, height);
  }

  @override
  Widget build(BuildContext context) {
    final rect = _scaleBoundingBox(context, obj.boundingBox);
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.tealAccent, // Color of the bounding box (Teal Accent)
            width: 3,
          ),
          borderRadius:
              BorderRadius.circular(8), // Optional: rounded corners for the box
        ),
      ),
    );
  }
}
