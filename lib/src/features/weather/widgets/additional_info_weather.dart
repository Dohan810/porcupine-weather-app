import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/wrappers/animation_wrapper.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/enums/unit_enums.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/wrappers/blur_wrapper.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CurrentWeatherDetails extends StatelessWidget {
  const CurrentWeatherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherProvider,
        (String city, WeatherState state, WeatherData? weatherData, String?)>(
      selector: (context, provider) => (
        provider.city,
        provider.currentWeatherState,
        provider.currentWeatherProvider,
        provider.errorMessage
      ),
      builder: (context, data, _) {
        final state = data.$2;
        final weatherData = data.$3;
        final unit = Provider.of<WeatherProvider>(context).selectedUnit;

        switch (state) {
          case WeatherState.loading:
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: BlurWrapper(
                child: SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            );
          case WeatherState.loaded:
            return AnimationWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (weatherData != null) ...[
                    Text(
                      'Additional Details',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    addSpace(2),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DataContainer(
                                  title: "Humidity",
                                  value: "${weatherData.main.humidity}%"),
                            ),
                            Expanded(
                              child: DataContainer(
                                  title: "Wind",
                                  value:
                                      "${weatherData.wind.speed.toString()} ${unit == Unit.metric ? 'km/h' : 'mph'}"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DataContainer(
                                  title: "Pressure",
                                  value: "${weatherData.main.pressure} mb/h"),
                            ),
                            Expanded(
                              child: DataContainer(
                                  title: "Visibility",
                                  value: "${weatherData.visibility / 1000} km"),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]
                ],
              ),
            );
          default:
            return Container();
        }
      },
    );
  }
}

class DataContainer extends StatelessWidget {
  final String title;
  final String value;

  const DataContainer({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlurWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
