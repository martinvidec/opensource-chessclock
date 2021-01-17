import 'package:chessclock/ClockStats.dart';

class ChessClock {

  Stopwatch _player1Stopwatch;
  Stopwatch _player2Stopwatch;

  ChessClock() {
    _player1Stopwatch = Stopwatch();
    _player2Stopwatch = Stopwatch();
  }

  void start(int player) {
    player == 1 ? _player1Stopwatch.start() : _player2Stopwatch.start();
  }

  void toggle(int player) {
    if (_player1Stopwatch.isRunning && player == 1) {
      _player1Stopwatch.stop();
      _player2Stopwatch.start();
    } else if (_player2Stopwatch.isRunning && player == 2){
      _player2Stopwatch.stop();
      _player1Stopwatch.start();
    }
  }

  void stop() {
    _player1Stopwatch.isRunning ? _player1Stopwatch.stop() : _player2Stopwatch
        .stop();
  }

  void reset() {
    _player1Stopwatch.reset();
    _player2Stopwatch.reset();
  }

  bool isRunning() {
    return _player1Stopwatch.isRunning || _player2Stopwatch.isRunning;
  }

  ClockStats getStats() {
    return ClockStats(_player1Stopwatch.elapsed, _player2Stopwatch.elapsed);
  }
}
