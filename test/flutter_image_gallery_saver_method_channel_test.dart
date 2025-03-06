import 'package:flutter/services.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('dev.knottx.flutter_image_gallery_saver');

  late MethodChannelFlutterImageGallerySaver platform;

  setUp(() {
    platform = MethodChannelFlutterImageGallerySaver();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('saveImage sends correct method call and arguments', () async {
    final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

    late MethodCall recordedCall;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      recordedCall = call;

      return null;
    });

    await platform.saveImage(testBytes);
    expect(recordedCall.method, equals('save_image'));
    expect(recordedCall.arguments,
        equals({'image_bytes': testBytes, 'file_name': null}));
  });

  test('saveFile sends correct method call and arguments', () async {
    final testFilePath = '/path/to/test_image.png';

    late MethodCall recordedCall;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      recordedCall = call;
      return null;
    });

    await platform.saveFile(testFilePath);

    expect(recordedCall.method, equals('save_file'));
    expect(
        recordedCall.arguments,
        equals({
          'file_path': testFilePath,
          'file_name': testFilePath.split('/').last
        }));
  });
}
