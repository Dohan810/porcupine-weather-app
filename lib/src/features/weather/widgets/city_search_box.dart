import 'package:flutter/material.dart';
import 'package:weather_wise/src/features/weather/widgets/wrappers/animation_expanded_wrapper.dart';
import 'package:weather_wise/src/features/weather/application/providers.dart';
import 'package:weather_wise/src/features/weather/presentation/weather_page.dart';
import 'package:weather_wise/src/features/weather/application/layout_provider.dart';
import 'package:weather_wise/utils/date_utils.dart';
import 'package:weather_wise/utils/formatting_utils.dart';
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
    final deviceType = Provider.of<LayoutProvider>(context).deviceType;

    if (deviceType == DeviceType.desktop) {
      return Column(
        children: [
          Row(
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child:
                                        Icon(Icons.search, color: Colors.white),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        hintText: 'Enter city',
                                        hintStyle: const TextStyle(
                                            color: Colors.white),
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
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                        size: 36,
                      ),
                      onPressed: _toggleSearch,
                    ),
                    Consumer<WeatherProvider>(builder: (context, provider, _) {
                      final state = provider.forecastWeatherState;

                      switch (state) {
                        case WeatherState.error:
                          return const SizedBox.shrink();
                        default:
                      }
                      return GestureDetector(
                        child: Image.asset(
                          "assets/menu.png",
                          height: 24,
                        ),
                        onTap: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                      );
                    }),
                  ],
                ),
              ]
            ],
          ),
          _isExpanded ? previousSearches(context) : const SizedBox.shrink()
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child:
                                      Icon(Icons.search, color: Colors.white),
                                ),
                                Expanded(
                                  child: TextField(
                                    key: const Key("searchTextField"),
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
                    key: const Key("searchIconButton"),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: _toggleSearch,
                  ),
                  Consumer<WeatherProvider>(builder: (context, provider, _) {
                    final state = provider.forecastWeatherState;

                    switch (state) {
                      case WeatherState.error:
                        return const SizedBox.shrink();
                      default:
                    }
                    return GestureDetector(
                      child: Image.asset(
                        "assets/menu.png",
                        height: 24,
                      ),
                      onTap: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                    );
                  }),
                ],
              ),
            ]
          ],
        ),
        _isExpanded ? previousSearches(context) : const SizedBox.shrink()
      ],
    );
  }

  Column previousSearches(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Previous Searches",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: Provider.of<WeatherProvider>(context)
              .previousSearches
              .map(
                (e) => Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _searchController.text = e;
                        _submitSearch();
                      },
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                      ),
                    ),
                    addSpace(2),
                  ],
                ),
              )
              .toList(),
        ),
        addSpace(2)
      ],
    );
  }
}
