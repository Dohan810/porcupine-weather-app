import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_example_flutter/shared/widgets/wrappers/animation_wrapper.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
                      'Sun Rise Details',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
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
    final isSunrisePassed = currentTime.isAfter(sunrise);
    final isNightTime = isSunsetPassed || !isSunrisePassed;

    final nextSunrise =
        isSunsetPassed ? sunrise.add(const Duration(days: 1)) : sunrise;
    final timeFormatter = DateFormat('hh:mma');

    final totalDuration = sunset.difference(sunrise).inSeconds;
    final elapsedDuration = currentTime.difference(sunrise).inSeconds;
    final sunPosition = (elapsedDuration / totalDuration).clamp(0.0, 1.0);

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
                      if (isNightTime)
                        Text(
                          'Next sunrise at ${timeFormatter.format(nextSunrise)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      CustomPaint(
                        painter: SunPathPainter(
                          sunPosition: sunPosition,
                          isNightTime: isNightTime,
                        ),
                        child: const SizedBox(
                          width: 600,
                          height: 100,
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
  final double sunPosition;
  final bool isNightTime;

  SunPathPainter({
    required this.sunPosition,
    required this.isNightTime,
  });

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

    final point = _calculateQuadraticBezierPoint(
      sunPosition,
      Offset(0, size.height),
      Offset(size.width / 2, 0),
      Offset(size.width, size.height),
    );

    final sunPaint = Paint()
      ..color =
          isNightTime ? Colors.grey : const Color.fromARGB(255, 255, 115, 0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(point, 14, sunPaint);
  }

  Offset _calculateQuadraticBezierPoint(
      double t, Offset p0, Offset p1, Offset p2) {
    final x =
        (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final y =
        (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant SunPathPainter oldDelegate) {
    return oldDelegate.sunPosition != sunPosition ||
        oldDelegate.isNightTime != isNightTime;
  }
}
