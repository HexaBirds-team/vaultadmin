import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class LocationController extends ChangeNotifier {
  dynamic _userLocation;
  dynamic get getUserLocation => _userLocation;

  double _lat = 29.1561728;
  double get latitude => _lat;

  double _lng = 75.6854986;
  double get longitude => _lng;

  /* Location controller */
  double _formLong = 0.0;
  double _formLat = 0.0;
  dynamic _placemarks;
  double get getFormLongitude => _formLong;
  double get getFormLatitude => _formLat;
  dynamic get getFormAddress => _placemarks;

  setFormLatLong(double lat, double long) {
    _formLong = long;
    _formLat = lat;
    notifyListeners();
  }

  setOrgFormAddress(Placemark value) {
    _placemarks = value;
    notifyListeners();
  }

  resetFormCreds() {
    _formLat = 0.0;
    _formLong = 0.0;
    _placemarks = null;
    notifyListeners();
  }

  Future<String> determinePosition() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {}
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {}
    }
    locationData = await location.getLocation();

    final locations = await placemarkFromCoordinates(
        locationData.latitude!, locationData.longitude!);
    if (locations.isNotEmpty) {
      _userLocation = locations.first;
      _lat = locationData.latitude!;
      _lng = locationData.longitude!;
      notifyListeners();
      return _userLocation.locality.toString();
    } else {
      return "";
    }
  }

  setLatLng(lat, lng) {
    _lat = lat;
    _lng = lng;
    notifyListeners();
  }

  setplacemark(placemark) {
    _userLocation = placemark;
    notifyListeners();
  }
}
