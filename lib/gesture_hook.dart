
import 'dart:collection';

import 'package:behavior_recorder_of_kit/record_player.dart';
import 'package:behavior_recorder_of_kit/recorder.dart';
import 'package:beike_aspectd/aspectd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

///A gesture event recorder, you can replace it for custom.
Recorder gestureRecorder = GestureRecorder();

@Aspect()
@pragma('vm:entry-point')
class GestureHook{

  @Call('package:flutter/src/gestures/binding.dart', 'GestureBinding', '-handlePointerEvent')
  @pragma('vm:entry-point')
  void _hookHandlePointerEvent(PointCut pointCut) {
    gestureRecorder.handleHook(pointCut);
    pointCut.proceed();
  }

}

///Text-inpute event's bundle.
class PointerEventBundle extends RecordBundle<Queue<PointerEvent>>{

  PointerEventBundle.load(int startTime, int endTime, SourceType type, this._eventQueue)
   : super(startTime, endTime, type);

  final Queue<PointerEvent> _eventQueue;

  @override
  Queue<PointerEvent> get eventRecord => _eventQueue;

  @override
  void perform() {
    while(_eventQueue.isNotEmpty) {
      GestureBinding.instance?.handlePointerEvent(_eventQueue.removeFirst());
    }
  }


}

///Gesture recorder will record all event about gesture.
///
/// Also see [PlayerStatus].
class GestureRecorder extends Recorder<PointerEventBundle>{

  ///one serials pointer-event bucket.
  final Queue<PointerEvent> _cacheBucket = Queue();

  int get timeStamp => DateTime.now().millisecondsSinceEpoch;

  int? startTime;


  @override
  void handleHook(PointCut pointCut) {
    if(pointCut.positionalParams.isEmpty) {
      return;
    }
    startTime ??= timeStamp;
    final event = pointCut.positionalParams.first;
    _cacheBucket.add(event);
    if(event is PointerUpEvent || event is PointerCancelEvent) {
      final int endTime = DateTime.now().millisecondsSinceEpoch;
      enqueu(PointerEventBundle.load(startTime!, endTime, type, Queue.from(_cacheBucket)));
      startTime = null;
      _cacheBucket.clear();
    }
  }


  @override
  SourceType get type => SourceType.gesture;

}








