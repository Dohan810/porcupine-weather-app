import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_wise/src/features/weather/widgets/wrappers/animation_wrapper.dart';
import 'package:weather_wise/src/features/models/forecast_data/forecast_data.dart';
import 'package:weather_wise/src/features/weather/application/providers.dart';
import 'package:weather_wise/src/features/weather/enums/forecast_enum.dart';
import 'package:weather_wise/src/features/weather/widgets/wrappers/blur_wrapper.dart';
import 'package:weather_wise/utils/formatting_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ForecastWeather extends StatelessWidget {
  const ForecastWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        final state = provider.forecastWeatherState;
        final forecastData = provider.hourlyWeatherProvider;

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
            if (forecastData == null) {
              return const Center(child: Text("No forecast data available"));
            }
            final List<WeatherList> forecastList = forecastData.list;

            if (forecastList.isEmpty) return const SizedBox.shrink();

            return AnimationWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forecast",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  addSpace(2),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    child: BlurWrapper(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: true,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: forecastList.map((data) {
                                return Container(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth /
                                        forecastList.length,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: DailyWeather(weatherData: data),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          case WeatherState.initial:
          default:
            return Container();
        }
      },
    );
  }
}

class DailyWeather extends StatelessWidget {
  final WeatherList weatherData;

  const DailyWeather({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final dayTime = getDayTime(context, weatherData.dt);
    final temp = weatherData.main.temp.toInt().toString();
    final iconUrl = weatherData.weather[0].iconUrl;
    final date = DateTime.fromMillisecondsSinceEpoch(weatherData.dt * 1000);
    final dayOfMonth = DateFormat('d').format(date); // Get the day of the month

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(dayTime,
            style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
        Text("${dayOfMonth}th",
            style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
        const SizedBox(height: 8),
        CachedNetworkImage(
          imageUrl: iconUrl,
          width: 40,
          height: 40,
        ),
        const SizedBox(height: 8),
        Text('$temp°',
            style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
      ],
    );
  }

  String getDayTime(BuildContext context, int timestamp) {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final day =
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][date.weekday % 7];
    final time =
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    if (weatherProvider.selectedForecastRange == ForecastRange.daily) {
      return day;
    } else {
      return "$day $time";
    }
  }
}
