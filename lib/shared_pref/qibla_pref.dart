

import 'package:shared_preferences/shared_preferences.dart';

const String cQiblaPref = 'QIBLA_PREF';



setQibla(double qiblaDirection) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(cQiblaPref, qiblaDirection);
}

Future<double> getQibla() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(await isExist()){
    return prefs.getDouble(cQiblaPref);
  } else {
    setQibla(89.318409629894);
    return 89.318409629894;
  }
}

isExist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(cQiblaPref);
}