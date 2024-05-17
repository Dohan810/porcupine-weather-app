import 'package:flutter/cupertino.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/models/forecast_data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;

enum WeatherState { initial, loading, loaded, error }

enum Unit { metric, imperial }

String getUnitName(Unit unit) {
  switch (unit) {
    case Unit.metric:
      return 'Metric';
    case Unit.imperial:
      return 'Imperial';
    default:
      return '';
  }
}

String getTemperatureUnitSymbol(Unit unit) {
  switch (unit) {
    case Unit.metric:
      return 'C';
    case Unit.imperial:
      return 'F';
    default:
      return '';
  }
}

enum ForecastRange { daily, threeHourly }

String getForecastRangeName(ForecastRange range) {
  switch (range) {
    case ForecastRange.daily:
      return 'Daily';
    case ForecastRange.threeHourly:
      return '3 hourly';
    default:
      return '';
  }
}

class WeatherProvider extends ChangeNotifier {
  // Call getWeatherData on initialization
  WeatherProvider() {
    getWeatherData();
  }

  HttpWeatherRepository repository = HttpWeatherRepository(
    api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
    client: http.Client(),
  );

  ValueNotifier<String> locationBackgroundNotifier =
      ValueNotifier<String>("assets/default.png");

  String city = 'Cape Town';
  WeatherData? currentWeatherProvider;
  ForecastData? hourlyWeatherProvider;

  WeatherState currentWeatherState = WeatherState.initial;
  WeatherState forecastWeatherState = WeatherState.initial;

  String? errorMessage;

  Unit selectedUnit = Unit.metric;
  ForecastRange selectedForecastRange = ForecastRange.daily;

  void updateUnit(Unit unit) {
    selectedUnit = unit;
    getWeatherData();
    notifyListeners();
  }

  void updateForecastRange(ForecastRange range) {
    selectedForecastRange = range;
    getForecastData();
    notifyListeners();
  }

  Future<void> getWeatherData() async {
    try {
      currentWeatherState = WeatherState.loading;
      notifyListeners();

      final weather = await repository.getWeather(city: city);
      currentWeatherProvider = weather;

      if (weather == null) {
        throw "Unable to find location";
      }

      _updateBackgroundImage(weather.weather.first.main);
      await getForecastData();

      currentWeatherState = WeatherState.loaded;
    } catch (e) {
      currentWeatherState = WeatherState.error;
      errorMessage = "Unable to find location";
    } finally {
      notifyListeners();
    }
  }

  Future<void> getForecastData() async {
    try {
      forecastWeatherState = WeatherState.loading;
      final forecast = await repository.getForecast(city: city);
      hourlyWeatherProvider = forecast;

      forecastWeatherState = WeatherState.loaded;
    } catch (e) {
      forecastWeatherState = WeatherState.error;
      errorMessage = "Unable to find location";
    } finally {
      notifyListeners();
    }
  }

  void _updateBackgroundImage(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        locationBackgroundNotifier.value = "assets/sunny1.png";
        break;
      case 'clouds':
        locationBackgroundNotifier.value = "assets/cloudy1.png";
        break;
      case 'rain':
        locationBackgroundNotifier.value = "assets/raining1.png";
        break;
      case 'thunderstorm':
        locationBackgroundNotifier.value = "assets/thunder1.png";
        break;
      default:
        locationBackgroundNotifier.value = "assets/default.png";
        break;
    }
  }
}
