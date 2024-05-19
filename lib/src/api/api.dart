import 'package:open_weather_example_flutter/main.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/enums/unit_enums.dart';
import 'package:provider/provider.dart';

/// Uri builder class for the OpenWeatherMap API
class OpenWeatherMapAPI {
  OpenWeatherMapAPI(this.apiKey);

  final String apiKey;

  static const String _apiBaseUrl = "api.openweathermap.org";
  static const String _apiPath = "/data/2.5/";

  Uri weather(String city) => _buildUri(
        endpoint: "weather",
        parametersBuilder: () => cityQueryParameters(city),
      );

  Uri forecast(String city) => _buildUri(
        endpoint: "forecast",
        parametersBuilder: () => cityQueryParameters(city),
      );

  Uri _buildUri({
    required String endpoint,
    required Map<String, dynamic> Function() parametersBuilder,
  }) {
    return Uri(
      scheme: "https",
      host: _apiBaseUrl,
      path: "$_apiPath$endpoint",
      queryParameters: parametersBuilder(),
    );
  }

  Map<String, dynamic> cityQueryParameters(String city) {
    // Defaults to metric
    Unit unit = Unit.metric;

    if (navigatorKey.currentContext != null) {
      unit = Provider.of<WeatherProvider>(
        navigatorKey.currentContext!,
        listen: false,
      ).selectedUnit;
    }

    return {
      "q": city,
      "appid": apiKey,
      "units": unit == Unit.imperial ? "imperial" : "metric",
      "type": "like",
      "cnt": "30",
    };
  }
}
