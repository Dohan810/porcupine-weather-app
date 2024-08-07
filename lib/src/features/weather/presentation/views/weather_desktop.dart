import 'package:flutter/material.dart';
import 'package:weather_wise/src/features/weather/widgets/buttons/link_button.dart';
import 'package:weather_wise/src/features/weather/widgets/static/no_results_found.dart';
import 'package:weather_wise/src/features/weather/application/providers.dart';
import 'package:weather_wise/src/features/weather/widgets/wrappers/blur_wrapper.dart';
import 'package:weather_wise/src/features/weather/widgets/additional_info_weather.dart';
import 'package:weather_wise/src/features/weather/widgets/city_search_box.dart';
import 'package:weather_wise/src/features/weather/widgets/current_weather.dart';
import 'package:weather_wise/src/features/weather/widgets/forecast_weather.dart';
import 'package:weather_wise/src/features/weather/widgets/sun_path_weather.dart';
import 'package:weather_wise/utils/formatting_utils.dart';
import 'package:provider/provider.dart';

class FeatureWeatherDesktop extends StatefulWidget {
  const FeatureWeatherDesktop({super.key});

  @override
  State<FeatureWeatherDesktop> createState() => _FeatureWeatherDesktopState();
}

class _FeatureWeatherDesktopState extends State<FeatureWeatherDesktop> {
  @override
  Widget build(BuildContext context) {
    String city = Provider.of<WeatherProvider>(context).city;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: () async {
          final weatherProvider =
              Provider.of<WeatherProvider>(context, listen: false);
          await weatherProvider.getWeatherData();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section: Current Weather
            const Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  CurrentWeather(),
                ],
              ),
            ),
            addSpace(4),
            // Right Section: Forecast and Details
            BlurWrapper(
              inverted: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: ListView(
                  children: [
                    const CitySearchBox(),
                    addSpace(8),
                    Consumer<WeatherProvider>(builder: (context, provider, _) {
                      final state = provider.forecastWeatherState;

                      switch (state) {
                        case WeatherState.error:
                          return const NoResultsPage();
                        default:
                      }
                      return Column(
                        children: [
                          const ForecastWeather(),
                          addSpace(8),
                          const CurrentSunRiseWeather(),
                          addSpace(8),
                          const CurrentWeatherDetails(),
                          addSpace(8),
                          LinkTextButton(
                              text: "Read more about '$city' weather",
                              townName:
                                  Provider.of<WeatherProvider>(context).city),
                          addSpace(8),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
