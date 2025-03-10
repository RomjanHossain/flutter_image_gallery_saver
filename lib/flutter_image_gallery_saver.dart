import 'dart:typed_data';

import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver_platform_interface.dart';

class FlutterImageGallerySaver {
  FlutterImageGallerySaver._();

  /// Save image to gallery
  static Future<void> saveImage(
    Uint8List imageBytes, [
    String? fileName,
  ]) async {
    return FlutterImageGallerySaverPlatform.instance
        .saveImage(imageBytes, fileName);
  }

  /// Save file PNG，JPG，JPEG image or video
  /// located at [filePath] to gallery.
  static Future<void> saveFile(String filePath, [String? fileName]) async {
    return FlutterImageGallerySaverPlatform.instance
        .saveFile(filePath, fileName);
  }
}
