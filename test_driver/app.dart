import 'package:flutter_driver/driver_extension.dart';
import 'package:rental_platform/main.dart' as app;

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_test/flutter_test.dart'; // Import this for testing utilities.

void main() {
  // Enable Flutter Driver extension for testing.
  enableFlutterDriverExtension();

  const MethodChannel channel = MethodChannel('plugins.flutter.io/image_picker');

  TestWidgetsFlutterBinding.ensureInitialized(); // Ensures test environment is set.

  ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
    channel.name,
        (ByteData? message) async {
      try {
        ByteData data = await rootBundle.load('images/placeholder.jpg');
        Uint8List bytes = data.buffer.asUint8List();

        Directory tempDir = await getTemporaryDirectory();
        File file = File('${tempDir.path}/tmp.tmp');
        await file.writeAsBytes(bytes);

        print("Mock image path: ${file.path}");

        return channel.codec.encodeSuccessEnvelope(file.path);
      } catch (e) {
        print("Error in mock image picker: $e");
        return channel.codec.encodeErrorEnvelope(code: 'error', message: e.toString());
      }
    },
  );

  // Start the app.
  app.main();
}
