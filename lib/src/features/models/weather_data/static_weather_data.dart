import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';

const WeatherData staticWeatherData = WeatherData(
  coord: Coord(lon: 10.0, lat: 25.0),
  weather: [
    Weather(id: 800, main: 'Clear', description: 'clear sky', icon: '01d'),
  ],
  base: 'stations',
  main: Main(
    temp: 25.0,
    feelsLike: 19.0,
    tempMin: 18.0,
    tempMax: 22.0,
    pressure: 1012,
    humidity: 60,
  ),
  visibility: 10000,
  wind: Wind(speed: 5.0, deg: 180),
  clouds: Clouds(all: 0),
  dt: 1625247600,
  sys: Sys(
    type: 1,
    id: 1,
    country: 'US',
    sunrise: 1625205600,
    sunset: 1625258400,
  ),
  timezone: -14400,
  id: 5128581,
  name: 'Cape Town',
  cod: 200,
);
