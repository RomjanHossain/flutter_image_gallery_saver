import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver_platform_interface.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterImageGallerySaverPlatform
    with MockPlatformInterfaceMixin
    implements FlutterImageGallerySaverPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterImageGallerySaverPlatform initialPlatform = FlutterImageGallerySaverPlatform.instance;

  test('$MethodChannelFlutterImageGallerySaver is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterImageGallerySaver>());
  });

  test('getPlatformVersion', () async {
    FlutterImageGallerySaver flutterImageGallerySaverPlugin = FlutterImageGallerySaver();
    MockFlutterImageGallerySaverPlatform fakePlatform = MockFlutterImageGallerySaverPlatform();
    FlutterImageGallerySaverPlatform.instance = fakePlatform;

    expect(await flutterImageGallerySaverPlugin.getPlatformVersion(), '42');
  });
}
