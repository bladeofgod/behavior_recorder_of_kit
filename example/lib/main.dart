import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:behavior_recorder_of_kit/behavior_recorder_of_kit.dart';
import 'package:behavior_recorder_of_kit_example/hook_example.dart';

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
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState(22);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState(int a) async {
    print('normal print');
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
            return GestureDetector(
              onTap: () {
                Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => MyApp()));
              },
              child: Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
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
