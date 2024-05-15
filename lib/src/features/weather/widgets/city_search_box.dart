import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_weather_example_flutter/shared/widgets/wrappers/animation_wrapper.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';
import 'package:open_weather_example_flutter/utils/date_utils.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';
import 'package:provider/provider.dart';

class CitySearchBox extends StatefulWidget {
  const CitySearchBox({super.key});

  @override
  State<CitySearchBox> createState() => _CitySearchRowState();
}

class _CitySearchRowState extends State<CitySearchBox> {
  late final TextEditingController _searchController;
  bool _isExpanded = false;
  bool _isSearchButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<WeatherProvider>().city,
    );
    _searchController.addListener(_updateSearchButtonVisibility);
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateSearchButtonVisibility);
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchButtonVisibility() {
    setState(() {
      _isSearchButtonVisible = _searchController.text.isNotEmpty;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _submitSearch() async {
    final city = _searchController.text.trim();
    if (city.isNotEmpty) {
      try {
        context.read<WeatherProvider>().city = city;
        context.read<WeatherProvider>().getWeatherData();
        context.read<WeatherProvider>().getForecastData();
        setState(() {
          _isExpanded = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch weather data: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_isExpanded) ...[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SharedAnimatedWrapper(
                isExpanded: _isExpanded,
                duration: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.search, color: Colors.white),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: 'Enter city',
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.white),
                                    onPressed: _toggleSearch,
                                  ),
                                ),
                                onSubmitted: (_) => _submitSearch(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isSearchButtonVisible)
                      TextButton(
                        onPressed: _submitSearch,
                        child: const Text(
                          'Search',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (!_isExpanded) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                capitalize(context.read<WeatherProvider>().city),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                CustomDateUtils.formatDate(DateTime.now()),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              addSpace(2),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: _toggleSearch,
              ),
              GestureDetector(
                child: Image.asset(
                  "assets/menu.png",
                  height: 24,
                ),
                onTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ],
          ),
        ]
      ],
    );
  }
}
