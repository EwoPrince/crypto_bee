import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';

final locationProvider =
    ChangeNotifierProvider<LocationProviders>((ref) => LocationProviders());

class LocationProviders extends ChangeNotifier {
  String _lat = '';
  String _long = '';

  String get lat => _lat;
  String get long => _long;

  Future<void> getCurrentLocation(String uid) async {
    // Location location = new Location();
    // bool _serviceEnabled;
    // PermissionStatus _permissionGranted;

    try {
      // _serviceEnabled = await location.serviceEnabled();
      // if (!_serviceEnabled) {
      //   _serviceEnabled = await location.requestService();
      //   if (!_serviceEnabled) {
      //     return;
      //   }
      // }

      // _permissionGranted = await location.hasPermission();
      // if (_permissionGranted == PermissionStatus.denied) {
      //   _permissionGranted = await location.requestPermission();
      //   if (_permissionGranted != PermissionStatus.granted) {
      //     return;
      //   }
      // }

      // var _locationData = await location.getLocation();
      
      print('the location data is suppose to come below');
      // print(_locationData.latitude);
      // print(_locationData.longitude);
       

      // _lat = _locationData.latitude.toString();
      // _long = _locationData.longitude.toString();
      
     

      notifyListeners();

    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
