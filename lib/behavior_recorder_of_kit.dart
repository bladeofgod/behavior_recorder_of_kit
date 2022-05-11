
import 'dart:async';

import 'package:flutter/services.dart';

class BehaviorRecorderOfKit {
  static const MethodChannel _channel = MethodChannel('behavior_recorder_of_kit');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
