import 'dart:convert';
import 'dart:ffi';

import 'package:adhan_app/database/db_provider.dart';
import 'package:adhan_app/model/salah.dart';
import 'package:adhan_app/shared_pref/data_json.dart';
import 'package:adhan_app/shared_pref/location_pref.dart';
import 'package:adhan_app/shared_pref/method_pref.dart';
import 'package:adhan_app/shared_pref/qibla_pref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

String url = 'https://api.aladhan.com/v1/qibla';

Future<double> getQiblaDirection() async {

  final response = await http.get('$url/${await getLatitude()}/${await getLongitude()}');
  print(response);
  if(jsonDecode(response.body)["data"]["direction"] is double){
    double direction = jsonDecode(response.body)["data"]["direction"];
    await setQibla(direction);
    return direction;
  }
  double dir =  await getQibla();
  return dir;
}

