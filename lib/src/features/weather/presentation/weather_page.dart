import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/shared/widgets/dropdowns/dropdown.dart';
import 'package:open_weather_example_flutter/shared/widgets/wrappers/responsive_wrapper.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/weather_desktop.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/weather_mobile.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/weather_tablet.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/widgets/forecast_weather.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomEndDrawer(),
      body: ValueListenableBuilder<String>(
          valueListenable:
              context.read<WeatherProvider>().locationBackgroundNotifier,
          builder: (context, backgroundImagePath, _) {
            return BackgroundImageWrapper(
              backgroundImagePath: backgroundImagePath,
              child: const SafeArea(
                child: Expanded(
                  child: SharedResponsiveWrapper(
                    mobileView: FeatureWeatherMobile(),
                    tabletView: FeatureWeatherTablet(),
                    desktopView: FeatureWeatherDesktop(),
                  ),
                ),
              ),
            );
          }),
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

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          addSpace(16),
          Text(
            'Weather',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SharedDropdownWidget<Unit>(
            items: Unit.values,
            value: weatherProvider.selectedUnit,
            label: 'Unit',
            successMessage: 'Successfully updated',
            onChanged: (Unit? newValue) {
              weatherProvider.updateUnit(newValue!);
            },
          ),
          addSpace(8),
          Text(
            'Forecast',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SharedDropdownWidget<ForecastRange>(
            items: ForecastRange.values,
            value: weatherProvider.selectedForecastRange,
            label: 'Range',
            successMessage: 'Successfully updated',
            onChanged: (ForecastRange? newValue) {
              weatherProvider.updateForecastRange(newValue!);
            },
          ),
        ],
      ),
    );
  }
}
