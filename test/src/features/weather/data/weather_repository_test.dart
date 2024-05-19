import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_weather_example_flutter/main.dart';
import 'package:open_weather_example_flutter/src/features/models/forecast_data/static_forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/static_weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:open_weather_example_flutter/src/shared/application/layout_provider.dart';
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

    print("Step 1: Pumping the widget with providers");
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

    print("Step 2: Retrieving WeatherProvider instance");
    final weatherProvider = Provider.of<WeatherProvider>(
      tester.element(find.byType(MyApp)),
      listen: false,
    );

    when(weatherProvider.getWeatherData()).thenAnswer((realInvocation) {
      weatherProvider.currentWeatherProvider = staticWeatherData;

      throw "";
    });

    print("Step 3: Fetching weather data");
    await weatherProvider.getWeatherData();
    await tester.pumpAndSettle(Durations.extralong4);

    print("Step 4: Verifying fetched weather data");
    expect(weatherProvider.currentWeatherProvider?.name, 'Cape Town');
    expect(weatherProvider.currentWeatherProvider?.main.temp, 25.0);
    expect(weatherProvider.currentWeatherProvider?.weather.first.main, 'Clear');
  });

  testWidgets('Mock HTTP Test To Get Forecast Data',
      (WidgetTester tester) async {
    final mockClient = MockClient();

    print("Step 1: Pumping the widget with providers");
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

    print("Step 2: Retrieving WeatherProvider instance");
    final weatherProvider = Provider.of<WeatherProvider>(
      tester.element(find.byType(MyApp)),
      listen: false,
    );

    when(weatherProvider.getForecastData()).thenAnswer((realInvocation) {
      weatherProvider.hourlyWeatherProvider = staticForecastData;

      throw "";
    });

    print("Step 3: Fetching forecast data");
    await weatherProvider.getForecastData();
    await tester.pumpAndSettle(Durations.extralong4);

    print("Step 4: Verifying fetched froecast data");
    expect(weatherProvider.hourlyWeatherProvider?.city.name, 'New York');
    expect(weatherProvider.hourlyWeatherProvider?.list[0].main.feelsLike, 19.0);
  });
}
