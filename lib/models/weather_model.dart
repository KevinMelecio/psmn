import 'package:pmsn20232/models/weather_current_model.dart';
import 'package:pmsn20232/models/weather_daily_model.dart';
import 'package:pmsn20232/models/weather_hourly_model.dart';

class WeatherData{
  final WeatherDataCurrent? current;
  final WeatherDataHourly? hourly;
  final WeatherDataDaily? daily;

  WeatherData([this.current, this.hourly, this.daily]);

  WeatherDataCurrent getCurrentWeather() => current!;
  WeatherDataHourly getHourlyWeather() => hourly!;
  WeatherDataDaily getDailyWeather() => daily!;
}