import 'package:shared_preferences/shared_preferences.dart';

const String cLatitude = 'LATITUDE_PREF';
const String cLongitude = 'LONGITUDE_PREF';

setLatitude(double latitude) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(cLatitude, latitude);
}

setLongitude(double longitude) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(cLongitude, longitude);
}

Future<double> getLatitude() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(cLatitude);
}

Future<double> getLongitude() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(cLongitude);
}

