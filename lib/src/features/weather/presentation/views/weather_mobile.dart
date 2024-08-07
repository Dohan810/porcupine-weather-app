import 'package:flutter/material.dart';
import 'package:weather_wise/src/features/weather/widgets/buttons/link_button.dart';
import 'package:weather_wise/src/features/weather/widgets/static/no_results_found.dart';
import 'package:weather_wise/src/features/weather/application/providers.dart';
import 'package:weather_wise/src/features/weather/widgets/additional_info_weather.dart';
import 'package:weather_wise/src/features/weather/widgets/city_search_box.dart';
import 'package:weather_wise/src/features/weather/widgets/current_weather.dart';
import 'package:weather_wise/src/features/weather/widgets/forecast_weather.dart';
import 'package:weather_wise/src/features/weather/widgets/sun_path_weather.dart';
import 'package:weather_wise/utils/formatting_utils.dart';
import 'package:provider/provider.dart';

class FeatureWeatherMobile extends StatefulWidget {
  const FeatureWeatherMobile({super.key});

  @override
  State<FeatureWeatherMobile> createState() => _WeatherPageMobileState();
}

class _WeatherPageMobileState extends State<FeatureWeatherMobile> {
  @override
  Widget build(BuildContext context) {
    String city = Provider.of<WeatherProvider>(context).city;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: () async {
          final weatherProvider =
              Provider.of<WeatherProvider>(context, listen: false);
          await weatherProvider.getWeatherData();
        },
        child: Column(
          children: [
            const CitySearchBox(),
            Expanded(
              child: ListView(
                children: [
                  addSpace(4),
                  Consumer<WeatherProvider>(builder: (context, provider, _) {
                    final state = provider.forecastWeatherState;

                    switch (state) {
                      case WeatherState.error:
                        return const NoResultsPage();
                      default:
                    }

                    return Column(
                      children: [
                        const CurrentWeather(),
                        addSpace(8),
                        const ForecastWeather(),
                        addSpace(8),
                        const CurrentSunRiseWeather(),
                        addSpace(8),
                        const CurrentWeatherDetails(),
                        addSpace(8),
                        LinkTextButton(
                          text: "Read more about '$city' weather",
                          townName: Provider.of<WeatherProvider>(context).city,
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
