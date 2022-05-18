# behavior_recorder_of_kit

用户行为的录制及重放，支持手势和输入行为的录制。

例如，测试人员可以通过录制`复现行为`，并将其发送到服务器上，随后由对应开发人员下载导入并进行`bug复现`。
此方法同样适用于线上用户。

## Getting Started

首先添加 `import 'package:behavior_recorder_of_kit/behavior_recorder_of_kit.dart';`到`main.dart`文件。

### 录制和播放

通过 `RecordPlayer().startRecord()`开始录制，以及`RecordPlayer().finishRecord()`结束录制。

录制结束后，通过 `RecordPlayer().play();` 进行重播。

    Tip: 所录制的行为事件是一次性的，即：在播放后将会失效。 
         如果需要重复播放，可以考虑通过RecordPlayer().exportTape()将事件导出。


### 记录的导出和导入

如果需要将录制的记录导出，可以通过 `RecordPlayer().exportTape()`方法。 

    Tip: 导出后的序列化方式需要自行定义。
    
当我们需要从外部导入行为记录时，可以通过 `RecordPlayer().loadRecords();` 方法：

```
                  //导入录制前，要开启录制功能
                  RecordPlayer().startRecord();
                  while(cache.isNotEmpty) {
                    RecordPlayer().loadRecords(cache.removeFirst());
                  }
                  //结束导入后，建议关闭录制。
                  RecordPlayer().finishRecord();
                  
                  //之后通过下方法即可播放记录。
                  RecordPlayer().play()
``` 

## 扩展用法

### 增加录制器

如果需要录制其它的事件，可以通过继承 `Recorder` 以及 `RecordBundle`来完成。

```
///事件包，用于缓存你的事件和一些必要属性
class YourRecordBundle extends RecordBundle<YourEvent> {
    //...code
}

///事件收录器,记录事件并产出 事件包
class YourRecorder extends Recorder<YourRecordBundle> {
    //...code
}

```

### 自定义手势&输入录制器
如果你需要定制目前的`手势录制器: gestureRecorder` 和 `输入录制器: textInputRecorder`，可以通过
继承 `Recorder` 并替换对应的 `gestureRecorder` 和 `textInputRecorder` 全局变量来实现。







