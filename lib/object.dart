import 'package:flutter/material.dart';

class DetectedObject {
  final Rect boundingBox;
  final String label;
  final String distance;

  DetectedObject(
      {required this.boundingBox, required this.label, required this.distance});

  factory DetectedObject.fromMap(Map<String, dynamic> json) {
    final boundingBox = Rect.fromLTRB(
        json['box'][0], json['box'][1], json['box'][2], json['box'][3]);
    final label = json['class'];
    final distance = json['distance'];
    return DetectedObject(
        boundingBox: boundingBox, label: label, distance: distance);
  }
}
