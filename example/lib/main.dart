import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
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

  PlayerStatus status = PlayerStatus.shutdown;

  @override
  void initState() {
    super.initState();

    RecordPlayer().playerStatus.addListener(() {
      setState(() {
        status = RecordPlayer().playerStatus.value;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (ctx) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {
                  RecordPlayer().startRecord();
                }, child: const Text('open player')),
                ElevatedButton(onPressed: () {
                  RecordPlayer().removeLast(withType: SourceType.gesture);
                  RecordPlayer().finishRecord();
                }, child: const Text('shutdown player')),
                ElevatedButton(onPressed: () {
                  Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => const DemoPage(text: 'page-root')));
                }, child: const Text('to demoPage')),

                // const SizedBox(
                //   width: double.infinity, height: 20,
                //   child: TextField(),
                // ),

                const Divider(height: 2, color: Colors.red,),

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('tap');
          },child: Icon(buildIcon()),
        ),
      ),
    );
  }
  IconData buildIcon() {
    switch(status) {
      case PlayerStatus.playing:
        return Icons.pause;
      case PlayerStatus.idle:
        return Icons.play_arrow;
      case PlayerStatus.shutdown:
        return Icons.clear;
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
            ElevatedButton(onPressed: () {
              if(count == 3) {
                count = 0;
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => DemoPage(text: 'page-$count')));
              }
            }, child: Text('btn - $count')),
            if(count == 3)
              TextField(),
          ],
        ),
      ),
    );
  }
}




















