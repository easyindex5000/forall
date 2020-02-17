import 'dart:async';
import 'dart:convert';

import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

enum CarTypes { sedan, supercar, racing_car,bike,motorCycle,planes,recovery,train,metro,yatch,scooter }
enum AppState { select_car, select_pickUp, select_dis, estimate, searching }

class MapProvider extends ChangeNotifier {
  var location = Geolocator();
  GoogleMapController mapController;
  Set<Marker> markers;
  AppState state = AppState.select_car;
  bool isCash = true;
  LatLng currentPostion;
  LatLng myLocation;

  LatLng pickupPosition;
  LatLng distinationPostion;
  CarTypes selectedCar;
  String bottomText = allTranslations.text("Pickup Now");

  Set<Polyline> polyLines = {};

  Future<LatLng> getMyLocation() async {
    var poistion = await location.getCurrentPosition();
    currentPostion = LatLng(poistion.latitude, poistion.longitude);
    myLocation = LatLng(poistion.latitude, poistion.longitude);
    return currentPostion;
  }

  openDrawer(context) {
    Scaffold.of(context).openDrawer();
  }

  onCameraMove(CameraPosition cameraPosition) {
    currentPostion = cameraPosition.target;
  }

  bottomClicked() {
    if (state == AppState.select_car) {
    } else if (state == AppState.select_pickUp) {
      pickupNow();
    } else if (state == AppState.select_dis) {
      confirm();
    } else if (state == AppState.estimate) {
      state = AppState.searching;
      bottomText = allTranslations.text("Searching");
      notifyListeners();
    }
  }

  pickupNow() {
    state = AppState.select_dis;
    bottomText = allTranslations.text("Confirm");
    pickupPosition = LatLng(currentPostion.latitude, currentPostion.longitude);
    markers = [
      Marker(
        markerId: MarkerId("pickup"),
        position: pickupPosition,
      )
    ].toSet();
    notifyListeners();
  }

  confirm() {
    state = AppState.estimate;
    bottomText = allTranslations.text("Let's Go");
    distinationPostion =
        LatLng(currentPostion.latitude, currentPostion.longitude);
    markers.add(Marker(
      markerId: MarkerId("dist"),
      position: distinationPostion,
    ));
    // getRouteCoordinates();
    notifyListeners();
  }

  skip() {
    state = AppState.estimate;
    bottomText = allTranslations.text("Let's Go");
    notifyListeners();
  }

  Future<Placemark> getAddressFromLatLong(LatLng latlong) async {
    var placeMarks = (await location.placemarkFromCoordinates(
        latlong.latitude, latlong.longitude));

    return placeMarks[0];
  }

  Future<List<PlacesSearchResult>> getsuggestion(String value) async {
    const kGoogleApiKey = "AIzaSyAtptzHdrsXgZexBmrKXzHuddM9TX8ijwE";
    final places = new GoogleMapsPlaces(apiKey: kGoogleApiKey);
    PlacesSearchResponse reponse = await places.searchByText(value);
    return reponse.results;
  }

  Future<String> getRouteCoordinates() async {
    const apiKey = "AIzaSyAtptzHdrsXgZexBmrKXzHuddM9TX8ijwE";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${pickupPosition.latitude},${pickupPosition.longitude}&destination=${distinationPostion.latitude},${distinationPostion.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }

  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    String route = await getRouteCoordinates();
    createRoute(route);
    notifyListeners();
  }

  void createRoute(String encondedPoly) {
    polyLines.add(Polyline(
        polylineId: PolylineId(distinationPostion.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    notifyListeners();
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  Future<bool> onBackPressed(context) async {
    if (state == AppState.select_car) {
      return true;
    } else if (state == AppState.select_pickUp) {
      return true;
    } else if (state == AppState.select_dis) {
      bottomText = "Pickup Now";
      state = AppState.select_pickUp;
      pickupPosition = null;
      markers.removeWhere((Marker marker) {
        return marker.markerId == MarkerId("pickup");
      });
      notifyListeners();
      return false;
    } else if (state == AppState.estimate) {
      bottomText = allTranslations.text("Let's Go");

      state = AppState.select_dis;
      markers.removeWhere((Marker marker) {
        return marker.markerId == MarkerId("dist");
      });
      distinationPostion = null;
      notifyListeners();
      return false;
    } else if (state == AppState.searching) {
      bottomText = allTranslations.text("Let's Go");

      state = AppState.estimate;
      notifyListeners();
    }
  }

  getFromSearchPickUp(Location result) {
    pickupPosition = LatLng(result.lat, result.lng);
    markers.removeWhere((test) {
      return test.markerId.value == "pickup";
    });
    markers.add(Marker(markerId: MarkerId("pickup"), position: pickupPosition));
    notifyListeners();
  }

  getFromSearchDis(Location result) {
    distinationPostion = LatLng(result.lat, result.lng);
    markers.removeWhere((test) {
      return test.markerId.value == "dist";
    });
    markers
        .add(Marker(markerId: MarkerId("dist"), position: distinationPostion));
    notifyListeners();
  }
}
