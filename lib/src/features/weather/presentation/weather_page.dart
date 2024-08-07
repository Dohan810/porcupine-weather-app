import 'package:flutter/material.dart';
import 'package:weather_wise/src/features/weather/widgets/buttons/link_button.dart';
import 'package:weather_wise/src/features/weather/widgets/dropdowns/dropdown.dart';
import 'package:weather_wise/src/features/weather/widgets/wrappers/responsive_wrapper.dart';
import 'package:weather_wise/src/features/weather/application/providers.dart';
import 'package:weather_wise/src/features/weather/enums/forecast_enum.dart';
import 'package:weather_wise/src/features/weather/enums/unit_enums.dart';
import 'package:weather_wise/src/features/weather/presentation/views/weather_desktop.dart';
import 'package:weather_wise/src/features/weather/presentation/views/weather_mobile.dart';
import 'package:weather_wise/src/features/weather/presentation/views/weather_tablet.dart';
import 'package:weather_wise/utils/formatting_utils.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomEndDrawer(),
      body: ValueListenableBuilder<String>(
          valueListenable: weatherProvider.locationBackgroundNotifier,
          builder: (context, backgroundImagePath, _) {
            return BackgroundImageWrapper(
              backgroundImagePath: backgroundImagePath,
              child: const SafeArea(
                child: SharedResponsiveWrapper(
                  mobileView: FeatureWeatherMobile(),
                  tabletView: FeatureWeatherTablet(),
                  desktopView: FeatureWeatherDesktop(),
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
            displayValue: (p0) => getUnitName(p0),
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
            displayValue: (p0) => getForecastRangeName(p0),
            onChanged: (ForecastRange? newValue) {
              weatherProvider.updateForecastRange(newValue!);
            },
          ),
          addSpace(8),
          LinkTextButton(
            text: "Read more about '${weatherProvider.city}' weather",
            townName: weatherProvider.city,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
