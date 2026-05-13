import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shariq_fitness_app/main.dart';

void main() {
  testWidgets('App boots and renders GetMaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
