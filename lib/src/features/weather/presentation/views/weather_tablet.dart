import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/forecast_weather.dart';

class FeatureWeatherTablet extends StatefulWidget {
  const FeatureWeatherTablet({super.key});

  @override
  State<FeatureWeatherTablet> createState() => _WeatherPageMobileState();
}

class _WeatherPageMobileState extends State<FeatureWeatherTablet> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
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
