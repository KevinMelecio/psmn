import 'package:flutter/material.dart';
import 'package:pmsn20232/models/weather_current_model.dart';
import 'package:pmsn20232/utils/custom_colors.dart';

class MapCurrentWeather extends StatelessWidget {
  final WeatherDataCurrent weatherDataCurrent;
  MapCurrentWeather({super.key,required this.weatherDataCurrent, });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        temperatureAreaWidget(),
      ],
    );
  }

  Widget temperatureAreaWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          "assets/weather/${weatherDataCurrent.current.weather![0].icon}.png",
          height: 120,
          width: 120,
        ),
        // Container(
        //   height: 50,
        //   width: 1,
        //   color: CustomColors.dividerLine,
        // ),
        Text("${weatherDataCurrent.current.temp!.toInt()}°",
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 68,
                color: CustomColors.textColorBlack)),
        Text("${weatherDataCurrent.current.weather![0].description}",
            style: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey)),
      ],
    );
  }


}