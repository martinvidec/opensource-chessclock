// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:chessclock/MyApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Clock Tests", () {
    testWidgets('Turn buttons player 1 smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      // Two counter buttons with text
      expect(find.text('00:00:30:000'), findsNWidgets(2));

      // Tap the player1TurnBtn
      await tester.tap(find.byKey(Key("player1TurnBtn")));
      await tester.pump(Duration(seconds: 1));

      // Tap the player2TurnBtn
      expect(find.text('00:00:30:000'), findsOneWidget);

      await tester.tap(find.byKey(Key("player1TurnBtn")));
      await tester.pump(Duration(seconds: 1));

      expect(find.text('00:00:30:000'), findsNothing);
    });
  });
}
