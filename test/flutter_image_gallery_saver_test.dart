import 'dart:typed_data';

import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFlutterImageGallerySaverPlatform
    extends FlutterImageGallerySaverPlatform {
  Uint8List? savedImageBytes;
  String? savedFilePath;

  @override
  Future<void> saveImage(Uint8List imageBytes, String? fileName) async {
    savedImageBytes = imageBytes;
    return Future.value();
  }

  @override
  Future<void> saveFile(String filePath, String? fileName) async {
    savedFilePath = filePath;
    return Future.value();
  }
}

void main() {
  group('FlutterImageGallerySaver', () {
    late MockFlutterImageGallerySaverPlatform mockPlatform;
    late FlutterImageGallerySaverPlatform originalPlatform;

    setUp(() {
      mockPlatform = MockFlutterImageGallerySaverPlatform();
      originalPlatform = FlutterImageGallerySaverPlatform.instance;
      FlutterImageGallerySaverPlatform.instance = mockPlatform;
    });

    tearDown(() {
      FlutterImageGallerySaverPlatform.instance = originalPlatform;
    });

    test('saveImage calls platform saveImage with correct image bytes',
        () async {
      final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      await FlutterImageGallerySaver.saveImage(testBytes);
      expect(mockPlatform.savedImageBytes, equals(testBytes));
    });

    test('saveFile calls platform saveFile with correct file path', () async {
      final testFilePath = '/path/to/test.png';
      await FlutterImageGallerySaver.saveFile(testFilePath);
      expect(mockPlatform.savedFilePath, equals(testFilePath));
    });
  });
}
