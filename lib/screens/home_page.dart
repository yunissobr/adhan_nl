import 'dart:math';

import 'package:adhan_app/helpers/notificationHelper.dart';
import 'package:adhan_app/model/salah.dart';
import 'package:adhan_app/screens/start_page.dart';
import 'package:adhan_app/services/salah_service.dart';
import 'package:adhan_app/shared_pref/location_pref.dart';
import 'package:adhan_app/shared_pref/salah_reminder_pref.dart';
import 'package:adhan_app/test.dart';
import 'package:adhan_app/widgets/info_widget.dart';
import 'package:adhan_app/widgets/navigation_bottom_bar.dart';
import 'package:adhan_app/widgets/navigation_widget.dart';
import 'package:adhan_app/widgets/salah_time_section.dart';
import 'package:adhan_app/widgets/settings_widget.dart';
import 'package:adhan_app/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  static String route = '/HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Salah> list = [];
  String selectedMenuItem = 'home';
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  String _currentAddress;
  double remainingTime = 0;

  void selectMenuTo(String val) {
    setState(() {
      selectedMenuItem = val;
    });
  }

  void getSalahList() async {
    list = await getSalahOfTheDay();
    setState(() {});
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
          await getLatitude(), await getLongitude());
      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Widget getCurrentDisplayingWidget() {
    switch (selectedMenuItem) {
      case 'home':
        {
          return SalahTimeSection(list: list);
        }
      case 'info':
        {
          return InfoWidget();
        }
      case 'navigation':
        {
          return NavigationWidget();
        }
      case 'settings':
        {
          return SettingsWidget();
        }
      default:
        {
          return SalahTimeSection(list: list);
        }
    }
  }

  Salah getNxtSalah() {
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
      setState(() {
        remainingTime = (timeDiffList[0] * -1) - 6;
      });
      return list[0];
    } else {
      setState(() {
        remainingTime = minValue;
      });
      try {
        return list[timeDiffList.indexOf(minValue)];
      } catch (E) {
        print(E);
        return Salah('', '', '00:00', false, DateTime.now());
      }
    }
  }

//  void initNOT() async {
//    notificationAppLaunchDetails =
//        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//    await initNotifications(flutterLocalNotificationsPlugin);
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        '0', 'Yuniss', 'your channel description',
//        sound: RawResourceAndroidNotificationSound('adhan_takbir_01'),
//        importance: Importance.max,
//        priority: Priority.high,
//        ticker: 'ticker');
//
//    var androidPlatformChannelSpecificsForReminder = AndroidNotificationDetails(
//        '0', 'Yuniss', 'your channel description',
//        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
//
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//
//    Salah nxtSalah = getNxtSalah();
//
//    var sch = DateTime.now().add(Duration(
//        hours: remainingTime.truncate(),
//        minutes: ((remainingTime - remainingTime.truncate()) * 60).truncate()));
//
//    if (await getSalahReminder() == 0) {
//      await flutterLocalNotificationsPlugin.schedule(0, 'Reminder',
//          'Time to ' + nxtSalah.englishName, sch, platformChannelSpecifics);
//    } else {
//      var newSch = sch.subtract(Duration(minutes: 10));
//      // show notification at the exact salah time
//      await flutterLocalNotificationsPlugin.schedule(0, 'Reminder',
//          'Time to ' + nxtSalah.englishName, newSch, platformChannelSpecifics);
//
//      // show alert before salah time
//      platformChannelSpecifics = NotificationDetails(
//          androidPlatformChannelSpecificsForReminder,
//          iOSPlatformChannelSpecifics);
//      var nxtSalahTimeReminder =
//          sch.subtract(Duration(minutes: await getSalahReminder()));
//      await flutterLocalNotificationsPlugin.schedule(
//          0,
//          'Reminder',
//          (await getSalahReminder()).toString() + 'min Left for ' + nxtSalah.englishName,
//          nxtSalahTimeReminder,
//          platformChannelSpecifics);
//    }
//  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    initNOT();
    getSalahList();
    _getAddressFromLatLng();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        callback: selectMenuTo,
        selectedItem: selectedMenuItem,
        screenHeight: height,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SummaryWidget(
                currentAddress: _currentAddress ?? 'loading',
                salah: getNxtSalah(),
                remainingTime: remainingTime),
            getCurrentDisplayingWidget(),
          ],
        ),
      ),
    );
  }
}
