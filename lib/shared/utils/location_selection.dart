import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:medicare/features/user_information/screens/map_display_widget.dart';
import 'package:medicare/features/user_information/services/location_service.dart';

Future getCurrentLocationAndShowMap(BuildContext context) async {
  double lat = 0, long = 0;
  await Locations().getCurrentlocation().then((value) {
    lat = value.latitude;
    long = value.longitude;
  });
  GeoPoint point = GeoPoint(latitude: lat, longitude: long);
  var point2;
  if (context.mounted) {
    point2 = await Navigator.pushNamed(context, MapDisplayWidget.routeName,
        arguments: [lat, long]);
  }
  if (point2 == null) {
    return point;
  } else {
    return point2;
  }
}
