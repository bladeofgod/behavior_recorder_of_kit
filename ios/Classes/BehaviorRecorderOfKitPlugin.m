#import "BehaviorRecorderOfKitPlugin.h"
#if __has_include(<behavior_recorder_of_kit/behavior_recorder_of_kit-Swift.h>)
#import <behavior_recorder_of_kit/behavior_recorder_of_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "behavior_recorder_of_kit-Swift.h"
#endif

@implementation BehaviorRecorderOfKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBehaviorRecorderOfKitPlugin registerWithRegistrar:registrar];
}
@end
