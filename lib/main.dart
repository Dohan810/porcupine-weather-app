import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';
import 'package:open_weather_example_flutter/shared/application/layout_provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  setupInjection();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LayoutProvider()),
        ChangeNotifierProvider<WeatherProvider>(
            create: (_) => WeatherProvider()..getWeatherData(), lazy: false),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      navigatorKey: navigatorKey,
      title: 'WeatherWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: AppColors.getTextTheme(context),
      ),
      home: const WeatherPage(city: 'London'),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}
