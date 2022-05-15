import 'dart:ui';

import 'package:beike_aspectd/aspectd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/gestures/binding.dart';
import 'package:flutter/src/widgets/binding.dart';
import 'package:flutter/src/scheduler/binding.dart';
import 'package:flutter/src/gestures/binding.dart';
import 'package:sky_engine/ui/ui.dart';
//import 'package:sky_engine/ui/hooks.dart';
//import 'package:sky_engine/ui/platform_dispatcher.dart';


// @Aspect()
// @pragma("vm:entry-point")
// class CallDemo {
//   @pragma("vm:entry-point")
//   CallDemo();
//
//   @Call('package:behavior_recorder_of_kit_example/main.dart',
//         '_MyAppState','-initPlatformState')
//   @pragma("vm:entry-point")
//   void _initPlatformState(PointCut pointCut) {
//     print('call initPlatformState  ${pointCut.positionalParams}');
//     pointCut.proceed();
//   }
//
//   @Call('package:flutter/src/gestures/binding.dart', 'GestureBinding', '-handlePointerEvent')
//   @pragma('vm:entry-point')
//   void _hookDsipatch(PointCut pointCut) {
//     print('hook _hookDsipatch');
//     pointCut.proceed();
//   }
//
//   @Call('package:flutter/src/scheduler/binding.dart', 'SchedulerBinding', '-handleBeginFrame')
//   @pragma('vm:entry-point')
//   void _hookScheduler(PointCut pointCut) {
//     print('hook _hookScheduler');
//     pointCut.proceed();
//   }
//
//   @Call('package:sky_engine/ui/hooks.dart', '', '+.*', isRegex: true)
//   @pragma('vm:entry-point')
//   static void _hookHandlePointerDataPacket(PointCut pointCut) {
//     print('hook _beginFrame');
//     pointCut.proceed();
//   }
// ///hook ensureInitialized
//   // @Call('package:flutter/src/widgets/binding.dart', 'WidgetsFlutterBinding', '+ensureInitialized')
//   // @pragma('vm:entry-point')
//   // static void _hookWidgetBinding(PointCut pointCut) {
//   //   print('hook ensureInitialized');
//   //   pointCut.proceed();
//   // }
//
//
//   @Call('package:flutter/src/material/page.dart', 'MaterialPageRoute', '-buildContent')
//   @pragma('vm:entry-point')
//   void _hookBuildPage(PointCut pointCut) {
//     print('hook page handle');
//     pointCut.proceed();
//   }
//
// }