import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver_platform_interface.dart';

/// An implementation of [FlutterImageGallerySaverPlatform] that uses method channels.
class MethodChannelFlutterImageGallerySaver
    extends FlutterImageGallerySaverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('com.knottx.flutter_image_gallery_saver');

  @override
  Future<void> saveImage(
    Uint8List imageBytes, {
    required int quality,
    String? name,
  }) async {
    return methodChannel.invokeMethod('save_image', {
      'image_bytes': imageBytes,
      'quality': quality,
      'name': name,
    });
  }

  @override
  Future<void> saveFile(
    String filePath, {
    String? name,
  }) {
    return methodChannel.invokeMethod('save_file', {
      'file_path': filePath,
      'name': name,
    });
  }
}
