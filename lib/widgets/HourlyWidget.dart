import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pmsn20232/controller/global_controller.dart';
import 'package:pmsn20232/models/weather_hourly_model.dart';
import 'package:pmsn20232/utils/custom_colors.dart';
import 'package:intl/intl.dart';

class HourlyWidget extends StatelessWidget {
  final WeatherDataHourly weatherDataHourly;
  HourlyWidget({super.key, required this.weatherDataHourly});

  RxInt cardIndex = GlobalController().getIndex();
  String date = DateFormat("yMMMMd").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.topCenter,
          child: Text(
            date,
            style: TextStyle(fontSize: 18),
          ),
        ),
        hourlyList()
      ],
    );
  }

  Widget hourlyList() {
    return Container(
      height: 130,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: weatherDataHourly.hourly.length > 12
              ? 20
              : weatherDataHourly.hourly.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                cardIndex.value = index;
              },
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
                          color: CustomColors.dividerLine.withAlpha(150)),
                    ],),
                child: HourlyDetails(
                    index: index,
                    temp: weatherDataHourly.hourly[index].temp!,
                    timeStamp: weatherDataHourly.hourly[index].dt!,
                    weatherIcon:
                        weatherDataHourly.hourly[index].weather![0].icon!),
              ),
            );
          }),
    );
  }
}

//hourly details
class HourlyDetails extends StatelessWidget {
  int temp;
  int index;
  int timeStamp;
  String weatherIcon;

  HourlyDetails({
    super.key,
    required this.temp,
    required this.timeStamp,
    required this.weatherIcon,
    required this.index,
  });

  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String x = DateFormat('jm').format(time);
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
          child: Text("$temp°",
              style: TextStyle(color: CustomColors.textColorBlack)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            getTime(timeStamp),
            style: TextStyle(color: CustomColors.textColorBlack),
          ),
        ),
      ],
    );
  }
}
