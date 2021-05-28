import 'package:daily_tracker/util/locationHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:daily_tracker/util/debug.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(25.087777, 121.374935);
const LatLng DEST_LOCATION = LatLng(25.080470, 121.379913);
const String API_KEY = 'AIzaSyABYQx5DjpPjDOCgBkN4Vh4YhOOcbeXpzg';

class MapPage extends StatefulWidget {
  final SharedPreferences preferences;
  LocationHistory locationHistory;

/* -------------------------------------------------------------------------- */
/*                             MapPage Constructor                            */
/* -------------------------------------------------------------------------- */
  MapPage(this.preferences) {
    locationHistory = LocationHistory.instance;
    loadLocationHistory();
  }

/* -------------------------------------------------------------------------- */
/*                            Load Location History                           */
/* -------------------------------------------------------------------------- */
  void loadLocationHistory() {
    try {
      String history = preferences.getString('LocationHistory');

      Debug.Log('Load Preference', color: DColor.green);
      Debug.Log('$history', color: DColor.yellow);

      Map<String, dynamic> locationHistoryMap = jsonDecode(history);
      locationHistory.loadFromJson(locationHistoryMap);

      Debug.Log('History loaded Successfully', color: DColor.cyan);
    } catch (e) {
      Debug.Log('There is an Error when loading history', color: DColor.red);
      print(e);
      locationHistory = LocationHistory();
    }
  }

/* -------------------------------------------------------------------------- */
/*                            Save Location History                           */
/* -------------------------------------------------------------------------- */
  void saveLocationHistory() {
    if (preferences == null) {
      print('No Preferences!');
      return;
    }
    preferences.setString('LocationHistory', jsonEncode(locationHistory.toJson()));
  }

/* -------------------------------------------------------------------------- */
/*                                Create State                                */
/* -------------------------------------------------------------------------- */
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Location location = Location();
  Set<Polyline> mapPolylines = {};

  void _onMapCreated(GoogleMapController _cntlr) {
    location.enableBackgroundMode();
    setLocationChangeListener();
  }

/* -------------------------------------------------------------------------- */
/*                            Set Location Listener                           */
/* -------------------------------------------------------------------------- */
  void setLocationChangeListener() {
    location.onLocationChanged.listen(onLocationChange);
  }

/* -------------------------------------------------------------------------- */
/*                             On Location Change                             */
/* -------------------------------------------------------------------------- */
  void onLocationChange(LocationData currentLocation) {
    LatLng newPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    LocationHistory.instance.addRecord(newPosition);
    widget.saveLocationHistory();
    createLine(); // ? Neccasary
    // _controller.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 15),
    //   ),
    // );
  }

/* -------------------------------------------------------------------------- */
/*                               Create PolyLine                              */
/* -------------------------------------------------------------------------- */
  void createLine() {
    mapPolylines.clear();
    List<LatLng> points = widget.locationHistory.getLatLngs();
    Polyline polyline = Polyline(
      polylineId: PolylineId('Main Route'),
      color: Color.fromARGB(255, 255, 67, 99),
      points: points,
      width: 5,
    );
    mapPolylines.add(polyline);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation =
        CameraPosition(zoom: CAMERA_ZOOM, bearing: CAMERA_BEARING, tilt: CAMERA_TILT, target: SOURCE_LOCATION);
    createLine();
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      polylines: mapPolylines,
      initialCameraPosition: initialLocation,
      key: Key(API_KEY),
      onMapCreated: _onMapCreated,
    );
  }
}
