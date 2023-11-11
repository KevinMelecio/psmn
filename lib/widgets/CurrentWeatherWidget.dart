import 'package:flutter/material.dart';
import 'package:pmsn20232/controller/global_controller.dart';
import 'package:pmsn20232/models/weather_current_model.dart';
import 'package:pmsn20232/utils/custom_colors.dart';
import 'package:pmsn20232/widgets/HourlyWidget.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherDataCurrent weatherDataCurrent;
  CurrentWeatherWidget({super.key, required this.weatherDataCurrent});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        temperatureAreaWidget(),
        SizedBox(
          width: 30,
        ),
        currentWeatherMoreDetailsWidget(),
      ],
    );
    // return Column(
    //   children: [
    //     // //temperature area
    //     temperatureAreaWidget(),
    //     const SizedBox(height: 20),
    //     // //more details - winspeed, humidity, clouds
    //     currentWeatherMoreDetailsWidget(),
    //   ],
    // );
  }

  Widget currentWeatherMoreDetailsWidget() {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomColors.cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset("assets/icons/windspeed.png"),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomColors.cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset("assets/icons/clouds.png"),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomColors.cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset("assets/icons/humidity.png"),
            )
          ],
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 12,
              width: 60,
              child: Text(
                "WindSpeed",
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                "${weatherDataCurrent.current.windSpeed}km/h",
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 12,
              width: 60,
              child: Text(
                "Clouds",
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                "${weatherDataCurrent.current.clouds}%",
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 12,
              width: 60,
              child: Text(
                "Humidity",
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                "${weatherDataCurrent.current.humidity}%",
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
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
