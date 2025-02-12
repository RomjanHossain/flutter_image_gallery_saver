import 'dart:typed_data';

import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver_platform_interface.dart';

class FlutterImageGallerySaver {
  FlutterImageGallerySaver._();

  /// Save image to gallery
  static Future<void> saveImage(
    Uint8List imageBytes, {
    int quality = 100,
    String? name,
  }) async {
    return FlutterImageGallerySaverPlatform.instance.saveImage(
      imageBytes,
      quality: quality,
      name: name,
    );
  }

  /// Save file PNG，JPG，JPEG image or video
  /// located at [filePath] to gallery.
  static Future<void> saveFile(
    String filePath, {
    String? name,
  }) async {
    return FlutterImageGallerySaverPlatform.instance.saveFile(
      filePath,
      name: name,
    );
  }
}
