import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pmsn20232/controller/global_controller.dart';
import 'package:pmsn20232/widgets/CurrentWeatherWidget.dart';
import 'package:pmsn20232/widgets/DailyWidget.dart';
import 'package:pmsn20232/widgets/HeaderWidget.dart';
import 'package:pmsn20232/widgets/HourlyWidget.dart';

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: HeaderWidget(),
        ),
        body: SafeArea(
          child: Obx(() => globalController.checkLoading().isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: ListView(scrollDirection: Axis.vertical, children: [
                    const SizedBox(
                      height: 5,
                    ),
                    // const HeaderWidget(),
                    //for our current temp
                    CurrentWeatherWidget(
                      weatherDataCurrent:
                          globalController.getData().getCurrentWeather(),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: SizedBox(
                        height: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 2,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    HourlyWidget(
                      weatherDataHourly:
                          globalController.getData().getHourlyWeather(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: SizedBox(
                        height: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 2,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    DailyWidget(
                      weatherDataDaily:
                          globalController.getData().getDailyWeather(),
                    )
                  ]),
                )),
        ));
  }
}
