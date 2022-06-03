import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';


import 'package:flutter/services.dart';
import 'package:behavior_recorder_of_kit/behavior_recorder_of_kit.dart';
// import 'package:behavior_recorder_of_kit_example/hook_example.dart';

import 'package:flutter_ume/flutter_ume.dart'; // UME 框架
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart'; // UI 插件包
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart'; // 性能插件包
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart'; // 代码查看插件包
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart'; // 设备信息插件包
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart'; // debugPrint 插件包
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart'; // Dio 网络请求调试工具


///flutter/bin/cache/dart-sdk/bin/dart dart-sdk/sdk/pkg/vm/bin/dump_kernel.dart behavior_recorder_of_kit/example/.dart_tool/flutter_build/9808370ea32bdc205f8f752e6ebb568e/app.dill out.dill.txt
///
void main() {

  if (kDebugMode) {
    PluginManager.instance                                 // 注册插件
      ..register(BehaviorRecorder())
      ..register(WidgetInfoInspector())
      ..register(WidgetDetailInspector())
      ..register(ColorSucker())
      ..register(AlignRuler())
      ..register(ColorPicker())                            // 新插件
      ..register(TouchIndicator())                         // 新插件
      ..register(Performance())
      ..register(ShowCode())
      ..register(MemoryInfoPage())
      ..register(CpuInfoPage())
      ..register(DeviceInfoPanel())
      ..register(Console());                  // 传入你的 Dio 实例
    // flutter_ume 0.3.0 版本之后
    runApp(UMEWidget(child: MyApp(), enable: true)); // 初始化
  } else {
    runApp(MyApp());
  }

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Queue<RecordBundle> cache = Queue();



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
                // ElevatedButton(onPressed: () {
                //   RecordPlayer().startRecord();
                // }, child: const Text('start recording')),
                // ElevatedButton(onPressed: () {
                //   RecordPlayer().removeLast(withType: SourceType.gesture);
                //   RecordPlayer().finishRecord();
                // }, child: const Text('finish recording.')),
                ElevatedButton(onPressed: () {
                  Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => const DemoPage(text: 'page-root')));
                }, child: const Text('to demo page')),
                //
                // const Divider(height: 4, color: Colors.blue,),
                //
                // ElevatedButton(onPressed: () {
                //   cache.addAll(RecordPlayer().exportTape());
                // }, child: const Text('make a tape')),
                //
                // ElevatedButton(onPressed: () {
                //   RecordPlayer().startRecord();
                //   while(cache.isNotEmpty) {
                //     RecordPlayer().loadRecords(cache.removeFirst());
                //   }
                //   RecordPlayer().finishRecord();
                // }, child: const Text('load a tape')),
                //
                // // const SizedBox(
                // //   width: double.infinity, height: 20,
                // //   child: TextField(),
                // // ),
                //
                // const Divider(height: 4, color: Colors.red,),
                //
                // ElevatedButton(onPressed: () {
                //   RecordPlayer().play();
                // }, child: const Text('replay')),
                //
                // ElevatedButton(onPressed: () {
                //   Future.delayed(const Duration(seconds: 1), () {
                //     RecordPlayer().eraseTape();
                //   });
                // }, child: const Text('clean')),

              ],
            );
          },
        ),
      ),
    );
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
            if(count == 1)
              Expanded(child: ListView(
                children: List.generate(30, (index) => Container(height: 50, color: index % 2 == 0 ? Colors.blue : Colors.red,)),
              ))
          ],
        ),
      ),
    );
  }
}




















