// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_wise/src/features/weather/application/providers.dart';
import 'package:weather_wise/src/features/weather/application/layout_provider.dart';
import 'package:weather_wise/utils/print_utils.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_wise/main.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void setup() {
  final getIt = GetIt.instance;

  getIt.registerSingleton<String>("your_api_key", instanceName: "api_key");
}

void main() {
  setUpAll(() {
    setup();
  });

  testWidgets('Add Text To Textfield Search', (WidgetTester tester) async {
    PrintUtils.printYellow(
        "Screen size: ${tester.binding.window.physicalSize}");

    final mockClient = MockClient();

    PrintUtils.printGreen("Step 1: Initializing the test");
    final searchButton = find.byKey(const Key("searchIconButton"));
    final searchField = find.byKey(const Key("searchTextField"));

    PrintUtils.printGreen("Step 2: Pumping the widget with Provider");
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => WeatherProvider(client: mockClient)),
          ChangeNotifierProvider(create: (_) => LayoutProvider()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    PrintUtils.printGreen("Step 3: Tapping the search button");
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    PrintUtils.printGreen("Step 4: Entering text in the search field");
    await tester.enterText(searchField, "Cape Town");

    PrintUtils.printGreen("Step 5: Rebuilding the widget");
    await tester.pump();

    expect(find.text("Cape Town"), findsOneWidget);
  });
}
