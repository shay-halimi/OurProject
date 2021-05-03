import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'models/DistanceDocSnapshot.dart';
import 'point.dart';
import 'util.dart';

class GeoFireCollectionRef {
  GeoFireCollectionRef(this._collectionReference)
      : assert(_collectionReference != null) {
    _stream = _createStream(_collectionReference).shareReplay(maxSize: 1);
  }

  final CollectionReference _collectionReference;
  Stream<QuerySnapshot> _stream;

  /// return QuerySnapshot stream
  Stream<QuerySnapshot> snapshot() {
    return _stream;
  }

  /// return the Document mapped to the [id]
  Stream<List<DocumentSnapshot>> data(String id) {
    return _stream.map((QuerySnapshot querySnapshot) {
      querySnapshot.docs.where((DocumentSnapshot documentSnapshot) {
        return documentSnapshot.id == id;
      });
      return querySnapshot.docs;
    });
  }

  /// add a document to collection with [data]
  Future<DocumentReference> add(Map<String, dynamic> data) {
    try {
      return _collectionReference.add(data);
    } catch (e) {
      throw Exception(
          'cannot call add on Query, use collection reference instead');
    }
  }

  /// delete document with [id] from the collection
  Future<void> delete(String id) {
    try {
      return _collectionReference.doc(id).delete();
    } catch (e) {
      throw Exception(
          'cannot call delete on Query, use collection reference instead');
    }
  }

  /// create or update a document with [id],
  /// [merge] defines whether the document should overwrite
  Future<void> setDoc(String id, Map<String, dynamic> data,
      {bool merge = false}) {
    try {
      return _collectionReference.doc(id).set(data, SetOptions(merge: merge));
    } catch (e) {
      throw Exception(
          'cannot call set on Query, use collection reference instead');
    }
  }

  /// set a geo point with [latitude] and [longitude]
  /// using [field] as the object key to the document with [id]
  Future<void> setPoint(
      String id, String field, double latitude, double longitude) {
    try {
      final point = GeoFirePoint(latitude, longitude).data;
      return _collectionReference.doc(id).set(
          {'$field': point} as Map<String, String>, SetOptions(merge: true));
    } catch (e) {
      throw Exception(
          'cannot call set on Query, use collection reference instead');
    }
  }

  /// query firestore documents based on geographic [radius]
  /// from geoFirePoint [center]
  /// [field] specifies the name of the key in the document
  Stream<List<DocumentSnapshot>> within({
    @required GeoFirePoint center,
    @required double radius,
    @required String field,
    bool strictMode = false,
  }) {
    final precision = Util.setPrecision(radius);
    final centerHash = center.hash.substring(0, precision);
    final area = GeoFirePoint.neighborsOf(hash: centerHash)..add(centerHash);

    final queries = area.map((hash) {
      final tempQuery = _queryPoint(hash, field);
      return _createStream(tempQuery).map((QuerySnapshot querySnapshot) {
        return querySnapshot.docs
            .map((element) => DistanceDocSnapshot(element, null))
            .toList();
      });
    });

    final mergedObservable = mergeObservable(queries);

    var filtered = mergedObservable.map((List<DistanceDocSnapshot> list) {
      var mappedList = list.map((DistanceDocSnapshot distanceDocSnapshot) {
        final fieldList = field.split('.');
        var geoPointField = distanceDocSnapshot.documentSnapshot
            .data()[fieldList[0]] as Map<String, dynamic>;
        if (fieldList.length > 1) {
          for (var i = 1; i < fieldList.length; i++) {
            geoPointField = geoPointField[fieldList[i]] as Map<String, dynamic>;
          }
        }
        final geoPoint = geoPointField['geopoint'] as GeoPoint;
        distanceDocSnapshot.distance =
            center.distance(lat: geoPoint.latitude, lng: geoPoint.longitude);
        return distanceDocSnapshot;
      });

      final filteredList = strictMode
          ? mappedList
              .where((DistanceDocSnapshot doc) =>
                      doc.distance <=
                      radius * 1.02 // buffer for edge distances;
                  )
              .toList()
          : mappedList.toList()
        ..sort((a, b) {
          return ((a.distance * 1000) - (b.distance * 1000)).toInt();
        });

      return filteredList.map((element) => element.documentSnapshot).toList();
    });
    return filtered.asBroadcastStream();
  }

  Stream<List<DistanceDocSnapshot>> mergeObservable(
      Iterable<Stream<List<DistanceDocSnapshot>>> queries) {
    final mergedObservable = Rx.combineLatest(queries,
        (List<List<DistanceDocSnapshot>> originalList) {
      final reducedList = <DistanceDocSnapshot>[];
      originalList.forEach(reducedList.addAll);
      return reducedList;
    });
    return mergedObservable;
  }

  /// INTERNAL FUNCTIONS

  /// construct a query for the [geoHash] and [field]
  Query _queryPoint(String geoHash, String field) {
    final end = '$geoHash~';
    final temp = _collectionReference;
    return temp
        .orderBy('$field.geohash')
        .startAt(<String>[geoHash]).endAt(<String>[end]);
  }

  /// create an observable for [ref],
  /// [ref] can be [Query] or [CollectionReference]
  Stream<QuerySnapshot> _createStream(Query ref) {
    return ref.snapshots();
  }
}
