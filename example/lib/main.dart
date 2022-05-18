import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'dart:async';


import 'package:flutter/services.dart';
import 'package:behavior_recorder_of_kit/behavior_recorder_of_kit.dart';
// import 'package:behavior_recorder_of_kit_example/hook_example.dart';

///flutter/bin/cache/dart-sdk/bin/dart dart-sdk/sdk/pkg/vm/bin/dump_kernel.dart behavior_recorder_of_kit/example/.dart_tool/flutter_build/9808370ea32bdc205f8f752e6ebb568e/app.dill out.dill.txt
///
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Queue<RecordBundle> cache = Queue();

  OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (ctx) {
            if(entry == null) {
              entry = OverlayEntry(builder: (_) => const Positioned(
                right: 40, bottom: 100,
                  child: FloatWidget()));
              Future.delayed(const Duration(milliseconds: 100)).then((value) => Overlay.of(ctx)?.insert(entry!));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {
                  RecordPlayer().startRecord();
                }, child: const Text('start recording')),
                ElevatedButton(onPressed: () {
                  RecordPlayer().removeLast(withType: SourceType.gesture);
                  RecordPlayer().finishRecord();
                }, child: const Text('finish recording.')),
                ElevatedButton(onPressed: () {
                  Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => const DemoPage(text: 'page-root')));
                }, child: const Text('to demo page')),

                const Divider(height: 4, color: Colors.blue,),

                ElevatedButton(onPressed: () {
                  cache.addAll(RecordPlayer().exportTape());
                }, child: const Text('make a tape')),

                ElevatedButton(onPressed: () {
                  RecordPlayer().startRecord();
                  while(cache.isNotEmpty) {
                    RecordPlayer().loadRecords(cache.removeFirst());
                  }
                  RecordPlayer().finishRecord();
                }, child: const Text('load a tape')),

                // const SizedBox(
                //   width: double.infinity, height: 20,
                //   child: TextField(),
                // ),

                const Divider(height: 4, color: Colors.red,),

                ElevatedButton(onPressed: () {
                  RecordPlayer().play();
                }, child: const Text('replay')),

                ElevatedButton(onPressed: () {
                  Future.delayed(const Duration(seconds: 1), () {
                    RecordPlayer().eraseTape();
                  });
                }, child: const Text('clean')),

              ],
            );
          },
        ),
      ),
    );
  }



}

class FloatWidget extends StatefulWidget{
  const FloatWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FloatWidgetState();
  }

}

class FloatWidgetState extends State<FloatWidget> {

  PlayerStatus status = PlayerStatus.shutdown;

  double opacity = 1.0;

  @override
  void initState() {
    super.initState();

    RecordPlayer().playerStatus.addListener(() {
      setState(() {
        status = RecordPlayer().playerStatus.value;
      });
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if(status == PlayerStatus.recording) {
        setState(() {
          opacity = (opacity - 1).abs();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: buildIcon(),
    );
  }

  Widget buildIcon() {
    switch(status) {
      case PlayerStatus.playing:
        return const Icon(Icons.pause, color: Colors.white, size: 30,);
      case PlayerStatus.recording:
        return AnimatedOpacity(opacity: opacity, duration: const Duration(seconds: 1),
          child: const Icon(Icons.fiber_smart_record_rounded, color: Colors.red, size: 30,),);
      case PlayerStatus.shutdown:
        return const Icon(Icons.play_arrow, color: Colors.white, size: 30);
    }
  }

}


int count = 0;

class DemoPage extends StatefulWidget{

  final String text;

  const DemoPage({Key? key, required this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DemoPageState();
  }

}

class DemoPageState extends State<DemoPage> {

  double sliderV = 0.5;

  @override
  void initState() {
    super.initState();
    count++;
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('page-$count is from : ${widget.text}', style: const TextStyle(color: Colors.black, fontSize: 18),),
            if(count == 2)
              Slider(value: sliderV, onChanged: (v) {
                setState(() {
                  sliderV = v;
                });
              }),
            ElevatedButton(onPressed: () {
              if(count == 3) {
                count = 0;
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => DemoPage(text: 'page-$count')));
              }
            }, child: Text('btn - $count')),
            if(count == 3)
              const TextField(),
          ],
        ),
      ),
    );
  }
}




















