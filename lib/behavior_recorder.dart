import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:behavior_recorder_of_kit/recorder.dart';
import 'package:flutter_ume/util/floating_widget.dart';
import 'package:behavior_recorder_of_kit/record_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';

class BehaviorRecorder extends StatelessWidget implements Pluggable {

  OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      entry = OverlayEntry(builder: (_) => const FloatWidget());
      Future.delayed(const Duration(milliseconds: 100))
          .then((value) => Overlay.of(context)?.insert(entry!));
    } else {
      entry?.remove();
      entry = null;
    }
    return SizedBox();
  }

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  String get displayName => 'Behavior recorder';

  @override
  ImageProvider<Object> get iconImageProvider =>
      const AssetImage('assets/icon_recorder.png',
          package: 'behavior_recorder_of_kit');

  @override
  String get name => 'Behavior recorder';

  @override
  void onTrigger() {
  }
}

class FloatWidget extends StatefulWidget {
  const FloatWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FloatWidgetState();
  }
}

///录制记录的导入和导出工具容器。
/// * 你可以覆盖这个cache来更换容器
/// * 或者操作[RecordPlayer]类进行定制操作。
Queue<RecordBundle> cache = Queue();

class FloatWidgetState extends State<FloatWidget> {
  PlayerStatus status = PlayerStatus.shutdown;

  OverlayEntry? _entry;

  double opacity = 1.0;

  double btnLeft = 10;
  double btnTop = 200;

  void _dragUpdate(DragUpdateDetails details) {
    setState(() {
      btnLeft += details.delta.dx;
      btnTop += details.delta.dy;
    });
  }

  @override
  void initState() {
    super.initState();

    RecordPlayer().playerStatus.addListener(() {
      setState(() {
        status = RecordPlayer().playerStatus.value;
      });
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (status == PlayerStatus.recording) {
        setState(() {
          opacity = (opacity - 1).abs();
        });
      }
    });
  }

  @override
  void dispose() {
    _entry?.remove();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double btnWidth = 48;
    final Size size = MediaQuery.of(context).size;

    Widget wrap({Widget child = const SizedBox(),GestureTapCallback? onPressed}) {
      return GestureDetector(
        onTap: () {
          onPressed?.call();
          _entry?.remove();
          _entry = null;
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ), alignment: Alignment.center,
          child: child,
        ),
      );
    }

    return Positioned(
      left: btnLeft.clamp(0, size.width - btnWidth),
      top: btnTop.clamp(0, size.height - btnWidth),
      child: GestureDetector(
        onTap: () {
          if(_entry == null) {
            _entry = OverlayEntry(
                builder: (c) => Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: size.width,
                    height: 100,
                    color: Colors.black.withOpacity(0.3),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        wrap(onPressed: () {
                          RecordPlayer().startRecord();
                        }, child: const Text('开始录制')),
                        wrap(onPressed: () {
                          RecordPlayer().removeLast(withType: SourceType.gesture);
                          RecordPlayer().finishRecord();
                        }, child: const Text('结束录制')),

                        wrap(onPressed: () {
                          cache.addAll(RecordPlayer().exportTape());
                        }, child: const Text('导出记录')),

                        wrap(onPressed: () {
                          RecordPlayer().startRecord();
                          while(cache.isNotEmpty) {
                            RecordPlayer().loadRecords(cache.removeFirst());
                          }
                          RecordPlayer().finishRecord();
                        }, child: const Text('加载记录')),

                        wrap(onPressed: () {
                          RecordPlayer().play();
                        }, child: const Text('播放')),

                        wrap(onPressed: () {
                          Future.delayed(const Duration(milliseconds: 200), () {
                            RecordPlayer().eraseTape();
                          });
                        }, child: const Text('清除记录')),
                      ],
                    ),
                  ),
                ));
            Overlay.of(context)?.insert(_entry!);
          } else {
            _entry?.remove();
            _entry = null;
          }

        },
        onPanUpdate: _dragUpdate,
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: buildIcon(),
        ),
      ),
    );
  }

  Widget buildIcon() {
    switch (status) {
      case PlayerStatus.playing:
        return const Icon(
          Icons.pause,
          color: Colors.white,
          size: 30,
        );
      case PlayerStatus.recording:
        return AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(seconds: 1),
          child: const Icon(
            Icons.fiber_smart_record_rounded,
            color: Colors.red,
            size: 30,
          ),
        );
      case PlayerStatus.shutdown:
        return const Icon(Icons.play_arrow, color: Colors.white, size: 30);
    }
  }
}
