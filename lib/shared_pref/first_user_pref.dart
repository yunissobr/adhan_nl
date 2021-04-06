import 'package:shared_preferences/shared_preferences.dart';

const String cFirstUsePref = 'FIRST_USE_PREF';

// FU : First Use

setFU(bool fu) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(cFirstUsePref, fu);
}

Future<bool> getFU() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(await isExist()){
    return prefs.getBool(cFirstUsePref);
  } else {
    setFU(true);
    return true;
  }
}

isExist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(cFirstUsePref);
}