import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_data.freezed.dart';
part 'forecast_data.g.dart';

@freezed
class ForecastData with _$ForecastData {
  const factory ForecastData({
    required String cod,
    required int message,
    required int cnt,
    required List<WeatherList> list,
    required City city,
  }) = _ForecastData;

  factory ForecastData.fromJson(Map<String, dynamic> json) =>
      _$ForecastDataFromJson(json);
}

@freezed
class WeatherList with _$WeatherList {
  const factory WeatherList({
    required int dt,
    required Main main,
    required List<Weather> weather,
    required Clouds clouds,
    required Wind wind,
    required int visibility,
    required double pop,
    Rain? rain,
    required Sys sys,
    @JsonKey(name: 'dt_txt') required String dtTxt,
  }) = _WeatherList;

  factory WeatherList.fromJson(Map<String, dynamic> json) =>
      _$WeatherListFromJson(json);
}

@freezed
class Main with _$Main {
  const factory Main({
    required double temp,
    @JsonKey(name: 'feels_like') required double feelsLike,
    @JsonKey(name: 'temp_min') required double tempMin,
    @JsonKey(name: 'temp_max') required double tempMax,
    required int pressure,
    @JsonKey(name: 'sea_level') required int seaLevel,
    @JsonKey(name: 'grnd_level') required int grndLevel,
    required int humidity,
    @JsonKey(name: 'temp_kf') required double tempKf,
  }) = _Main;

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@freezed
class Weather with _$Weather {
  const Weather._(); // Added constructor for using getters

  const factory Weather({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  String get iconUrl => 'http://openweathermap.org/img/wn/$icon@2x.png';
}

@freezed
class Clouds with _$Clouds {
  const factory Clouds({
    required int all,
  }) = _Clouds;

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@freezed
class Wind with _$Wind {
  const factory Wind({
    required double speed,
    required int deg,
    required double gust,
  }) = _Wind;

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}

@freezed
class Rain with _$Rain {
  const factory Rain({
    @JsonKey(name: '3h') required double threeHour,
  }) = _Rain;

  factory Rain.fromJson(Map<String, dynamic> json) => _$RainFromJson(json);
}

@freezed
class Sys with _$Sys {
  const factory Sys({
    required String pod,
  }) = _Sys;

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    required int id,
    required String name,
    required Coord coord,
    required String country,
    required int population,
    required int timezone,
    required int sunrise,
    required int sunset,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
class Coord with _$Coord {
  const factory Coord({
    required double lat,
    required double lon,
  }) = _Coord;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}
