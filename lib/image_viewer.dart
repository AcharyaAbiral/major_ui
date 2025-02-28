// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'dart:io';

// import 'package:vibration/vibration.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter_vision/flutter_vision.dart';

// class DetectedObject {
//   final String label;
//   final Rect boundingBox;
//   DetectedObject({required this.label, required this.boundingBox});
// }

// class ImageViewer extends StatefulWidget {
//   final XFile picture;
//   const ImageViewer({super.key, required this.picture});
//   @override
//   State<ImageViewer> createState() => _ImageViewerState();
// }

// class _ImageViewerState extends State<ImageViewer> {
//   late FlutterVision vision;
//   File? _image;

//   List<DetectedObject> objects = [];
//   bool _isLoading = true;
//   DetectedObject? lastPressed;
//   FlutterTts flutterTts = FlutterTts();

//   @override
//   void initState() {
//     super.initState();

//     vision = FlutterVision();
//     _loadYoloModelAndInference();
//     // _initObjectDetector();
//   }

//   _loadYoloModelAndInference() async {
//     try {
//       await vision.loadYoloModel(
//           modelPath: 'assets/model.tflite',
//           labels: 'assets/labels.txt',
//           modelVersion: 'yolov5',
//           numThreads: 2,
//           useGpu: true);
//       print("model loaded successfully");
//     } catch (e) {
//       print("error loading model: $e");
//     }
//     var bytes;
//     final _image = File(widget.picture.path);
//     Uint8List originalBytes = await _image.readAsBytes();
//     img.Image? decodedImage = img.decodeImage(originalBytes);
//     if (decodedImage != null) {
//       img.Image resizedImage =
//           img.copyResize(decodedImage, width: 448, height: 448);
//       bytes = img.encodeJpg(resizedImage);
//     }

//     try {
//       print("starting detection");
//       var result = await vision.yoloOnImage(
//           bytesList: bytes,
//           imageHeight: 448,
//           imageWidth: 448,
//           iouThreshold: 0.2,
//           confThreshold: 0.2,
//           classThreshold: 0.2);
//       print("detection completed");
//       if (result != null) {
//         if (result.isEmpty) {
//           print("no object detected");
//         }
//         for (var detectedObject in result) {
//           print("detected");
//           print(detectedObject['tag']);
//           var tl_x = detectedObject['box'][0];
//           var tl_y = detectedObject['box'][1];
//           var br_x = detectedObject['box'][2];
//           var br_y = detectedObject['box'][3];
//           var box_rect = Rect.fromLTRB(tl_x, tl_y, br_x, br_y);
//           DetectedObject temp = DetectedObject(
//               label: detectedObject['tag'], boundingBox: box_rect);
//           objects.add(temp);
//         }
//       }
//     } catch (e) {
//       print("error occured during detection: $e");
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   // _initObjectDetector() async {
//   // final inputImage = InputImage.fromFilePath(widget.picture.path);

//   // final mode = DetectionMode.single;
//   // final options = ObjectDetectorOptions(
//   //     mode: mode, classifyObjects: true, multipleObjects: true);
//   // final objectDetector = ObjectDetector(options: options);
//   // objects = await objectDetector.processImage(inputImage);

//   // objectDetector.close();
//   // setState(() {
//   //   _isLoading = false;
//   // });
//   // }

//   bool _isPointInsideRect(Offset point, Rect rect) {
//     // print("pressed");
//     return rect.contains(point);
//   }

//   void _onPointerMove(PointerMoveEvent event) async {
//     final localPosition = event.localPosition;
//     for (var object in objects) {
//       final rect = _scaleBoundingBox(object.boundingBox);
//       if (_isPointInsideRect(localPosition, rect)) {
//         Vibration.vibrate(pattern: [10, 50]);
//         if (lastPressed == null || lastPressed != object) {
//           lastPressed = object;
//           print("pressed");
//           if (object.label.isNotEmpty) {
//             // print("i have label");
//             Vibration.cancel();
//             await flutterTts.speak(object.label);
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(object.label),
//                 duration: const Duration(milliseconds: 500),
//               ),
//             );
//           }
//         }
//         return;
//       }
//     }
//     lastPressed = null;
//   }

//   Rect _scaleBoundingBox(Rect boundingBox) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     double imageWidth = 448;
//     double imageHeight = 448;
//     double displayWidth = screenWidth - 20;
//     double displayHeight = screenHeight * 0.8;
//     final left = (boundingBox.left / imageWidth) * (displayWidth) + 10;
//     final width = (boundingBox.width / imageWidth) * (displayWidth);

//     final top = (boundingBox.top / imageHeight) * (displayHeight) + 10;
//     final height = (boundingBox.height / imageHeight) * displayHeight;
//     return Rect.fromLTWH(left, top, width, height);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     // double imageWidth = 720;
//     // double imageHeight = 1280;
//     // double displayWidth = screenWidth - 20;
//     // double displayHeight = screenHeight * 0.8;
//     return Scaffold(
//       appBar: AppBar(title: const Text("Image Viewer")),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Listener(
//               onPointerMove: _onPointerMove,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 10,
//                     left: 10,
//                     child: Image.file(
//                       File(widget.picture.path),
//                       width: screenWidth - 20,
//                       height: screenHeight * 0.8,
//                     ),
//                   ),
//                   ...objects.map(
//                     (object) {
//                       final rect = _scaleBoundingBox(object.boundingBox);
//                       return Positioned(
//                         left: rect.left,
//                         top: rect.top,
//                         width: rect.width,
//                         height: rect.height,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.red, width: 2),
//                           ),
//                         ),
//                       );
//                       // double left = (object.boundingBox.left / imageWidth) *
//                       //         (displayWidth) +
//                       //     10;
//                       // double width = (object.boundingBox.width / imageWidth) *
//                       //     (displayWidth);

//                       // double top = (object.boundingBox.top / imageHeight) *
//                       //         (displayHeight) +
//                       //     10;
//                       // double height =
//                       //     (object.boundingBox.height / imageHeight) *
//                       //         displayHeight;
//                       // return Positioned(
//                       //     left: left,
//                       //     top: top,
//                       //     width: width,
//                       //     height: height,
//                       //     child: GestureDetector(
//                       //         onTap: () {
//                       //           print('pressed');
//                       //           if (object.labels.isNotEmpty) {
//                       //             ScaffoldMessenger.of(context).showSnackBar(
//                       //               SnackBar(
//                       //                 content: Text(object.labels[0].text),
//                       //               ),
//                       //             );
//                       //           }
//                       //           // ScaffoldMessenger.of(con)
//                       //         },
//                       //         child: Container(
//                       //           decoration: BoxDecoration(
//                       //             border:
//                       //                 Border.all(color: Colors.red, width: 4),
//                       //           ),
//                       //         )));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         child: const Icon(Icons.arrow_back),
//       ),
//     );
//   }
// }
