import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  late LatLng selectedCity = LatLng(0.0, 0.0);

  Set<Marker> markers = {};

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.52353, -100.8157),
    zoom: 17,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  MapType _currentMapType = MapType.normal;

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
        // initialCameraPosition: CameraPosition(
        //   target: LatLng(0.0, 0.0),
        //   zoom: 2.0,
        // ),
        onTap: _onMapTapped,
        markers: markers,
        mapType: _currentMapType,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTapped(LatLng location) async {
    String cityName = "";
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (placemarks.isNotEmpty) {
      cityName = placemarks[0].locality ?? 'Desconocido';
      print('Nombre de la ciudad : $cityName');
    }
    setState(() {
      selectedCity = location;
      markers = Set.from([
        Marker(
          markerId: MarkerId(selectedCity.toString()),
          position: selectedCity,
          infoWindow: InfoWindow(
            title: cityName,
            snippet:
                'Lat: ${selectedCity.latitude}, Lng: ${selectedCity.longitude}',
          ),
        ),
      ]);
    });
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GoogleMap(
  //       mapType: MapType.hybrid,
  //       initialCameraPosition: _kGooglePlex,
  //       onMapCreated: (GoogleMapController controller) {
  //         _controller.complete(controller);
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton.extended(
  //       onPressed: _goToTheLake,
  //       label: const Text('To the lake!'),
  //       icon: const Icon(Icons.directions_boat),
  //     ),
  //   );
  // }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
