import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:major_ui/camera_screen.dart';
// import 'package:flutter/widgets.dart';

class AppScaffold extends StatefulWidget {
  AppScaffold({super.key, required this.cameras});
  final FlutterTts tts = FlutterTts();
  final List<CameraDescription> cameras;
  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int selectedIndex = 0;
  final List<IconData> icons = [Icons.home, Icons.settings];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Vision",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.teal,
        elevation: 5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CameraScreen(
                cameras: widget.cameras, mode: selectedIndex, tts: widget.tts),
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  if (details.primaryDelta! > 0) {
                    selectedIndex = 1;
                    widget.tts.speak("अनुहार दर्ता गर्न फोटो क्लिक गर्नुहोस्");
                  } else if (details.primaryDelta! < 0) {
                    selectedIndex = 0;
                    widget.tts.speak(
                        "वातावरण को समझ प्राप्त गर्न फोटो क्लिक गर्नुहोस्");
                  }
                });
              },
              child: Container(
                width: double.infinity,
                // height: 70,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      icons[0],
                      size: selectedIndex == 0 ? 70 : 40,
                      color: selectedIndex == 0 ? Colors.blue : Colors.grey,
                    ),
                    Icon(
                      icons[1],
                      size: selectedIndex == 1 ? 70 : 40,
                      color: selectedIndex == 1 ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // body: Center(
      //     child: ListView.builder(
      //         scrollDirection: Axis.horizontal,
      //         itemCount: icons.length,
      //         itemBuilder: (context, index) {
      //           return GestureDetector(
      //               onTap: () {
      //                 setState(() {
      //                   selectedIndex = index;
      //                 });
      //               },
      //               child: Icon(icons[index],
      //                   size: 50,
      //                   color: selectedIndex == index
      //                       ? Colors.blue
      //                       : Colors.grey));
      //         })),
    );
  }
}

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Smart Vision",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//         backgroundColor: Colors.teal, // Matching the gradient
//         elevation: 5,
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           // Camera preview with the custom widget
//           CameraPreviewWidget(controller: _controller),

//           // Floating Action Button for capturing an image
//           Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: FloatingActionButton(
//                 onPressed: _captureImage,
//                 backgroundColor:
//                     Colors.tealAccent, // Gradient or solid color for the FAB
//                 elevation: 6,
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
