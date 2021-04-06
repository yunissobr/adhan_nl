import 'dart:convert';

import 'package:adhan_app/database/db_provider.dart';
import 'package:adhan_app/model/salah.dart';
import 'package:adhan_app/shared_pref/data_json.dart';
import 'package:adhan_app/shared_pref/location_pref.dart';
import 'package:adhan_app/shared_pref/method_pref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

String url = 'https://api.aladhan.com/v1/calendar?';

Future loadSalahFromOnline (
    double lat, double long, String method, int day, int month, int year) async {
  var dt;
  var timings;
  String tpUrl = 'https://api.aladhan.com/v1/calendar?';
  print(method);
  if(method == "SMJ"){
    tpUrl+="latitude=$lat&longitude=$long&method=99&methodSettings=14.5,null,14.0&month=$month&year=$year";
  } else {
    tpUrl+="latitude=$lat&longitude=$long&method=3&month=$month&year=$year";
  }
  print(tpUrl);

  final response = await http.get(tpUrl);
  dt = jsonDecode(response.body)["data"];
  int index = 0;
  var date;

  for (var day in dt) {
    print('day ${index + 1} saved');
    print(index);
    timings = day["timings"];
    date = DateTime(DateTime.now().year, DateTime.now().month, index + 1);
    List<Salah> salahList = [
      Salah('الفجر', 'Fajr', timings["Fajr"].toString().substring(0, 5), true,
          date),
      Salah('الشروق', 'Sunrise', timings["Sunrise"].toString().substring(0, 5),
          false, date),
      Salah('الظهر', 'Dhuhr', timings["Dhuhr"].toString().substring(0, 5), true,
          date),
      Salah('العصر', 'Asr', timings["Asr"].toString().substring(0, 5), true,
          date),
      Salah('المغرب', 'Maghrib', timings["Maghrib"].toString().substring(0, 5),
          true, date),
      Salah('العشاء', 'Isha', timings["Isha"].toString().substring(0, 5), true,
          date),
    ];
    await saveSalahListToDatabase(salahList);
    index++;
  }
}

Future saveSalahListToDatabase(List<Salah> listSalah) async {
  for (Salah salah in listSalah) {
    await DBProvider.db.newSalah(salah);
  }
}

Future<List<Salah>> getSalahOfTheDay() async {
  int timestamp =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toUtc()
          .millisecondsSinceEpoch;
  List<Salah> list = await DBProvider.db.findSalahByTimestamp(timestamp);

  if (list.isEmpty) {
    try {
      await loadSalahFromOnline(await getLatitude(), await getLongitude(), await getMethod(),
          DateTime.now().day, DateTime.now().month, DateTime.now().year);
      list = await DBProvider.db.findSalahByTimestamp(timestamp);
    } catch (e) {
      print('From getSalahOfTheDay: $e');
    }
  }
  return list;
}
