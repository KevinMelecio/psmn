import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pmsn20232/controller/global_controller.dart';
import 'package:pmsn20232/models/weather_current_model.dart';
import 'package:pmsn20232/widgets/MapCurrentWeather.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  late LatLng selectedCity = LatLng(0.0, 0.0);

  Set<Marker> markers = {};
  // List<Marker> _marker = [];
  // List<Marker> _list = const [
  //   Marker(markerId: MarkerId('1'),
  //   position: LatLng(20.5214445316487007, -100.84057319909334),
  //   infoWindow: InfoWindow(
  //     title: 'My Position'
  //   )),
  //   Marker(markerId: MarkerId('2'),
  //   position: LatLng(20.5908273, -100.4074538),
  //   infoWindow: InfoWindow(
  //     title: 'Santiago de Queretaro'
  //   )),
  //   Marker(markerId: MarkerId('3'),
  //   position: LatLng(25.6489844, -100.4741527),
  //   infoWindow: InfoWindow(
  //     title: 'Santiago de Queretaro'
  //   ))
  // ];

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5214445316487007, -100.84057319909334),
    zoom: 9,
  );

  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Flutter'),
        actions: [
          PopupMenuButton<MapType>(
            onSelected: (MapType value) {
              setState(() {
                _currentMapType = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MapType>>[
              const PopupMenuItem<MapType>(
                value: MapType.normal,
                child: Text('Normal'),
              ),
              const PopupMenuItem<MapType>(
                value: MapType.terrain,
                child: Text('Terreno'),
              ),
              const PopupMenuItem<MapType>(
                value: MapType.satellite,
                child: Text('Satelital'),
              ),
              const PopupMenuItem<MapType>(
                value: MapType.hybrid,
                child: Text('Hibrida'),
              ),
            ],
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _kGooglePlex,
        onTap: _onMapTapped,
        markers: markers,
        // markers: Set<Marker>.of(_marker),
//para mostrar los marcadores guarados de la base de datos
        mapType: _currentMapType,
        myLocationEnabled: true,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTapped(LatLng location) async {
    final GlobalController globalController =
        Get.put(GlobalController(), permanent: true);

    WeatherDataCurrent weatherDataCurrent =
        globalController.getData().getCurrentWeather();

    String cityName = "";
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (placemarks.isNotEmpty) {
      cityName = placemarks[0].locality ?? 'Desconocido';
      print('Nombre de la ciudad : $cityName');

      _showWeatherDialog(cityName, weatherDataCurrent, );
      // MapCurrentWeather(weatherDataCurrent:
      //                         globalController.getData().getCurrentWeather(),);
    }
    setState(() {
      selectedCity = location;
      markers = Set.from([
        Marker(
          markerId: MarkerId(selectedCity.toString()),
          position: selectedCity,
          infoWindow: InfoWindow(
              title: cityName,
              snippet: 'Temperatura: ${weatherDataCurrent.current.temp}°C'
              // 'Lat: ${selectedCity.latitude}, Lng: ${selectedCity.longitude}',
              ),
        ),
      ]);
    });
  }

  void _showWeatherDialog( 
      String cityName, WeatherDataCurrent weatherDataCurrent) {
        TextEditingController txtNameController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text("Clima en $cityName")),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/weather/${weatherDataCurrent.current.weather![0].icon}.png",
                    height: 50,
                    width: 50,
                  ),
                  Text('Temperatura: ${weatherDataCurrent.current.temp}°C'),
                  Text('Humidity: ${weatherDataCurrent.current.humidity}%'),
                  Text('Clouds: ${weatherDataCurrent.current.clouds}%'),
                  Text('WindSpeed: ${weatherDataCurrent.current.windSpeed}km/s'),
                  TextField(
                    controller: txtNameController,
                    decoration: InputDecoration(labelText: 'Agrega algun nombre'),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(onPressed: (){
                String usertxt = txtNameController.text;
                if(usertxt.isNotEmpty){
                  print('Nombre de la ciudad $cityName');
                  print('Nombre dado de $usertxt');
                }
              }, child: Text('Imprimir informacion adicional'))
            ],
            
          );
        });
  }

  Widget _infoWindowFunc(Marker marker) {
    return Container();
  }
}
