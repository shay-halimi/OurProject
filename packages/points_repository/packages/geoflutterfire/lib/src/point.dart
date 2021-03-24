import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'util.dart';

class GeoFirePoint {
  GeoFirePoint(this.latitude, this.longitude);

  static final Util _util = Util();

  double latitude, longitude;

  /// return geographical distance between two Co-ordinates
  static double distanceBetween(
      {@required Coordinates to, @required Coordinates from}) {
    return Util.distance(to, from);
  }

  /// return neighboring geo-hashes of [hash]
  static List<String> neighborsOf({@required String hash}) {
    return _util.neighbors(hash);
  }

  /// return hash of [GeoFirePoint]
  String get hash {
    return _util.encode(latitude, longitude, 9);
  }

  /// return all neighbors of [GeoFirePoint]
  List<String> get neighbors {
    return _util.neighbors(hash);
  }

  /// return [GeoPoint] of [GeoFirePoint]
  GeoPoint get geoPoint {
    return GeoPoint(latitude, longitude);
  }

  Coordinates get coordinates {
    return Coordinates(latitude, longitude);
  }

  /// return distance between [GeoFirePoint] and ([lat], [lng])
  double distance({@required double lat, @required double lng}) {
    return distanceBetween(from: coordinates, to: Coordinates(lat, lng));
  }

  Map<String, Object> get data {
    return {'geopoint': geoPoint, 'geohash': hash};
  }

  /// haversine distance between [GeoFirePoint] and ([lat], [lng])
  double haversineDistance({@required double lat, @required double lng}) {
    return GeoFirePoint.distanceBetween(
        from: coordinates, to: Coordinates(lat, lng));
  }
}

class Coordinates {
  Coordinates(this.latitude, this.longitude);

  double latitude, longitude;
}
