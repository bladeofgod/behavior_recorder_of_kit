
import 'dart:math';

import 'package:behavior_recorder_of_kit/record_player.dart';
import 'package:behavior_recorder_of_kit/recorder.dart';
import 'package:beike_aspectd/aspectd.dart';
import 'package:flutter/services.dart';

TextInputRecorder textInputRecorder = TextInputRecorder();


@Aspect()
@pragma("vm:entry-point")
class TextInputHook{
  @Execute('package:flutter/src/services/text_input.dart', 'TextInput', '-_handleTextInputInvocation')
  @pragma('vm:entry-point')
  dynamic _hookTextInput(PointCut pointCut) {
    textInputRecorder.handleHook(pointCut);
    return pointCut.proceed();
  }
}

class TextInputEventBundle extends RecordBundle<MethodCall>{

  TextInputEventBundle(int startTime, int endTime, this.methodCall) : super(startTime, endTime);

  final MethodCall methodCall;

  @override
  MethodCall get eventRecord => methodCall;

  @override
  void performe() {
    _updateRecord();
    final bytedata = SystemChannels.textInput.codec.encodeMethodCall(methodCall);
    ServicesBinding.instance?.defaultBinaryMessenger.handlePlatformMessage(SystemChannels.textInput.name, bytedata, null);
  }

  void _updateRecord() {
    if(methodCall.arguments is List) {
      final list = methodCall.arguments as List;
      list[0] = TextInputRecorder.id;
    }
  }

}


class TextInputRecorder extends Recorder<TextInputEventBundle> {

  static int id = 0;

  @override
  void handleHook(PointCut pointCut) {
    if(pointCut.positionalParams.isEmpty) {
      return;
    }
    final int startTime = DateTime.now().millisecondsSinceEpoch;
    final methodCall = pointCut.positionalParams.first;
    if(methodCall is MethodCall && methodCall.arguments is List) {
      final list = methodCall.arguments as List;
      if(list.isNotEmpty) {
        id = list.first;
      }
    }
    final int endTime = DateTime.now().millisecondsSinceEpoch;
    enqueu(TextInputEventBundle(startTime, endTime, methodCall));
  }

  @override
  SourceType get type => SourceType.textInput;

}








