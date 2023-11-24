import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pmsn20232/models/weather_daily_model.dart';
import 'package:pmsn20232/utils/custom_colors.dart';
import 'package:intl/intl.dart';

class DailyWidget extends StatelessWidget {
  final WeatherDataDaily weatherDataDaily;
  const DailyWidget({super.key, required this.weatherDataDaily});

  //string manipulation
  String getDay(final day) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    final x = DateFormat('EEE').format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.topCenter,
          child: Text(
            "Week",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          height: 130,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weatherDataDaily.daily.length > 7
                  ? 7
                  : weatherDataDaily.daily.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    width: 65,
                    margin: const EdgeInsets.only(left: 20, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0.5, 0),
                          blurRadius: 60,
                          spreadRadius: 1,
                          color: CustomColors.dividerLine.withAlpha(150),
                        )
                      ],
                    ),
                    child: DailyDetails(
                        day: weatherDataDaily.daily[index].dt!,
                        temp1: weatherDataDaily.daily[index].temp!.max!,
                        temp2: weatherDataDaily.daily[index].temp!.min!,
                        weatherIcon:
                            weatherDataDaily.daily[index].weather![0].icon!),
                  ),
                );
              }),
        ),
      ],
    );
    // return Container(
    //   height: 400,
    //   margin: const EdgeInsets.all(20),
    //   padding: const EdgeInsets.all(15),
    //   decoration: BoxDecoration(
    //       color: CustomColors.dividerLine.withAlpha(150),
    //       borderRadius: BorderRadius.circular(20)),
    //   child: Column(
    //     children: [
    //       Container(
    //         alignment: Alignment.topLeft,
    //         margin: const EdgeInsets.only(bottom: 10),
    //         child: const Text(
    //           "Next Days",
    //           style:
    //               TextStyle(color: CustomColors.textColorBlack, fontSize: 17),
    //         ),
    //       ),
    //       dailyList(),
    //     ],
    //   ),
    // );
  }

  Widget dailyList() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: weatherDataDaily.daily.length > 7
            ? 7
            : weatherDataDaily.daily.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                  height: 60,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          getDay(weatherDataDaily.daily[index].dt),
                          style: const TextStyle(
                              color: CustomColors.textColorBlack, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          "assets/weather/${weatherDataDaily.daily[index].weather![0].icon}.png",
                        ),
                      ),
                      Text(
                          "${weatherDataDaily.daily[index].temp!.max}°/${weatherDataDaily.daily[index].temp!.min}"),
                    ],
                  )),
              Container(
                height: 1,
                color: CustomColors.dividerLine,
              )
            ],
          );
        },
      ),
    );
  }
}

class DailyDetails extends StatelessWidget {
  int day;
  int temp1;
  int temp2;
  String weatherIcon;

  DailyDetails(
      {super.key,
      required this.day,
      required this.temp1,
      required this.temp2,
      required this.weatherIcon});

  String getDay(final day) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    final x = DateFormat('EEE').format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          child: Image.asset(
            "assets/weather/$weatherIcon.png",
            height: 40,
            width: 40,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Text(
            "$temp1°/$temp2°",
            style: TextStyle(color: CustomColors.textColorBlack),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            getDay(day),
            style: TextStyle(color: CustomColors.textColorBlack),
          ),
        )
      ],
    );
  }
}
