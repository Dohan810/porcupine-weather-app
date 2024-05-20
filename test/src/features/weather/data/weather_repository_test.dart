import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_wise/main.dart';
import 'package:weather_wise/src/features/models/forecast_data/static_forecast_data.dart';
import 'package:weather_wise/src/features/models/weather_data/static_weather_data.dart';
import 'package:weather_wise/src/features/weather/application/providers.dart';
import 'package:weather_wise/src/features/weather/data/weather_repository.dart';
import 'package:weather_wise/src/features/weather/application/layout_provider.dart';
import 'package:weather_wise/utils/print_utils.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockWeatherRepository extends Mock implements HttpWeatherRepository {}

class MockClient extends Mock implements http.Client {}

void setup() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<String>("your_api_key", instanceName: "api_key");
}

void main() {
  setup();

  testWidgets('Mock HTTP Test To Get Weather Data',
      (WidgetTester tester) async {
    final mockClient = MockClient();

    PrintUtils.printGreen("Step 1: Pumping the widget with providers");
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
    await tester.pumpAndSettle(Durations.extralong4);

    PrintUtils.printGreen("Step 2: Retrieving WeatherProvider instance");
    final weatherProvider = Provider.of<WeatherProvider>(
      tester.element(find.byType(MyApp)),
      listen: false,
    );

    when(weatherProvider.getWeatherData()).thenAnswer((realInvocation) {
      weatherProvider.currentWeatherProvider = staticWeatherData;

      throw "";
    });

    PrintUtils.printGreen("Step 3: Fetching weather data");
    await weatherProvider.getWeatherData();
    await tester.pumpAndSettle(Durations.extralong4);

    PrintUtils.printGreen("Step 4: Verifying fetched weather data");
    expect(weatherProvider.currentWeatherProvider?.name, 'Cape Town');
    expect(weatherProvider.currentWeatherProvider?.main.temp, 25.0);
    expect(weatherProvider.currentWeatherProvider?.weather.first.main, 'Clear');
  });

  testWidgets('Mock HTTP Test To Get Forecast Data',
      (WidgetTester tester) async {
    final mockClient = MockClient();

    PrintUtils.printGreen("Step 1: Pumping the widget with providers");
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
    await tester.pumpAndSettle(Durations.extralong4);

    PrintUtils.printGreen("Step 2: Retrieving WeatherProvider instance");
    final weatherProvider = Provider.of<WeatherProvider>(
      tester.element(find.byType(MyApp)),
      listen: false,
    );

    when(weatherProvider.getForecastData()).thenAnswer((realInvocation) {
      weatherProvider.hourlyWeatherProvider = staticForecastData;

      throw "";
    });

    PrintUtils.printGreen("Step 3: Fetching forecast data");
    await weatherProvider.getForecastData();
    await tester.pumpAndSettle(Durations.extralong4);

    PrintUtils.printGreen("Step 4: Verifying fetched froecast data");
    expect(weatherProvider.hourlyWeatherProvider?.city.name, 'New York');
    expect(weatherProvider.hourlyWeatherProvider?.list[0].main.feelsLike, 19.0);
  });
}
