import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:major_ui/app_scaffold.dart';
import 'package:major_ui/app_theme.dart';
// import 'package:major_ui/camera_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _cameras = await availableCameras();
  runApp(MyApp(cameras: _cameras));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.cameras});
  final List<CameraDescription> cameras;
  // MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Vision",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // home: CameraScreen(
      // cameras: cameras,
      // ),
      home: AppScaffold(cameras: cameras),
    );
  }
}
