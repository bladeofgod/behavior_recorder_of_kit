

import 'package:beike_aspectd/aspectd.dart';

@Aspect()
@pragma("vm:entry-point")
class KeyboardHook{
  @Execute('package:flutter/src/services/text_input.dart', 'TextInput', '-_handleTextInputInvocation')
  @pragma('vm:entry-point')
  void _hookHandleKeyData(PointCut pointCut) {
    pointCut.proceed();
  }
}








