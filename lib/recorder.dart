

import 'dart:collection';

import 'package:behavior_recorder_of_kit/record_player.dart';
import 'package:beike_aspectd/aspectd.dart';

///A base class for event bundle.
///It cache a real event and performe it.
abstract class RecordBundle<T>{

  ///For make this bundle occure an error.
  bool get isErrorBundle => startTime <= 0;

  ///A bundle of event's start time.
  final int startTime;

  ///A bundle of event's closure time.
  final int endTime;

  RecordBundle(this.startTime, this.endTime);

  ///Get event' record
  T get eventRecord;

  ///Perform the [eventRecord]
  void performe();

}

///A base class that for real source-event recorder.
///
/// * It record event by [_recordQueue] and all events are one-off.
/// * It also connect to [RecordPlayer] by [RecordPlayerListener].
abstract class Recorder<T extends RecordBundle> implements RecordPlayerListener{

  Recorder() {
    RecordPlayer().registerSrource(type, this);
    RecordPlayer().playerStatus.addListener(_playerLIstener);
    _frozen = RecordPlayer().playerStatus.value != PlayerStatus.idle;
  }

  ///For record event.
  final Queue<T> _recordQueue = Queue<T>();

  ///Will stop recorder.
  bool _frozen = true;

  Queue<T> get recordQueue => _recordQueue;

  bool get frozen => _frozen;

  ///For listen the [RecordPlayer]'s [PlayerStatus].
  void _playerLIstener() {
    _frozen = RecordPlayer().playerStatus.value != PlayerStatus.idle;
  }

  ///Record an event.
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

  @override
  RecordBundle? extractRecordBundle(int startTime) {
    return (recordQueue.isNotEmpty && recordQueue.first.startTime == startTime) ? recordQueue.removeFirst() : null;
  }

  ///The event's type.
  ///
  /// * more see [SourceType].
  SourceType get type;

  ///For manipulate [pointCut].
  void handleHook(PointCut pointCut);

}



















