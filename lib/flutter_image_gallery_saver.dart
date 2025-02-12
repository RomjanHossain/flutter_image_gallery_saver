
import 'flutter_image_gallery_saver_platform_interface.dart';

class FlutterImageGallerySaver {
  Future<String?> getPlatformVersion() {
    return FlutterImageGallerySaverPlatform.instance.getPlatformVersion();
  }
}
