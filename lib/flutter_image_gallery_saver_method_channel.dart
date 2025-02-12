import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_image_gallery_saver_platform_interface.dart';

/// An implementation of [FlutterImageGallerySaverPlatform] that uses method channels.
class MethodChannelFlutterImageGallerySaver extends FlutterImageGallerySaverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_image_gallery_saver');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
