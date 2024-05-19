// static_forecast_data.dart

import 'forecast_data.dart';

const ForecastData staticForecastData = ForecastData(
  cod: "200",
  message: 0,
  cnt: 5,
  list: [
    WeatherList(
      dt: 1625247600,
      main: Main(
        temp: 20.0,
        feelsLike: 19.0,
        tempMin: 18.0,
        tempMax: 22.0,
        pressure: 1012,
        seaLevel: 1012,
        grndLevel: 1008,
        humidity: 60,
        tempKf: 0.0,
      ),
      weather: [
        Weather(
          id: 800,
          main: 'Clear',
          description: 'clear sky',
          icon: '01d',
        ),
      ],
      clouds: Clouds(all: 0),
      wind: Wind(speed: 5.0, deg: 180, gust: 10.0),
      visibility: 10000,
      pop: 0.0,
      sys: Sys(pod: 'd'),
      dtTxt: '2021-07-02 18:00:00',
      rain: null,
    ),
    // Add more WeatherList items as needed for the forecast
  ],
  city: City(
    id: 5128581,
    name: 'New York',
    coord: Coord(lat: 40.7128, lon: -74.0060),
    country: 'US',
    population: 8175133,
    timezone: -14400,
    sunrise: 1625205600,
    sunset: 1625258400,
  ),
);
