import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:provider/provider.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});

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
        final city = data.$1;
        final state = data.$2;
        final weatherData = data.$3;
        final errorMessage = data.$4;

        switch (state) {
          case WeatherState.loading:
            return const Center(child: CircularProgressIndicator());
          case WeatherState.error:
            return Center(child: Text(errorMessage ?? "Error occurred"));
          case WeatherState.loaded:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(city, style: Theme.of(context).textTheme.headlineMedium),
                if (weatherData != null)
                  CurrentWeatherContents(data: weatherData),
              ],
            );
          case WeatherState.initial:
          default:
            return Container();
        }
      },
    );
  }
}

class CurrentWeatherContents extends StatelessWidget {
  const CurrentWeatherContents({super.key, required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.main.temp.toInt().toString();
    final minTemp = data.main.tempMin.toInt().toString();
    final maxTemp = data.main.tempMax.toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: data.weather[0].iconUrl, size: 120),
        Text(temp, style: textTheme.displayMedium),
        Text(highAndLow, style: textTheme.bodyMedium),
      ],
    );
  }
}
