// Habit Garden widget tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_garden/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HabitGardenApp());

    // Verify that splash screen elements are present
    expect(find.text('Habit Garden'), findsOneWidget);
    expect(find.text('Grow with every habit'), findsOneWidget);
    expect(find.text('🌱'), findsOneWidget);
  });

  testWidgets('App has correct title', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const HabitGardenApp());

    // Verify the app title through MaterialApp
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, 'Habit Garden');
  });
}
