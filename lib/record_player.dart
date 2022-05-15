

import 'dart:collection';

import 'package:flutter/gestures.dart';

import 'gesture_hook.dart';

enum PlayerStatus{
  playing,
  idle,
}

mixin RecordPlayer{

  PlayerStatus _status = PlayerStatus.idle;

  PlayerStatus get playerStatus => _status;

  void play() {
    _status = PlayerStatus.playing;
    void simulationPlay(Queue<PointerEvent> queue) {
      while(queue.isNotEmpty) {
        GestureBinding.instance?.handlePointerEvent(queue.removeFirst());
      }
    }
    _readBundle().listen(simulationPlay);
  }

  Stream<Queue<PointerEvent>> _readBundle() async* {
    while(bundleQueue.isNotEmpty) {
      final bundle = bundleQueue.removeFirst();
      yield bundle.eventQueue;
      if(bundleQueue.isNotEmpty) {
        final nextStartTime = bundleQueue.first.startTime;
        await Future.delayed(Duration(milliseconds: nextStartTime - bundle.endTime));
      }
    }
    _status = PlayerStatus.idle;
  }

  Queue<PointerEventBundle> get bundleQueue;

}