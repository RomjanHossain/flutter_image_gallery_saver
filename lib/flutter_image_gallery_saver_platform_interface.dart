import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_image_gallery_saver_method_channel.dart';

abstract class FlutterImageGallerySaverPlatform extends PlatformInterface {
  /// Constructs a FlutterImageGallerySaverPlatform.
  FlutterImageGallerySaverPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterImageGallerySaverPlatform _instance = MethodChannelFlutterImageGallerySaver();

  /// The default instance of [FlutterImageGallerySaverPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterImageGallerySaver].
  static FlutterImageGallerySaverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterImageGallerySaverPlatform] when
  /// they register themselves.
  static set instance(FlutterImageGallerySaverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
