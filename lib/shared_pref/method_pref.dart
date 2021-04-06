

import 'package:shared_preferences/shared_preferences.dart';

const String cMethodPref = 'PREFERRED_METHOD_PREF';



setMethod(String methodName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(cMethodPref, methodName);
}

Future<String> getMethod() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(await isExist()){
    return prefs.getString(cMethodPref);
  } else {
    setMethod('ISNA');
    return 'ISNA';
  }
}

isExist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(cMethodPref);
}