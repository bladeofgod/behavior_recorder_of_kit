

import 'dart:collection';

import 'package:behavior_recorder_of_kit/recorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';


abstract class RecordPlayerListener{

  RecordBundle? extractRecordBundle(int startTime);

  void cleanRecords();

  void removeLast();

}

enum PlayerStatus{
  playing,
  idle,
}

enum SourceType{
  text,
  gesture,
}

class TapeSlot{

  final int startTime;

  final SourceType type;

  TapeSlot(this.startTime, this.type);

}

class RecordPlayer{

  static RecordPlayer? _instance;

  factory RecordPlayer() {
    _instance ??= RecordPlayer._();
    return _instance!;
  }

  RecordPlayer._();

  final Queue<TapeSlot> _timeLine = Queue();

  final Map<SourceType, RecordPlayerListener> _listenrs = {};

  final ValueNotifier<PlayerStatus> playerStatus = ValueNotifier(PlayerStatus.idle);

  void registerSrource(SourceType type, RecordPlayerListener listenr) {
    _listenrs[type] = listenr;
  }

  void record(SourceType type, int startTime) {
    _timeLine.add(TapeSlot(startTime, type));
  }

  void eraseTape() {
    _timeLine.clear();
    _listenrs.forEach((key, value) {
      value.cleanRecords();
    });
  }

  ///remove [_timeLine]'s last element, and related source's last element.
  ///
  /// * sometime we trigger [play] by a tap, and this will be record in queue,
  /// * so we need to remove the last element.
  void removeLast() {
    if(_timeLine.isNotEmpty) {
      _timeLine.removeLast();
    }
    _listenrs.forEach((key, value) {
      value.removeLast();
    });
  }

  void play() {
    playerStatus.value = PlayerStatus.playing;
    _decodeTape().listen((bundle) {
      bundle.performe();
    });
  }

  Stream<RecordBundle> _decodeTape() async* {
    while(_timeLine.isNotEmpty) {
      final slot = _timeLine.removeFirst();
      final bundle = _listenrs[slot.type]?.extractRecordBundle(slot.startTime);
      if(bundle != null && !bundle.isErrorBundle) {
        yield bundle;
        final nextStartTime = _timeLine.first.startTime;
        await Future.delayed(Duration(milliseconds: nextStartTime - bundle.endTime));
      }
    }
    playerStatus.value = PlayerStatus.idle;
  }


  // Queue<RecordBundle> getTap() {}

}












