

import 'dart:collection';

import 'package:behavior_recorder_of_kit/record_player.dart';
import 'package:beike_aspectd/aspectd.dart';
import 'package:flutter/cupertino.dart';

///A base class for event bundle.
///It cache a real event and perform it.
abstract class RecordBundle<T>{

  RecordBundle(this.startTime, this.endTime, this.type);

  ///For make this bundle occured an error.
  bool get isErrorBundle => startTime <= 0;

  ///A bundle of event's start time.
  final int startTime;

  ///A bundle of event's closure time.
  final int endTime;

  ///The event from what kind of source type.
  final SourceType type;

  ///Get event' record
  T get eventRecord;

  ///Perform the [eventRecord]
  Future perform();


}

///A base class that for real source-event recorder.
///
/// * It record event by [_recordQueue] and all events are one-off.
/// * It also connect to [RecordPlayer] by [RecordPlayerListener].
abstract class Recorder<T extends RecordBundle> implements RecordPlayerListener{

  Recorder() {
    RecordPlayer().registerSource(type, this);
    RecordPlayer().playerStatus.addListener(_playerListener);
    _frozen = RecordPlayer().playerStatus.value != PlayerStatus.recording;
  }

  ///For record event.
  final Queue<T> _recordQueue = Queue<T>();

  ///Will stop recorder.
  bool _frozen = true;

  Queue<T> get recordQueue => _recordQueue;

  bool get frozen => _frozen;

  ///For listen the [RecordPlayer]'s [PlayerStatus].
  void _playerListener() {
    _frozen = RecordPlayer().playerStatus.value != PlayerStatus.recording;
  }

  ///Record an event.
  void enqueue(T t, {bool needRecord = true}) {
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

  @override
  RecordBundle? extractRecordBundle(int startTime) {
    return (recordQueue.isNotEmpty && recordQueue.first.startTime == startTime) ? recordQueue.removeFirst() : null;
  }

  @override
  void loadRecordBundle(RecordBundle bundle) {
    try{
      enqueue(bundle as T);
    }catch (e) {
      debugPrint(e.toString());
    }
  }

  ///The event's type.
  ///
  /// * more see [SourceType].
  SourceType get type;

  ///For manipulate [pointCut].
  void handleHook(PointCut pointCut);

}



















