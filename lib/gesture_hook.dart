
import 'dart:collection';

import 'package:beike_aspectd/aspectd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';


GestureRecorder gestureRecorder = GestureRecorder();

@Aspect()
@pragma('vm:entry-point')
class GestureHook{

  @Call('package:flutter/src/gestures/binding.dart', 'GestureBinding', '-handlePointerEvent')
  @pragma('vm:entry-point')
  void _hookHandlePointerEvent(PointCut pointCut) {
    //print('event runtime : ${pointCut.positionalParams.first.runtimeType}');
    gestureRecorder.handlePointerEventHook(pointCut);
    pointCut.proceed();
  }

}

class PointerEventBundle{

  PointerEventBundle.load(this.startTime, this.endTime, this._eventQueue);

  final Queue<PointerEvent> _eventQueue;

  ///A bundle of pointer-event's start time;
  final int startTime;

  ///A bundle of pointer-event's closure time;
  final int endTime;

  Queue<PointerEvent> get eventQueue => _eventQueue;

}


class GestureRecorder implements GestureHookHandler{

  final Queue<PointerEventBundle> _recordQueue = Queue<PointerEventBundle>();

  final Queue<PointerEvent> _cacheBucket = Queue();

  Queue<PointerEventBundle> get eventRecords => _recordQueue;

  int get timeStamp => DateTime.now().millisecondsSinceEpoch;

  int? startTime;

  void cleanRecords() {
    _recordQueue.clear();
  }

  @override
  void handlePointerEventHook(PointCut pointCut) {
    if(pointCut.positionalParams.isEmpty) {
      return;
    }
    startTime ??= timeStamp;
    final event = pointCut.positionalParams.first;
    _cacheBucket.add(event);
    if(event is PointerUpEvent || event is PointerCancelEvent) {
      final int endTime = DateTime.now().millisecondsSinceEpoch;
      _recordQueue.add(PointerEventBundle.load(startTime!, endTime, Queue.from(_cacheBucket)));
      startTime = null;
      _cacheBucket.clear();
    }
  }
}


abstract class GestureHookHandler{

  void handlePointerEventHook(PointCut pointCut);

}






