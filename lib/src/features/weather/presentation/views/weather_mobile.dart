import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/forecast_weather.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';
import 'package:provider/provider.dart';

class FeatureWeatherMobile extends StatefulWidget {
  const FeatureWeatherMobile({super.key});

  @override
  State<FeatureWeatherMobile> createState() => _WeatherPageMobileState();
}

class _WeatherPageMobileState extends State<FeatureWeatherMobile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: () async {
          final weatherProvider =
              Provider.of<WeatherProvider>(context, listen: false);
          await weatherProvider.getWeatherData();
        },
        child: ListView(
          children: [
            const CitySearchBox(),
            const CurrentWeather(),
            addSpace(8),
            const ForecastWeather(),
            addSpace(8),
            const CurrentSunRiseWeather(),
          ],
        ),
      ),
    );
  }
}
