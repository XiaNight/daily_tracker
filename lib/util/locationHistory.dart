import 'package:daily_tracker/util/debug.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

class LocationHistory {
  static LocationHistory instance;

  List<LocationInformation> locations;

  LocationHistory() {
    instance = this;
    Debug.Log('LocationHistory instance set!', color: DColor.green);
  }

  void clear() {
    locations = [];
  }

/* -------------------------------------------------------------------------- */
/*                           Load History From JSON                           */
/* -------------------------------------------------------------------------- */
  loadFromJson(Map<String, dynamic> json) {
    clear();
    for (dynamic location in json['locations']) {
      LocationInformation information =
          LocationInformation(LatLng(location['latlng'][0], location['latlng'][1]), location['timestamp']);
      locations.add(information);
    }
    Debug.Log('Loaded ${locations.length} records', color: DColor.orange);
    compressLocation();
  }

/* -------------------------------------------------------------------------- */
/*                           Convert History to JSON                          */
/* -------------------------------------------------------------------------- */
  Map<String, dynamic> toJson() {
    compressLocation();
    List<Map> convertedLocations = this.locations.map((i) => i.toJson()).toList();
    return {
      'locations': convertedLocations,
    };
  }

/* -------------------------------------------------------------------------- */
/*                 Convert LocationInformations to LatLng List                */
/* -------------------------------------------------------------------------- */
  List<LatLng> getLatLngs() {
    List<LatLng> output = [];
    for (LocationInformation location in locations) {
      output.add(location.latlng);
    }
    return output;
  }

/* -------------------------------------------------------------------------- */
/*                      Compress Locations to reduce size                     */
/* -------------------------------------------------------------------------- */
  void compressLocation() {
    for (int i = locations.length - 1; i > 0; i--) {
      double distance = calculateDistance(locations[i].latlng, locations[i - 1].latlng);
      Debug.Log('Distance: $distance', color: DColor.magenta);
      if (distance < 0.001) {
        locations.removeAt(i);
      }
    }
  }

  void addRecord(LatLng location) {
    if (locations.length == 0 || calculateDistance(locations[locations.length - 1].latlng, location) > 0.01) {
      locations.add(LocationInformation(location, DateTime.now().millisecondsSinceEpoch));
    }
  }

/* -------------------------------------------------------------------------- */
/*                             Calculate Distance                             */
/* -------------------------------------------------------------------------- */
  double calculateDistance(LatLng point1, LatLng point2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((point2.latitude - point1.latitude) * p) / 2 +
        c(point1.latitude * p) * c(point2.latitude * p) * (1 - c((point2.longitude - point1.longitude) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

class LocationInformation {
  final LatLng latlng;
  final int timestamp;
  LocationInformation(this.latlng, this.timestamp);

  LocationInformation.fromJson(Map<String, dynamic> json)
      : latlng = json['latlng'],
        timestamp = json['timestamp'] {
    Debug.Log('$json', color: DColor.magenta);
  }

  Map<String, dynamic> toJson() {
    return {'latlng': latlng, 'timestamp': timestamp};
  }
}
