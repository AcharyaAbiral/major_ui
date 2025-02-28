import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:major_ui/api_service.dart';

class FaceRegistrationScreen extends StatefulWidget {
  final XFile picture;
  final AudioPlayer player;
  final FlutterTts tts;
  FaceRegistrationScreen(
      {super.key,
      required this.picture,
      required this.player,
      required this.tts});
  @override
  State<FaceRegistrationScreen> createState() => _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  bool _isloading = true;
  TextEditingController text_controller = TextEditingController();
  String? name;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.tts.speak("नाम दर्ता गर्न सक्षम व्यक्तिलाई अनुरोध गर्नुहोस्");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  void playProcessingMusic() async {
    await widget.player.setReleaseMode(ReleaseMode.loop);
    await widget.player.play(AssetSource('audio/processing.mp3'));
  }

  void playCompletedMusic() async {
    await widget.player.setReleaseMode(ReleaseMode.loop);
    await widget.player.play(AssetSource('audio/completed.mp3'));
  }

  void stopAudio() async {
    await widget.player.stop();
  }

  @override
  void dispose() {
    if (mounted) {
      stopAudio();
    }
    super.dispose();
  }

  Future<void> _processImage({required name}) async {
    playProcessingMusic();
    await ApiServiceFaceRegistration.uploadImage(
        image: widget.picture, name: name);
    // stopAudio();
    // playCompletedMusic();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("face registration"),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // Rounded corners
              child: Image.file(
                File(widget.picture.path),
                width: screenWidth - 20,
                height: screenHeight * 0.8,
                fit: BoxFit.cover, // Ensures proper scaling
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.07,
              child: TextFormField(
                  controller: text_controller,
                  focusNode: focusNode,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Name of the person",
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.teal,
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.pink),
                    ),
                  ),
                  onFieldSubmitted: (value) async {
                    // print(value);
                    await _processImage(name: value);
                    Navigator.of(context).pop();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
