import 'dart:io';
import 'dart:math';

import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:sound_recorder/sound_record.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: ()async{
             var dd= File("/private/var/mobile/Containers/Data/Application/72DAF2BA-F277-4EEA-8B3A-7D102734E4BC/tmp/41552A89-E658-4F2D-93A3-303931347129.m4a");
              if(dd.existsSync()){
                print("Exist");
                print(await getFileSize(dd.path,2));
                getFileInfo( fileUrl: dd.path);
              }else{
                print("object");
              }

            }, child: Text("000"))
,

          RecordButton(recordingFinishedCallback: (dd){
            print(dd);
            print("Finished recording");



          })
          ],
        ),
      ),
    );
  }
  static Future<Map<dynamic, dynamic>?> getFileInfo({required String fileUrl}) async {
    FFmpegKitConfig.enableLogs();
    FFmpegKitConfig();
    Map<dynamic, dynamic>? properties = await FFprobeKit.getMediaInformation(fileUrl).then((session) async {
      final information = session.getMediaInformation();
      if (information == null) {
        // CHECK THE FOLLOWING ATTRIBUTES ON ERROR
        final state = FFmpegKitConfig.sessionStateToString(await session.getState());
        final returnCode = await session.getReturnCode();
        final failStackTrace = await session.getFailStackTrace();
        final duration = await session.getDuration();
        final output = await session.getOutput();
        print("File URL: $fileUrl, State: $state, ReturnCode: $returnCode,FailStackTrace: $failStackTrace,Duration: $duration, 0utPut: $output",
        );
        return null;
      }
      return information.getAllProperties();
    });
    print(properties);
    String format = properties!["streams"][0]['codec_name'];
    String type = properties["streams"][0]['codec_type'];
    String duration = properties["streams"][0]['duration'];
    print("Duration $duration");
    print("Format $format");
    return properties;
  }
  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
