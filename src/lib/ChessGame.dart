import 'package:chessclock/ChessClock.dart';
import 'package:chessclock/ClockStats.dart';
import 'package:chessclock/GameStats.dart';

class ChessGame {
  int _result;
  int _currentPlayer = 0;
  Duration _duration;
  ChessClock _chessclock;

  int get currentPlayer => _currentPlayer;

  int get result => _result;

  ChessGame(duration) {
    _chessclock = ChessClock();
    _duration = duration;
    _result = 0;
  }

  void makeTurn(int player) {
    if (!_chessclock.isRunning()) {
      if(_result == 0) {
        _chessclock.start(player);
        _currentPlayer = player;
      } else {
        _chessclock.reset();
        _currentPlayer = 0;
      }
    } else {
      _chessclock.toggle(player);
      _currentPlayer = player == 1 ? 2 : 1;
    }
  }

  bool isRunning() {
    return _chessclock.isRunning();
  }

  void checkGameOverCondition() {
    // End condition
    if (_chessclock.isRunning()) {
      ClockStats clockStats = _chessclock.getStats();
      if (clockStats.elapsedPlayer1.compareTo(_duration) > 0) {
        _chessclock.stop();
        _result = 2;
        _currentPlayer = 0;
      } else if (clockStats.elapsedPlayer2.compareTo(_duration) > 0) {
        _chessclock.stop();
        _result = 1;
        _currentPlayer = 0;
      }
    }
  }

  GameStats computeGameStats() {
    GameStats gameStats = GameStats(_chessclock.getStats());

    // sanitize the clock values because due to rendering by the timer the clocks may be off by some milliseconds

    gameStats.remainingPlayer1 =
        _duration - gameStats.clockStats.elapsedPlayer1;
    gameStats.elapsedPlayer1 = gameStats.clockStats.elapsedPlayer1;
    if (gameStats.remainingPlayer1 < Duration.zero) {
      gameStats.elapsedPlayer1 =
          gameStats.clockStats.elapsedPlayer1 + gameStats.remainingPlayer1;
      gameStats.remainingPlayer1 = Duration.zero;
    }

    gameStats.remainingPlayer2 =
        _duration - gameStats.clockStats.elapsedPlayer2;
    gameStats.elapsedPlayer2 = gameStats.clockStats.elapsedPlayer2;
    if (gameStats.remainingPlayer2 < Duration.zero) {
      gameStats.elapsedPlayer2 =
          gameStats.clockStats.elapsedPlayer2 + gameStats.remainingPlayer2;
      gameStats.remainingPlayer2 = Duration.zero;
    }

    return gameStats;
  }

  bool isOver(){
    return !_chessclock.isRunning() && _result != 0;
  }
}
