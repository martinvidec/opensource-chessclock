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
  static Duration _duration = Duration(seconds: 30);

  Stopwatch _stopwatchPlayer1 = Stopwatch();
  String _stopwatchPlayer1Text = _formatDuration(_duration);
  Stopwatch _stopwatchPlayer2 = Stopwatch();
  String _stopwatchPlayer2Text = _formatDuration(_duration);
  bool _gameRunning = false;
  Timer _periodic;
  String _elapsedTimeText = "00:00:00.000";
  String _infoPlayer1Text = "";
  String _infoPlayer2Text = "";
  int _result = 0;

  @override
  void initState() {
    super.initState();
    _periodic = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      if (_gameRunning) {
        _result = _checkEndGameCondition();
        Duration elapsedPlayer1 = _stopwatchPlayer1.elapsed;
        Duration elapsedPlayer2 = _stopwatchPlayer2.elapsed;

        Duration remainingPlayer1 = _duration - elapsedPlayer1;
        if(remainingPlayer1.isNegative) {
          elapsedPlayer1 = elapsedPlayer1 + remainingPlayer1;
          remainingPlayer1 = Duration.zero;
        }

        Duration remainingPlayer2 = _duration - elapsedPlayer2;
        if(remainingPlayer2.isNegative) {
          elapsedPlayer2 = elapsedPlayer2 + remainingPlayer2;
          remainingPlayer2 = Duration.zero;
        }
        
        _elapsedTimeText = _formatDuration(elapsedPlayer1 + elapsedPlayer2);
        _stopwatchPlayer1Text = _formatDuration(remainingPlayer1);
        _stopwatchPlayer2Text = _formatDuration(remainingPlayer2);

        setState(() {
          if (_result == 1) {
            _infoPlayer1Text = "YOU WON";
            _infoPlayer2Text = "YOU LOST";
          } else if (_result == 2) {
            _infoPlayer1Text = "YOU LOST";
            _infoPlayer2Text = "YOU WON";
          }
        });
      }
    });
  }

  void _player1TimerClicked() {
    setState(() {
      if (_gameRunning &&
          _stopwatchPlayer1.isRunning &&
          !_stopwatchPlayer2.isRunning) {
        _stopwatchPlayer1.stop();
        _stopwatchPlayer2.start();
      } else if (!_gameRunning && _result == 0) {
        _stopwatchPlayer1.start();
        _gameRunning = true;
      } else if (!_gameRunning && _result != 0){
        _resetGame();
      }
    });
  }

  void _player2TimerClicked() {
    setState(() {
      if (_gameRunning &&
          _stopwatchPlayer2.isRunning &&
          !_stopwatchPlayer1.isRunning) {
        _stopwatchPlayer2.stop();
        _stopwatchPlayer1.start();
      } else if (!_gameRunning && _result == 0) {
        _stopwatchPlayer2.start();
        _gameRunning = true;
      } else if (!_gameRunning && _result != 0){
        _resetGame();
      }
    });
  }

  // TODO doc
  int _checkEndGameCondition() {
    // End condition
    if (_stopwatchPlayer1.elapsed.compareTo(_duration) > 0) {
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
    _gameRunning = false;
  }

  void _resetGame(){
    setState((){
      _gameRunning = false;
      _stopwatchPlayer1.reset();
      _stopwatchPlayer2.reset();
      _stopwatchPlayer1Text = _formatDuration(_duration);
      _stopwatchPlayer2Text = _formatDuration(_duration);
      _elapsedTimeText = "00:00:00.000";
      _infoPlayer1Text = "";
      _infoPlayer2Text = "";
      _result = 0;
    });
  }

  static String _formatDuration(Duration duration) {
    return '${duration.inHours.toString().padLeft(2, "0")}:' +
        '${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:' +
        '${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}:' +
        '${duration.inMilliseconds.remainder(1000).toString().padLeft(3, "0")}';
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
            Spacer(),
            Container(
              child: RotatedBox(
                quarterTurns: 2,
                child: OutlineButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$_stopwatchPlayer2Text',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  onPressed: _player2TimerClicked,
                ),
              ),
            ),
            Spacer(),
            RotatedBox(
              quarterTurns: 2,
              child: Text(
                '$_infoPlayer2Text',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            RotatedBox(
              quarterTurns: 2,
              child: Text(
                '$_elapsedTimeText',
                style: Theme.of(context).textTheme.display2,
              ),
            ),
            Spacer(),
            Text(
              '$_elapsedTimeText',
              style: Theme.of(context).textTheme.display2,
            ),
            Text(
              '$_infoPlayer1Text',
              style: Theme.of(context).textTheme.display1,
            ),
            Spacer(),
            OutlineButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$_stopwatchPlayer1Text',
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
              onPressed: _player1TimerClicked,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
