import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:behavior_recorder_of_kit/gesture_hook.dart';
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


  @override
  void initState() {
    super.initState();
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
                  debugPrint('1');
                }, child: const Text('1')),
                ElevatedButton(onPressed: () {
                  debugPrint('2');
                }, child: const Text('2')),
                ElevatedButton(onPressed: () {
                  debugPrint('3');
                }, child: const Text('3')),

                const Divider(height: 2, color: Colors.red,),

                ElevatedButton(onPressed: () {
                  gestureRecorder.eventRecords.removeLast();

                  Stream<Queue<PointerEvent>> action(int len) async* {
                    for(int i = 0; i < len; i++) {
                      final bundle = gestureRecorder.eventRecords.removeFirst();
                      yield bundle.eventQueue;
                      final nextStart = gestureRecorder.eventRecords.first.startTime;
                      await Future.delayed(Duration(milliseconds: nextStart - bundle.endTime));
                    }
                  }

                  action(gestureRecorder.eventRecords.length).listen((event) {
                    while(event.isNotEmpty) {
                      GestureBinding.instance?.handlePointerEvent(event.removeFirst());
                    }
                  });

                }, child: const Text('replay')),

                ElevatedButton(onPressed: () {
                  Future.delayed(const Duration(seconds: 1), () {
                    gestureRecorder.cleanRecords();
                  });
                }, child: const Text('clean')),

              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('tap');
          },
        ),
      ),
    );
  }
}
