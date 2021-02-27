import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
}

void playSound(){
  print("play sound");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(title: 'Timer Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
  Duration duration = Duration(seconds: 5);
  String stringFormat = "00:00:00";
  
  startTimer() async {
  await AndroidAlarmManager.oneShot(
        duration, 3, playSound,
        exact: true, wakeup: true, alarmClock: true, allowWhileIdle: true);
    int secondsDuration = duration.inSeconds;
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
          if (secondsDuration < 0) {
            //secondsDuration = duration.inSeconds;
            timer.cancel();
          } else {
            stringFormat = format(Duration(seconds: secondsDuration));
            secondsDuration--;
          }
      });
    });
  }
  
  //static AudioCache audioCache = new AudioCache();
  //static AudioPlayer audioSource = new AudioPlayer(playerId: "id");
  static final playerx = new AudioCache(fixedPlayer: AudioPlayer());

  static stopSound() {
    print("call stop");
    AndroidAlarmManager.cancel(3);
    playerx.fixedPlayer.stop();
  }

  static playSound() async {
    print("play");
    playerx.play('alarmBomb.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Timer',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              '$stringFormat',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
      floatingActionButton:Row( 
      mainAxisAlignment: MainAxisAlignment.end,
      children: [FloatingActionButton(
        onPressed: startTimer,
        tooltip: 'Start timer',
        child: Icon(Icons.timer),
      ),
       FloatingActionButton(
        onPressed: stopSound,
        tooltip: 'stop sound',
        child: Icon(Icons.stop),
      ),]),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
