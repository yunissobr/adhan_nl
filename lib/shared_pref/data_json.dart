import 'package:shared_preferences/shared_preferences.dart';

const String cDataJson = 'DATA_JSON_PREF';



setDataJson(String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(cDataJson, data);
}

Future<String> getDataJson() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(await isExist()){
    return prefs.getString(cDataJson);
  } else {
    setDataJson('');
    return null;
  }
}

isExist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(cDataJson);
}