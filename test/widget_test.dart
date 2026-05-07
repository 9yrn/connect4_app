// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connect4_app/main.dart';
import 'package:connect4_app/view_model/game_view_model.dart';

void main() {
  testWidgets('Connect 4 home screen smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(),
        child: const Connect4App(),
      ),
    );

    await tester.pump();

    expect(find.text('Connect 4'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}
