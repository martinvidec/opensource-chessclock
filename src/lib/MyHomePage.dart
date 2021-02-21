import 'dart:async';
import 'package:chessclock/AppColorScheme.dart';
import 'package:chessclock/ChessGame.dart';
import 'package:chessclock/GameStats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static double _fps = 1 / 60;
  static String _durationKey = 'duration';

  ChessGame _chessGame;
  Timer _timer;
  String _stopwatchPlayer1Text;
  String _stopwatchPlayer2Text;
  String _elapsedTimeText;
  TextEditingController _controller = TextEditingController();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _showClearButton = _controller.text.length > 0;
      });
    });

    _loadPreferences();
    _initMembers();
    _initTimer();
  }

  void _initMembers() {
    _chessGame = ChessGame(_duration);
    _stopwatchPlayer1Text = _formatDuration(_duration);
    _stopwatchPlayer2Text = _formatDuration(_duration);
    _elapsedTimeText = _formatDuration(Duration.zero);
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: (_fps * 1000).floor()),
        (Timer t) {
      if (_chessGame.isRunning()) {
        _chessGame.checkGameOverCondition();

        GameStats gameStats = _chessGame.computeGameStats();

        _elapsedTimeText = _formatDuration(
            gameStats.elapsedPlayer1 + gameStats.elapsedPlayer2);
        _stopwatchPlayer1Text = _formatDuration(gameStats.remainingPlayer1);
        _stopwatchPlayer2Text = _formatDuration(gameStats.remainingPlayer2);

        setState(() {});
      }
    });
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int secs = prefs.getInt(_durationKey);
    print('duration in sec $secs');
    if (secs != null) {
      _duration = Duration(seconds: secs);
    }
    _controller.text = _duration.inSeconds.toString();
    setState(() {
      _initMembers();
    });
  }

  void _savePreferences() async {
    if (_controller.text.isNotEmpty && int.tryParse(_controller.text) != null) {
      int value = int.tryParse(_controller.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(_durationKey, value);
      setState(() {
        _duration = Duration(seconds: value);
        if (!_chessGame.isRunning()) {
          _initMembers();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _playerTimerClicked(int player) {
    if (!_chessGame.isOver()) {
      _chessGame.makeTurn(player);
    } else {
      setState(() {
        _initMembers();
      });
    }
  }

  Widget _iconForPlayer(int player) {
    if (_chessGame.isRunning() && _chessGame.currentPlayer == player) {
      return Icon(
        Icons.alarm,
        size: 48,
      );
    }
    if (_chessGame.isOver() && _chessGame.result == player) {
      return Icon(
        Icons.emoji_events,
        color: AppColorScheme.wonColor,
        size: 48,
      );
    }
    if (_chessGame.isOver() && _chessGame.result != player) {
      return Icon(
        Icons.emoji_flags,
        color: AppColorScheme.lostColor,
        size: 48,
      );
    }
    return SizedBox(
      height: 48,
      width: 48,
    );
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return null;
    }

    return IconButton(
        onPressed: () => _controller.clear(), icon: Icon(Icons.clear));
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
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("OSCC Settings",
                style: Theme.of(context).textTheme.headline4),
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: AppColorScheme.drawerHeaderColor)),
          ),
          ListTile(
              title: Row(children: [
            Expanded(
              child: TextField(
                key: Key("durationsInSecs"),
                controller: _controller,
                decoration: InputDecoration(
                    hintText: 'duration in seconds',
                    suffixIcon: _getClearButton()),
              ),
            )
          ])),
          ListTile(
            title: Row(
              children: [
                FlatButton(
                  shape: StadiumBorder(),
                  color: AppColorScheme.buttonBackgroundColor,
                  key: Key("saveBtn"),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Save',
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  onPressed: _savePreferences,
                )
              ],
            ),
          )
        ],
      )),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack(
        // Stack added in preparation for animations - wip
        children: <Widget>[
          Center(
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
                    child: FlatButton(
                      shape: StadiumBorder(),
                      color: AppColorScheme.buttonBackgroundColor,
                      key: Key("player2TurnBtn"),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$_stopwatchPlayer2Text',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      onPressed: () {
                        _playerTimerClicked(2);
                      },
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: RotatedBox(quarterTurns: 2, child: _iconForPlayer(2)),
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: Text(
                    '$_elapsedTimeText',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Spacer(),
                Text(
                  '$_elapsedTimeText',
                  style: Theme.of(context).textTheme.headline3,
                ),
                Container(child: _iconForPlayer(1)),
                Spacer(),
                FlatButton(
                  shape: StadiumBorder(),
                  color: AppColorScheme.buttonBackgroundColor,
                  key: Key("player1TurnBtn"),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$_stopwatchPlayer1Text',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  onPressed: () {
                    _playerTimerClicked(1);
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
