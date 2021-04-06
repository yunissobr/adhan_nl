

import 'package:shared_preferences/shared_preferences.dart';

const String cPreferredAdhan = 'PREFERRED_ADHAN_PREF';



setPreferredAdhan(String adhanName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(cPreferredAdhan, adhanName);
}

Future<String> getPreferredAdhan() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(await isExist()){
    return prefs.getString(cPreferredAdhan);
  } else {
    setPreferredAdhan('adan1');
    return 'adan1';
  }
}

isExist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(cPreferredAdhan);
}