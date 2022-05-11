import Flutter
import UIKit

public class SwiftBehaviorRecorderOfKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "behavior_recorder_of_kit", binaryMessenger: registrar.messenger())
    let instance = SwiftBehaviorRecorderOfKitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
