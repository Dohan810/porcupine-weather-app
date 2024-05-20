import 'package:flutter/material.dart';
import 'package:weather_wise/src/features/weather/widgets/wrappers/animation_wrapper.dart';
import 'package:weather_wise/src/features/models/weather_data/weather_data.dart';
import 'package:weather_wise/src/features/weather/application/providers.dart';
import 'package:weather_wise/src/features/weather/enums/unit_enums.dart';
import 'package:weather_wise/src/features/weather/widgets/wrappers/blur_wrapper.dart';
import 'package:weather_wise/src/features/weather/widgets/weather_icon_image.dart';
import 'package:weather_wise/src/features/weather/application/layout_provider.dart';
import 'package:weather_wise/utils/date_utils.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

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
        final state = data.$2;
        final weatherData = data.$3;

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weatherData != null)
                  AnimationWrapper(
                    curve: Curves.bounceOut,
                    child: CurrentWeatherWidget(
                      data: weatherData,
                    ),
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
      return Align(
        alignment: Alignment.bottomLeft,
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              WeatherIconImage(iconUrl: data.weather[0].iconUrl, size: 100),
              Text(
                '$temp $unitSymbol',
                style: textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 140,
                    overflow: TextOverflow.fade),
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
          ),
        ),
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
