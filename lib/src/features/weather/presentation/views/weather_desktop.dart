import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/forecast_weather.dart';

class FeatureWeatherDesktop extends StatefulWidget {
  const FeatureWeatherDesktop({super.key});

  @override
  State<FeatureWeatherDesktop> createState() => _WeatherPageMobileState();
}

class _WeatherPageMobileState extends State<FeatureWeatherDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Spacer(),
        CitySearchBox(),
        Spacer(),
        CurrentWeather(),
        Spacer(),
        ForecastWeather(),
        Spacer()
      ],
    );
  }
}
