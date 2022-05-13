import 'package:beike_aspectd/aspectd.dart';
import 'package:behavior_recorder_of_kit_example/main.dart';

@Aspect()
@pragma("vm:entry-point")
class CallDemo {
  @pragma("vm:entry-point")
  CallDemo();

  @Call("package:behavior_recorder_of_kit_example/main.dart",
        "_MyAppState","initPlatformState")
  @pragma("vm:entry-point")
  void _initPlatformState(PointCut pointCut) {
    print('call initPlatformState');
    pointCut.proceed();
  }

}