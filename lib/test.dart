import 'package:adhan_app/database/db_provider.dart';
import 'package:adhan_app/services/salah_service.dart';

import 'model/salah.dart';

//List<Salah> salahList = [
//  Salah('الفجر', 'Fajer', '06:45', true, DateTime(2020, 2, 2)),
//  Salah('الظهر', 'Doher', '12:56', true, DateTime(2020, 2, 2)),
//  Salah('العصر', 'Asre', '16:34', true, DateTime(2020, 2, 2)),
//  Salah('المغرب', 'Maghrib', '18:45', true, DateTime(2020, 2, 2)),
//  Salah('العشاء', 'Aisha', '19:23', true, DateTime(2020, 2, 2)),
//];

void startDebugging() async {
  print(
      '________________________DEBUGGING____SECTION________________________________');
  print('Debugging started..');

//  DBProvider.db.newSalah(Salah('الفجر', 'Fajer', '06:45', true, DateTime(2020, 2, 2)));
//    loadSalahFromOnline(33, 33, 1, 2, 2, 2021) ;
//   await DBProvider.db.newSalah(salahList[0]);
//    DBProvider.db.deleteAll();
//  print((await getSalahOfTheDay()).length);
//  List<Salah> list = await DBProvider.db.getAllSalah();
//  Salah slh = list[0];
  var timestamp = (DateTime(2020, 2, 2).toUtc().millisecondsSinceEpoch);
//
//  int timestamp2 =
//      slh.date
//          .toUtc()
//          .millisecondsSinceEpoch;
//////
  print('A- => ${timestamp}');
//  print('db => ${timestamp2}');
//  print('Actual => ${timestamp2.toInt()}');
//  print('From Db => $timestamp2');
  List<Salah> list = await DBProvider.db.findSalahByTimestamp(timestamp);

  print(list.length);
//  for(Salah slh in list){
//    print(slh.englishName);
//  }
}
