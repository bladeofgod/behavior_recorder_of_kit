import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:behavior_recorder_of_kit/behavior_recorder_of_kit.dart';

void main() {
  const MethodChannel channel = MethodChannel('behavior_recorder_of_kit');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await BehaviorRecorderOfKit.platformVersion, '42');
  });
}
