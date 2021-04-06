import 'package:shared_preferences/shared_preferences.dart';

const String cSalahReminder = 'SALAH_REMINDER_PREF';



setSalahReminder(int minutes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(cSalahReminder, minutes);
}

Future<int> getSalahReminder() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(await isExist()){
    return prefs.getInt(cSalahReminder);
  } else {
    setSalahReminder(3);
    return 0;
  }
}

isExist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(cSalahReminder);
}