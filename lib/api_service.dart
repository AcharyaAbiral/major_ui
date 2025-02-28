import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:major_ui/object.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class ApiServiceProcessImage {
  static Future<List<DetectedObject>> uploadImage(
      {required XFile image}) async {
    var uri = Uri.parse(
        "https://722fbvpz-8000.inc1.devtunnels.ms/api/process-image/");
    var request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath('image', image.path,
        filename: p.basename(image.path)));

    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body)['results'];
      return results
          .map<DetectedObject>((e) => DetectedObject.fromMap(e))
          .toList();
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
