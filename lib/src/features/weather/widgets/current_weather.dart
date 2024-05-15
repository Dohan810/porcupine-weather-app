import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/forecast_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/weather_icon_image.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';
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
          case WeatherState.error:
            return Center(child: Text(errorMessage ?? "Error occurred"));
          case WeatherState.loaded:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weatherData != null)
                  CurrentWeatherWidget(data: weatherData),
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
  const CurrentWeatherWidget({super.key, required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.main.temp.toInt().toString();
    final feelsLike = data.main.feelsLike.toInt().toString();
    return BlurWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          WeatherIconImage(iconUrl: data.weather[0].iconUrl, size: 100),
          Column(
            children: [
              Text(
                '$temp C',
                style: textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Feels $feelsLike C',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
      children: [
        Text(
          'Details',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        addSpace(2),
        BlurWrapper(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addSpace(2),
                Center(
                  child: Column(
                    children: [
                      Text(
                        isSunsetPassed
                            ? 'Do not miss the sunrise tomorrow'
                            : 'Do not miss the sunset',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      CustomPaint(
                        painter: SunPathPainter(isSunsetPassed),
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
                            timeFormatter
                                .format(isSunsetPassed ? nextSunrise : sunset),
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
  final bool isSunsetPassed;

  SunPathPainter(this.isSunsetPassed);

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

    if (isSunsetPassed) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Next sunrise at',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      textPainter.paint(canvas, Offset(size.width / 4, size.height / 2 - 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
