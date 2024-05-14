import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/models/forecast_data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:provider/provider.dart';

class ForecastWeather extends StatelessWidget {
  const ForecastWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        final state = provider.forecastWeatherState;
        final forecastData = provider.hourlyWeatherProvider;
        final errorMessage = provider.errorMessage;

        switch (state) {
          case WeatherState.loading:
            return const Center(child: CircularProgressIndicator());
          case WeatherState.error:
            return Center(child: Text(errorMessage ?? "Error occurred"));
          case WeatherState.loaded:
            if (forecastData == null) {
              return const Center(child: Text("No forecast data available"));
            }
            final List<WeatherList> forecastList = forecastData.list;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: forecastList.map((data) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DailyWeather(weatherData: data),
                  );
                }).toList(),
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

    final day = getDay(weatherData.dt);
    final temp = weatherData.main.temp.toInt().toString();
    final iconUrl = weatherData.weather[0].iconUrl;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(day, style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
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

  String getDay(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][date.weekday % 7];
  }
}
