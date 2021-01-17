import 'package:chessclock/ClockStats.dart';

class GameStats {
  final ClockStats clockStats;
  Duration remainingPlayer1;
  Duration remainingPlayer2;
  Duration elapsedPlayer1;
  Duration elapsedPlayer2;

  GameStats(ClockStats this.clockStats);
}