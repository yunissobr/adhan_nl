import 'package:adhan_app/model/salah.dart';
import 'package:adhan_app/providers/initial_screen_provider.dart';
import 'package:adhan_app/screens/initial_screen.dart';
import 'package:adhan_app/screens/start_page.dart';
import 'package:adhan_app/services/NextSalahCalculator.dart';
import 'package:adhan_app/shared_pref/salah_reminder_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'helpers/notificationHelper.dart';
import 'screens/home_page.dart';

const myTask = "syncWithTheBackEnd0";
final FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();

Future<void> _showNotificationCustomSound(data) async {
  FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your other channel id',
    'your other channel name',
    'your other channel description',
    sound: RawResourceAndroidNotificationSound('adan1'),
  );
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(sound: 'adan1.mp3');

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await flip.show(0, 'Adhan', '$data', platformChannelSpecifics);
}

void callbackDispatcher() async {
  Workmanager.executeTask((task, inputData) async {
    Salah slh = await getNxtSalah();
    int hoursLeft = remainingTime.truncate();
    int minutesLeft =
        ((remainingTime - remainingTime.truncate()) * 60).truncate();

    print('hours left: $hoursLeft');
    print('isNotificationEnabled: ${slh.isNotificationEnabled}');
    if (minutesLeft < 15 && hoursLeft < 1) {
      if (minutesLeft > 10) {
        print('remaining time is greater 10minutes and 0 hours');
        _showNotificationWithDefaultSound(
            'الصلاة القادمة في غضون $minutesLeft دقائق');
        if (slh.isNotificationEnabled) {
          await Future.delayed(Duration(minutes: minutesLeft), () {
            _showNotificationCustomSound('حان وقت صلاة ${slh.name}');
          });
        }
      } else {
        print('remaining time is lower 10minutes and 0 hours');
        if (slh.isNotificationEnabled) {
          await Future.delayed(Duration(minutes: minutesLeft), () {
            _showNotificationCustomSound('حان وقت صلاة ${slh.name}');
          });
        }
      }
    }

    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(data) async {
//  FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
//  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//  var IOS = new IOSInitializationSettings();
//  var settings = new InitializationSettings(android: android, iOS: IOS);
//  flip.initialize(settings);
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'default_notification_channel_id',
      'adhan_app',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flp.show(0, 'Adhan App', '$data', platformChannelSpecifics,
      payload: 'Default_Sound');
}

void _requestPermissions() {
  flp
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  flp
      .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flp.getNotificationAppLaunchDetails();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flp.initialize(initializationSettings);
  _requestPermissions();
//  _showNotificationCustomSound('custom');
//  await Workmanager.cancelAll();
  Workmanager.initialize(
    callbackDispatcher,
//    isInDebugMode: true,
  );
  Workmanager.registerPeriodicTask(
    "2",
    myTask,
    initialDelay: Duration(seconds: 60),
    frequency: Duration(minutes: 15),
  );
//  _showNotificationCustomSound('test cc');
  runApp(AdhanApp());
}

class AdhanApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => InitialScreenProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget child) {
          return new Directionality(
            textDirection: TextDirection.rtl,
            child: new Builder(
              builder: (BuildContext context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: child,
                );
              },
            ),
          );
        },
        home: InitialScreen(),
        routes: {
          HomePage.route: (context) => HomePage(),
          InitialScreen.route: (context) => InitialScreen(),
        },
      ),
    );
  }
}
