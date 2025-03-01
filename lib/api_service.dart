import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:major_ui/object.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class ImageProcessingResult {
  final String caption;
  final List<DetectedObject> results;

  ImageProcessingResult({required this.caption, required this.results}) {}
}

class ApiServiceProcessImage {
  static Future<ImageProcessingResult> uploadImage(
      {required XFile image}) async {
    var uri = Uri.parse(
        "https://722fbvpz-8000.inc1.devtunnels.ms/api/process-image/");
    var request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath('image', image.path,
        filename: p.basename(image.path)));

    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body)['results'];
      final caption = jsonDecode(response.body)['caption'];
      List<DetectedObject> detectedObjects = results
          .map<DetectedObject>((e) => DetectedObject.fromMap(e))
          .toList();
      return ImageProcessingResult(caption: caption, results: detectedObjects);
      // return results
      //     .map<DetectedObject>((e) => DetectedObject.fromMap(e))
      //     .toList();
    } else {
      throw Exception("Failed to process image");
    }
  }
}

class ApiServiceFaceRegistration {
  static Future<void> uploadImage(
      {required XFile image, required String name}) async {
    var uri = Uri.parse(
        "https://722fbvpz-8000.inc1.devtunnels.ms/api/face-registration/");
    var request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath('image', image.path,
        filename: p.basename(image.path)));

    request.fields['name'] = name;
    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      // be happy
    } else {
      throw Exception("Failed to process image");
    }
  }
}
