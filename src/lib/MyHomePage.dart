import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  Stopwatch _stopwatchPlayer1 = Stopwatch();
  String _stopwatchPlayer1Text = "";
  Stopwatch _stopwatchPlayer2 = Stopwatch();
  String _stopwatchPlayer2Text = "";
  bool _gameStarted = false;
  Duration _duration = Duration(seconds: 30);
  Timer _everySecond;

  @override
  void initState(){
    super.initState();
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t){
      int _result = _checkEndGameCondition();
      setState(() {
        if(_result == 0){
          _stopwatchPlayer1Text = _stopwatchPlayer1.elapsed.inSeconds.toString();
          _stopwatchPlayer2Text = _stopwatchPlayer2.elapsed.inSeconds.toString();
        } else if(_result == 1){
          _stopwatchPlayer1Text = "YOU WON";
          _stopwatchPlayer2Text = "YOU LOST";
        } else if(_result == 2){
          _stopwatchPlayer1Text = "YOU LOST";
          _stopwatchPlayer2Text = "YOU WON";
        }
      });
    });
  }
  
  void _player1TimerClicked(){
    setState(() {
      if(_gameStarted && _stopwatchPlayer1.isRunning && !_stopwatchPlayer2.isRunning){
        _stopwatchPlayer1.stop();
        _stopwatchPlayer2.start();
      } else if(!_gameStarted){
        _stopwatchPlayer1.start();
        _gameStarted = true;
      }
    });
  }

  void _player2TimerClicked(){
    setState(() {
      if(_gameStarted && _stopwatchPlayer2.isRunning && !_stopwatchPlayer1.isRunning){
        _stopwatchPlayer2.stop();
        _stopwatchPlayer1.start();
      } else if(!_gameStarted){
        _stopwatchPlayer2.start();
        _gameStarted = true;
      }
    });
  }

  // TODO doc
  int _checkEndGameCondition(){
    // End condition
    if(_stopwatchPlayer1.elapsed.compareTo(_duration) > 0) {
      _stopStopwatches();
      return 2;
    } else if (_stopwatchPlayer2.elapsed.compareTo(_duration) > 0) {
      _stopStopwatches();
      return 1;
    }
    return 0;
  }

  void _stopStopwatches() {
    _stopwatchPlayer1.stop();
    _stopwatchPlayer2.stop();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            Container(
              child: RotatedBox(
                quarterTurns: 2,
                child: OutlineButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$_stopwatchPlayer2Text',
                    style: Theme.of(context).textTheme.display3,),
                  ),
                  onPressed: _player2TimerClicked,),
              ),
            ),
            OutlineButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$_stopwatchPlayer1Text',
                style: Theme.of(context).textTheme.display3,),
              ),
              onPressed: _player1TimerClicked,
            )
          ],
        ),
      ),
    );
  }
}