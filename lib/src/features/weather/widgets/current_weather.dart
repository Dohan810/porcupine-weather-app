import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_example_flutter/shared/widgets/swipe/smooth_swiper.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/forecast_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/weather_icon_image.dart';
import 'package:open_weather_example_flutter/src/shared/application/layout_provider.dart';
import 'package:open_weather_example_flutter/utils/date_utils.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:ui' as ui;

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
          case WeatherState.loaded:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weatherData != null)
                  CurrentWeatherWidget(
                    data: weatherData,
                  ),
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

class CurrentSunRiseWeather extends StatelessWidget {
  const CurrentSunRiseWeather({super.key});

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
        final unit = Provider.of<WeatherProvider>(context).selectedUnit;
        final unitSymbol = getTemperatureUnitSymbol(unit);

        switch (state) {
          case WeatherState.loading:
            return const Center(child: CircularProgressIndicator());
          case WeatherState.loaded:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weatherData != null) ...[
                  Text(
                    'Sun Rise Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  addSpace(2),
                  SunPathWidget(
                    sunrise: DateTime.fromMillisecondsSinceEpoch(
                      weatherData.sys.sunrise * 1000,
                    ),
                    sunset: DateTime.fromMillisecondsSinceEpoch(
                      weatherData.sys.sunset * 1000,
                    ),
                  ),
                ]
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
        final errorMessage = data.$4;
        final unit = Provider.of<WeatherProvider>(context).selectedUnit;

        switch (state) {
          case WeatherState.loading:
            return const Center(child: CircularProgressIndicator());
          case WeatherState.loaded:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weatherData != null) ...[
                  Text(
                    'Additional Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
            );
          case WeatherState.initial:
          default:
            return Container();
        }
      },
    );
  }
}

class CurrentWeatherWidget extends StatelessWidget {
  const CurrentWeatherWidget({
    super.key,
    required this.data,
  });

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final unit = Provider.of<WeatherProvider>(context).selectedUnit;
    final unitSymbol = getTemperatureUnitSymbol(unit);
    final deviceType = Provider.of<LayoutProvider>(context).deviceType;

    final temp = data.main.temp.toInt().toString();
    final feelsLike = data.main.feelsLike.toInt().toString();

    if (deviceType == DeviceType.desktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          WeatherIconImage(iconUrl: data.weather[0].iconUrl, size: 100),
          Text(
            '$temp $unitSymbol',
            style: textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Provider.of<WeatherProvider>(context).city.toUpperCase(),
                style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                CustomDateUtils.formatDate(DateTime.now()),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ],
      );
    }

    if (deviceType == DeviceType.tablet) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '$temp $unitSymbol',
            style: textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 32),
          Row(
            children: [
              WeatherIconImage(iconUrl: data.weather[0].iconUrl, size: 100),
              Column(
                children: [
                  Text(
                    Provider.of<WeatherProvider>(context).city.toUpperCase(),
                    style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    CustomDateUtils.formatDate(DateTime.now()),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    return BlurWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          WeatherIconImage(iconUrl: data.weather[0].iconUrl, size: 100),
          Column(
            crossAxisAlignment: deviceType == DeviceType.mobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                '$temp $unitSymbol',
                style: _getTextStyle(textTheme, deviceType, true),
              ),
              Text(
                'Feels like $feelsLike $unitSymbol',
                style: _getTextStyle(textTheme, deviceType, false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle? _getTextStyle(
      TextTheme textTheme, DeviceType deviceType, bool isTemp) {
    switch (deviceType) {
      case DeviceType.desktop:
        return textTheme.displayMedium?.copyWith(
          color: Colors.white,
          fontWeight: isTemp ? FontWeight.bold : FontWeight.normal,
        );
      case DeviceType.tablet:
        return textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: isTemp ? FontWeight.bold : FontWeight.normal,
        );
      case DeviceType.mobile:
      default:
        return textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: isTemp ? FontWeight.bold : FontWeight.normal,
        );
    }
  }
}

class SunPathWidget extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunPathWidget({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final isSunsetPassed = currentTime.isAfter(sunset);

    final nextSunrise =
        isSunsetPassed ? sunrise.add(const Duration(days: 1)) : sunrise;
    final timeFormatter = DateFormat('hh:mma');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlurWrapper(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      if (isSunsetPassed)
                        Text(
                          'Next sunrise at ${timeFormatter.format(nextSunrise)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      CustomPaint(
                        painter: SunPathPainter(),
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: Stack(
                            children: [
                              if (!isSunsetPassed)
                                const Positioned(
                                  top: 20,
                                  left: 140,
                                  child: Icon(
                                    Icons.wb_sunny,
                                    color: Colors.orange,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeFormatter.format(sunrise),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            timeFormatter.format(sunset),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SunPathPainter extends CustomPainter {
  SunPathPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(
        size.width / 2,
        0,
        size.width,
        size.height,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
