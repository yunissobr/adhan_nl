import 'package:adhan_app/model/salah.dart';
import 'package:adhan_app/services/salah_service.dart';
import 'package:flutter/material.dart';
double remainingTime = 0;
Future<Salah> getNxtSalah() async {
  List<Salah> list = [];
  list = await getSalahOfTheDay();


  TimeOfDay nowTime = TimeOfDay.now();
  double _doubleNowTime =
      nowTime.hour.toDouble() + (nowTime.minute.toDouble() / 60);
  TimeOfDay salahTime;
  List<double> timeDiffList = [];

  list.forEach((salah) {
    salahTime = TimeOfDay(
        hour: int.parse(salah.time.substring(0, salah.time.indexOf(':'))),
        minute:
            int.parse(salah.time.substring(salah.time.indexOf(':') + 1, 5)));

    double _doubleTempTime =
        salahTime.hour.toDouble() + (salahTime.minute.toDouble() / 60);
    double _timeDiff = (_doubleTempTime - _doubleNowTime);
    timeDiffList.add(_timeDiff);
  });

  int negativeCounter = 0;
  double minValue;

  minValue = (list.length > 0) ? timeDiffList[5] : 0;

  timeDiffList.forEach((timeDifference) {
    if (timeDifference > 0) {
      if (minValue > timeDifference) {
        minValue = timeDifference;
      }
    }
    if (timeDifference < 0) {
      negativeCounter++;
    }
  });

  if (negativeCounter >= 6) {
    remainingTime = (timeDiffList[0] * -1) - 6;
    return list[0];
  } else {
    remainingTime = minValue;
    try {
      return list[timeDiffList.indexOf(minValue)];
    } catch (E) {
      print(E);
      return Salah('', '', '00:00', false, DateTime.now());
    }
  }
}
