
import 'dart:async';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMy{
  /// class variable
  var lknown;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = [];

  /// create the location on the map
  onMap(double latitude,double long,double newlat,double newlong){
    getLocation().then((value) async{

      _markers.add(
        Marker(
            markerId: MarkerId('1'),
            position: LatLng(latitude, long),
            infoWindow: InfoWindow(
                title: 'starting location'
            )
        ),
      );
      _markers.add(
        Marker(
            markerId: MarkerId('2'),
            position: LatLng(newlat, newlong),
            infoWindow: InfoWindow(
                title: 'current location'
            )
        ),
      );
      CameraPosition cameraposition = CameraPosition(
          zoom: 14,
          target: LatLng(newlat, newlong));

      final GoogleMapController controller  = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraposition));
   //   setState(() {

  //    });
    });
  }

  /// Check for the permission
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    Position currentposition = await Geolocator.getCurrentPosition();
    return currentposition;
  }

  /// getting the address on the basis of lat and long
  Future<String> getAddress(double latitude, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, long);
    String address = "${placemarks[0].street!} ${placemarks[0].name!} ${placemarks[0].subLocality!} ${placemarks[0].locality!} "
        " ${placemarks[0].postalCode!}"
        " ${placemarks[0].subAdministrativeArea}"
        " ${placemarks[0].administrativeArea} "
        " ${placemarks[0].thoroughfare} "
        " ${placemarks[0].subThoroughfare } "
        " ${placemarks[0].country!}  ";
    print(address);
 //   setState(() {
 //   });
    return (address);
  }

  /// get the last known position
  Future<Position> getLKnown() async {
    Position? position = await Geolocator.getLastKnownPosition();
    lknown = position ;
    print(lknown);
    return lknown;
  }

  /// getting the distance between two points inmeters
  Future<double> getDistance(double lat1,double long1, double lat2,double long2) async {
    double distanceInMeters = Geolocator.distanceBetween(lat2, long2, 52.3546274, 4.8285838);
    double distance = distanceInMeters;
    print("distance in meters : $distanceInMeters");
    return distanceInMeters;
  }

  /// Getting the current location
  Future<Position> getLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) {
      print('error');
    });
    return await Geolocator.getCurrentPosition();
  }


}