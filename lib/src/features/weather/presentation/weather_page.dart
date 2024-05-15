import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/shared/widgets/wrappers/responsive_wrapper.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/weather_desktop.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/weather_mobile.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/weather_tablet.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/forecast_weather.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundImageWrapper(
        backgroundImagePath: "assets/cloudy1.png",
        child: SafeArea(
          child: Expanded(
            child: SharedResponsiveWrapper(
              mobileView: FeatureWeatherMobile(),
              tabletView: FeatureWeatherTablet(),
              desktopView: FeatureWeatherDesktop(),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundImageWrapper extends StatelessWidget {
  final Widget child;
  final String backgroundImagePath;

  const BackgroundImageWrapper({
    super.key,
    required this.child,
    required this.backgroundImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          backgroundImagePath,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        child,
      ],
    );
  }
}

class BlurWrapper extends StatelessWidget {
  final Widget child;

  const BlurWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
