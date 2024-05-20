import 'package:flutter/cupertino.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/models/forecast_data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_example_flutter/src/features/weather/enums/forecast_enum.dart';
import 'package:open_weather_example_flutter/src/features/weather/enums/unit_enums.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  WeatherProvider({http.Client? client})
      : repository = HttpWeatherRepository(
            api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
            client: client ?? http.Client());

  HttpWeatherRepository repository;

  ValueNotifier<String> locationBackgroundNotifier =
      ValueNotifier<String>("assets/default.png");

  String city = 'Cape Town';
  WeatherData? currentWeatherProvider;
  ForecastData? hourlyWeatherProvider;

  WeatherState currentWeatherState = WeatherState.initial;
  WeatherState forecastWeatherState = WeatherState.initial;
  Unit selectedUnit = Unit.metric;
  ForecastRange selectedForecastRange = ForecastRange.daily;

  String? errorMessage;

  List<String> previousSearches = [];

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
      if (!previousSearches.contains(city)) {
        previousSearches.add(capitalize(city));
      }

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
