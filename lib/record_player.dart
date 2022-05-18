

import 'dart:collection';

import 'package:behavior_recorder_of_kit/recorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

///[RecordPlayer]'s listener.
/// * For using to manipulate [Recorder].
abstract class RecordPlayerListener{

  ///Fetch a event-bundle by [startTime]
  ///
  ///  * it's only matched one event-bundle in many sources.
  RecordBundle? extractRecordBundle(int startTime);

  ///clean all event-record of source.
  void cleanRecords();

  ///remove last event-bundle in source's queue.
  ///
  ///  * more see [RecordPlayer.removeLast].
  void removeLast();

}

enum PlayerStatus{
  ///record are playing
  playing,

  ///record-player are ready for record some event, only in this status.
  recording,

  /// Disable the player
  ///
  ///  * e.g finish recording will switch player in this status.
  shutdown,
}

///event source.
enum SourceType{
  ///event from text-input
  textInput,
  ///event from gesture
  gesture,
}

///a slot of tape.
///
/// * it marke a event-bundle by [startTime] and [type] , fetch by [RecordPlayerListener.extractRecordBundle].
class TapeSlot{

  ///startTime of [RecordBundle]
  final int startTime;

  ///the [type] of [RecordBundle]'s source.
  final SourceType type;

  TapeSlot(this.startTime, this.type);

}


/// A recorde player.
///
/// To play a [Recorder] that registered it self by [registerSrource].
/// And also , it can control the recorder's functional by [startRecord] and [finishRecord].
///
/// * more see : [PlayerStatus]
class RecordPlayer{

  static RecordPlayer? _instance;

  factory RecordPlayer() {
    _instance ??= RecordPlayer._();
    return _instance!;
  }

  RecordPlayer._();

  ///All [RecordBundle]'s [_timeLine]
  final Queue<TapeSlot> _timeLine = Queue();

  ///Hold some [Recorder]'s [RecordPlayerListener] and identify by [SourceType].
  final Map<SourceType, RecordPlayerListener> _listenrs = {};

  final ValueNotifier<PlayerStatus> playerStatus = ValueNotifier(PlayerStatus.shutdown);

  ///This method will open recorder's function, than you can record some action.
  void startRecord() {
    playerStatus.value = PlayerStatus.recording;
  }

  ///This method will close recorder's function, normaly you can play replay
  ///after call this.
  void finishRecord() {
    playerStatus.value = PlayerStatus.shutdown;
  }


  ///[Recorder] register a [RecordPlayerListener] by this method.
  ///And will make it have reocrder and play function.
  void registerSrource(SourceType type, RecordPlayerListener listenr) {
    _listenrs[type] = listenr;
  }

  ///record a event.
  void record(SourceType type, int startTime) {
    _timeLine.add(TapeSlot(startTime, type));
  }

  ///Erase all [_timeLine]'s event and related [Recorder._recordQueue].
  void eraseTape() {
    _timeLine.clear();
    _listenrs.forEach((key, value) {
      value.cleanRecords();
    });
  }

  ///remove [_timeLine]'s last element, and related source's last element.
  ///
  /// * sometime we trigger [play] by a tap, and this will be record in queue,
  /// * so we need to remove the last element by [withType] = [SourceType.gesture].
  ///
  void removeLast({SourceType? withType}) {
    if(_timeLine.isNotEmpty) {
      _timeLine.removeLast();
    }
    if(withType != null) {
      _listenrs[withType]?.removeLast();
    } else {
      _listenrs.forEach((key, value) {
        value.removeLast();
      });
    }
  }

  ///Start play records.
  void play() {
    playerStatus.value = PlayerStatus.playing;
    _decodeTape().listen((bundle) {
      bundle.performe();
    });
  }

  ///Fetch a [TapeSlot] from [_timeLine] and decode it to [RecordBundle]
  Stream<RecordBundle> _decodeTape() async* {
    while(_timeLine.isNotEmpty) {
      final slot = _timeLine.removeFirst();
      final bundle = _listenrs[slot.type]?.extractRecordBundle(slot.startTime);
      if(bundle != null && !bundle.isErrorBundle) {
        yield bundle;
        if(_timeLine.isNotEmpty) {
          final nextStartTime = _timeLine.first.startTime;
          await Future.delayed(Duration(milliseconds: nextStartTime - bundle.endTime));
        }
      }
    }
    playerStatus.value = PlayerStatus.shutdown;
  }


  // Queue<RecordBundle> getTap() {}

}












