import 'dart:convert';

import 'package:pmsn20232/api/api_key.dart';
import 'package:pmsn20232/models/weather_current_model.dart';
import 'package:pmsn20232/models/weather_daily_model.dart';
import 'package:pmsn20232/models/weather_hourly_model.dart';
import 'package:pmsn20232/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:pmsn20232/utils/api_url.dart';

class FetchWeatherApi{
  WeatherData? weatherData;

  //Procesando el data desde response -> json
  Future<WeatherData> processData(lat, lon) async {
    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(response.body);
    weatherData = WeatherData(WeatherDataCurrent.fromJson(jsonString),
    WeatherDataHourly.fromJson(jsonString),
    WeatherDataDaily.fromJson(jsonString));
    return weatherData!;
  }
}

