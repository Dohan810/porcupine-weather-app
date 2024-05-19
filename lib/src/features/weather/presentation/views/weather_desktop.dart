import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/shared/widgets/buttons/link_button.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/forecast_weather.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
            const SizedBox(width: 16),
            // Right Section: Forecast and Details
            Consumer<WeatherProvider>(builder: (context, provider, _) {
              final state = provider.currentWeatherState;

              switch (state) {
                case WeatherState.loading:
                  return const CircularProgressIndicator();
                default:
              }

              return BlurWrapper(
                inverted: true,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: ListView(
                    children: [
                      const CitySearchBox(),
                      const SizedBox(height: 16),
                      const ForecastWeather(),
                      const SizedBox(height: 16),
                      const CurrentSunRiseWeather(),
                      const SizedBox(height: 16),
                      const CurrentWeatherDetails(),
                      const SizedBox(height: 16),
                      LinkTextButton(
                          text: "Read more about '$city' weather",
                          townName: Provider.of<WeatherProvider>(context).city),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
