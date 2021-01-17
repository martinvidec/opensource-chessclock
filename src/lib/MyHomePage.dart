import 'dart:async';
import 'package:chessclock/ChessGame.dart';
import 'package:chessclock/GameStats.dart';
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

  ChessGame _chessGame;
  Timer _timer;
  String _stopwatchPlayer1Text;
  String _stopwatchPlayer2Text;
  String _elapsedTimeText;
  String _infoPlayer1Text;
  String _infoPlayer2Text;

  @override
  void initState() {
    super.initState();

    _initMembers();
    _initTimer();
  }

  void _initMembers() {
    _chessGame = ChessGame(_duration);
    _stopwatchPlayer1Text = _formatDuration(_duration);
    _stopwatchPlayer2Text = _formatDuration(_duration);
    _elapsedTimeText = _formatDuration(Duration.zero);
    _infoPlayer1Text = "";
    _infoPlayer2Text = "";
  }
  
  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      if (_chessGame.isRunning()) {
        _chessGame.checkGameOverCondition();

        GameStats gameStats = _chessGame.computeGameStats();

        _elapsedTimeText = _formatDuration(
            gameStats.elapsedPlayer1 +
                gameStats.elapsedPlayer2);
        _stopwatchPlayer1Text =
            _formatDuration(gameStats.remainingPlayer1);
        _stopwatchPlayer2Text =
            _formatDuration(gameStats.remainingPlayer2);

        setState(() {
          if (_chessGame.getResult() == 1) {
            _infoPlayer1Text = "YOU WON";
            _infoPlayer2Text = "YOU LOST";
          } else if (_chessGame.getResult() == 2) {
            _infoPlayer1Text = "YOU LOST";
            _infoPlayer2Text = "YOU WON";
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _player1TimerClicked() {
    if(!_chessGame.isOver()) {
      _chessGame.makeTurn(1);
    } else {
      setState(() {
        _initMembers();
      });
    }
  }

  void _player2TimerClicked() {
    if(!_chessGame.isOver()) {
      _chessGame.makeTurn(2);
    } else {
      setState(() {
        _initMembers();
      });
    }
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
                  key: Key("player2TurnBtn"),
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
              key: Key("player1TurnBtn"),
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
