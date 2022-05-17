

import 'dart:collection';

import 'package:behavior_recorder_of_kit/record_player.dart';
import 'package:beike_aspectd/aspectd.dart';


abstract class RecordBundle<T>{

  bool get isErrorBundle => startTime <= 0;

  ///A bundle of event's start time.
  final int startTime;

  ///A bundle of event's closure time.
  final int endTime;

  RecordBundle(this.startTime, this.endTime);

  T get eventRecord;

  void performe();

}

abstract class Recorder<T extends RecordBundle> implements RecordPlayerListener{

  Recorder() {
    RecordPlayer().registerSrource(type, this);
    RecordPlayer().playerStatus.addListener(_playerLIstener);
  }

  final Queue<T> _recordQueue = Queue<T>();

  bool _frozen = false;

  Queue<T> get recordQueue => _recordQueue;

  bool get frozen => _frozen;

  void _playerLIstener() {
    _frozen = RecordPlayer().playerStatus.value == PlayerStatus.playing;
  }

  void enqueu(T t, {bool needRecord = true}) {
    if(frozen) {
      return;
    }
    _recordQueue.add(t);
    if(needRecord) {
      RecordPlayer().record(type, t.startTime);
    }
  }

  @override
  void cleanRecords() {
    _recordQueue.clear();
  }

  @override
  void removeLast() {
    if(_recordQueue.isNotEmpty) {
      _recordQueue.removeLast();
    }
  }

  SourceType get type;

  void handleHook(PointCut pointCut);

}



















