

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
  void _hookTextInput(PointCut pointCut) {
    textInputRecorder.handleHook(pointCut);
    pointCut.proceed();
  }
}

class TextInputEventBundle extends RecordBundle<MethodCall>{

  TextInputEventBundle(int startTime, int endTime, this.methodCall) : super(startTime, endTime);

  final MethodCall methodCall;

  @override
  MethodCall get eventRecord => methodCall;

  @override
  void performe() {
    final bytedata = SystemChannels.textInput.codec.encodeMethodCall(methodCall);
    ServicesBinding.instance?.defaultBinaryMessenger.handlePlatformMessage(SystemChannels.textInput.name, bytedata, null);
  }

}


class TextInputRecorder extends Recorder<TextInputEventBundle> {


  @override
  void handleHook(PointCut pointCut) {
    if(pointCut.positionalParams.isEmpty) {
      return;
    }
    final int startTime = DateTime.now().millisecondsSinceEpoch;
    final methodCall = pointCut.positionalParams.first;
    final int endTime = DateTime.now().millisecondsSinceEpoch;
    enqueu(TextInputEventBundle(startTime, endTime, methodCall));
  }

  @override
  SourceType get type => SourceType.textInput;

}








