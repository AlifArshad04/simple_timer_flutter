import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int hours = 0;
  int minutes = 0;
  int seconds = 00;
  int setHours = 0;
  int setMinutes = 0;
  int setSeconds = 0;
  int milliseconds = 0;
  int totalDuration = 0;
  int timeRemaining = 0;
  int timeLeft = 0;
  bool isRunning = false;
  Timer? timer;
  double progressValue = 0.0;

  final player = AudioPlayer();                   // Create a player
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() async {
    totalDuration = (hours * 3600000) + (minutes * 60000) + (seconds * 1000) + milliseconds;
    await player.setAsset('assets/audio/timerend.wav');
    timer = Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
      setState(()  {
        if (milliseconds > 0) {
          milliseconds -= 10;
        } else {
          milliseconds = 999;
          if (seconds > 0) {
            seconds--;
          } else {
            seconds = 59;
            if (minutes > 0) {
              minutes--;
            } else {
              minutes = 59;
              if (hours > 0) {
                hours--;
              } else {
                // Timer has reached 0, you can perform any action here
                timer.cancel();
                setState(() {
                  hours = 0;
                  minutes = 0;
                  seconds = 0;
                  milliseconds = 0;
                  progressValue = 0.0;
                });
                player.play();
              }
            }
          }
        }
        timeRemaining = (hours * 3600000) + (minutes * 60000) + (seconds * 1000) + milliseconds;
        if (timeRemaining == 0) {
          progressValue = 0;
        } else {
          progressValue = timeRemaining / totalDuration;
          // print(progressValue);
        }
      });
    });
    isRunning = true;
  }


  void pauseTimer() {
    timer?.cancel();
    isRunning = false;
    timeRemaining = (hours * 3600000) + (minutes * 60000) + (seconds * 1000) + milliseconds;
  }

  void resetTimer () async {
    timer?.cancel();
    isRunning = false;
    setState(() {
      hours = setHours;
      minutes = setMinutes;
      seconds = setSeconds;
      milliseconds = 0;
      progressValue = 100;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
          width: 250,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(

              keyboardType: TextInputType.number,
              onChanged: (value) {
                setHours = int.parse(value);
              },
              decoration: InputDecoration(
                labelText: 'Hours',
              ),
      ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setMinutes = int.parse(value);
                },
                decoration: InputDecoration(
                  labelText: 'Minutes',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setSeconds = int.parse(value);
                },
                decoration: InputDecoration(
                  labelText: 'Seconds',
                ),
              ),
            ],
          ),
        ),
          ElevatedButton(
            onPressed: resetTimer,
            child: Text('Set'),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            '$hours:$minutes:$seconds.$milliseconds',
            style: TextStyle(fontSize: 50),
          ),
          SizedBox(height: 20),
          SizedBox(
              width: 300,
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 20.0,
                // valueColor: Animation<Color> Colors.Red,
              )
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: isRunning ? pauseTimer : startTimer,
                // child: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                child: Text(isRunning ? 'Pause' : 'Start'),
              ),
              ElevatedButton(
                onPressed: resetTimer,
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}