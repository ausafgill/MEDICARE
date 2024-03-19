import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Locations {
  Future<Position> getCurrentlocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location not enabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permisssions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permissions are permanently denied');
    }
    return await Geolocator.getCurrentPosition();
  }
}

Future<void> openMap(String lat, String long) async {

  // String googleURl =
  //     'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  // final Uri url = Uri.parse(googleURl);
  // // await canLaunchUrl(Uri.parse(googleURl))
  // //     ? launchUrl(Uri.parse(googleURl))
  // //     : throw 'Couldnot launch $googleURl';
  // if (!await launchUrl(url)) {
  //   throw Exception('Could not launch $url');
  // }
}
