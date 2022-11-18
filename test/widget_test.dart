// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:my_first_app/main.dart';

class Person {
  Person(String paramNama, int? umr) {
    nama = paramNama;
    umur = umr;
  }

  String nama = 'Ade muhammad';
  int? umur;

  sayGoodbye(String paramNama) => 'Good Bye $paramNama, from $nama';
}

void main() {
  var persons = Person('Muhammad Ary', 13);
  // persons.nama = 'Muhammad Ary';
  // persons.umur = 13;
  // ignore: avoid_print
  print(persons.nama);
  print(persons.umur);
  print(persons.sayGoodbye('Ahmad'));
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
