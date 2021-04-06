import 'package:adhan_app/alerts/internet_alert.dart';
import 'package:adhan_app/helpers/internet_checker.dart';
import 'package:adhan_app/helpers/permission_handler.dart';
import 'package:adhan_app/model/salah.dart';
import 'package:adhan_app/screens/home_page.dart';
import 'package:adhan_app/services/salah_service.dart';
import 'package:adhan_app/shared_pref/first_user_pref.dart';
import 'package:adhan_app/shared_pref/location_pref.dart';
import 'package:app_settings/app_settings.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isGPSEnabled = false;
  bool isLocationPermissionGranted = false;
  bool isNotificationPermissionGranted = false;
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  bool isLoading = false;
  int btnStartFuncAttempts = 0;
  bool fu = false;
  bool isButtonStartEnabled = false;

  checkGPS() async {
    isGPSEnabled = await checkGPSEnabled();
    setState(() {});
  }

  checkLocationPermission() async {
    isLocationPermissionGranted = await requestLocationPermission();
    setState(() {});
  }

  checkNotificationPermission() async {
    isNotificationPermissionGranted = await requestNotificationPermission();
    setState(() {});
  }

  startHomePage() async {
    load();
    try {
      List<Salah> salahList = await getSalahOfTheDay();
      Navigator.pushReplacementNamed(
        context,
        HomePage.route,
        arguments: StartPageArgs(salahList),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'No Internet Connection!', backgroundColor: Colors.red);
      print(e);
    }
  }

  Future<bool> isLocSaved() async {
    return (await getLatitude() != null);
  }

  init() async {
    try {
      setState(() {
        isLoading = true;
      });

      await checkGPS();
      await checkLocationPermission();
      await checkNotificationPermission();
      fu = await getFU();
      print(fu);
      if (fu) {
        if (isGPSEnabled &&
            isLocationPermissionGranted &&
            isNotificationPermissionGranted) {
          while (!await isLocSaved()) {
            await saveUserCurrentLocation();
            await new Future.delayed(const Duration(seconds: 2));
          }
          // -- user loc exist
          if (await isLocSaved()) {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(
              msg: 'Please activate your GPS!', backgroundColor: Colors.red);
        }
      } else {
        print('else');
        if (await isLocSaved()) {
          isLoading = false;
          setState(() {});
          startHomePage();
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e, backgroundColor: Colors.red);
    }
  }

  checks() async {
    fu = await getFU(); // is it the first time of user opening the app
    setState(() {});
    await checkGPS();
    await checkLocationPermission();
    await checkNotificationPermission();
    if (isLocationPermissionGranted &&
        isGPSEnabled &&
        isNotificationPermissionGranted &&
        !fu) {
      isLoading = true;
      double lat = await getLatitude();
      print(lat);
      if (lat != null) {
        Fluttertoast.showToast(
          msg: 'We\'re unable to get your location',
          backgroundColor: Colors.red,
        );
        setFU(true);
        checks();
      }
      setState(() {});
      load();
      try {
        List<Salah> salahList = await getSalahOfTheDay();
        Navigator.pushReplacementNamed(
          context,
          HomePage.route,
          arguments: StartPageArgs(salahList),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'No Internet Connection!', backgroundColor: Colors.red);
        print(e);
        load();
      }
    } else if (!fu) {
      Fluttertoast.showToast(
        msg: 'We\'re unable to get your location',
        backgroundColor: Colors.red,
      );
      isLoading = false;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  saveUserCurrentLocation() async {
    try {
      geoLocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest)
          .then((Position position) {
        print('from saveLoc ${position.latitude}');
        setLatitude(position.latitude);
        setLongitude(position.longitude);
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  load() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  btnStartFunc() async {
    isLoading = true;
    setState(() {});
    await checkGPS();
    await checkLocationPermission();
    await checkNotificationPermission();
    if (isGPSEnabled &&
        isLocationPermissionGranted &&
        isNotificationPermissionGranted) {
      await setFU(false);
      await startHomePage();
      isLoading = false;
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: 'Make sure your GPS is Enabled');
      isLoading = false;
      setState(() {});
    }
  }

  String btnGpsTxt = 'تشغيل';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: !fu
                  ? SizedBox()
                  : BlurryContainer(
                      height: height * .8,
                      bgColor: Colors.black,
                      blur: 10,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              'السلام عليكم',
                              style: GoogleFonts.tajawal(
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'يحتاج التطبيق إلى الوصول إلى بعض الصلاحيات للعمل بشكل صحيح',
                              style: GoogleFonts.tajawal(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Spacer(),
                          ListTilePermission(
                            text: 'نظام الملاحة GPS',
                            btnTxt: btnGpsTxt,
                            callback: () {
                              if (btnGpsTxt == 'تشغيل') {
                                btnGpsTxt = 'تحقق';
                                print(btnGpsTxt);
                                setState(() {});
                                AppSettings.openLocationSettings();
                              } else {
                                btnGpsTxt = '....';
                                init();
                                btnGpsTxt = 'تشغيل';
                                setState(() {});
                              }
                            },
                            isEnabled: isGPSEnabled,
                          ),
                          ListTilePermission(
                            text: 'تحديد المواقع',
                            btnTxt: 'منح',
                            callback: () async {
                              isLocationPermissionGranted =
                                  await requestPermission(
                                      PermissionGroup.location);
                              setState(() {});
                            },
                            isEnabled: isLocationPermissionGranted,
                          ),
                          ListTilePermission(
                            text: 'التنبيهات',
                            btnTxt: 'منح',
                            callback: () async {
                              isNotificationPermissionGranted =
                                  await requestPermission(
                                      PermissionGroup.notification);
                              if (!isNotificationPermissionGranted) {
                                AppSettings.openAppSettings();
                              }
                              // checks();
                              setState(() {});
                            },
                            isEnabled: isNotificationPermissionGranted,
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset('assets/logo.png'),
                              Image.asset('assets/logo2.png')
                            ],
                          )
                        ],
                      ),
                    ),
            ),
            isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      height: 20,
                      width: 20,
                    ),
                  )
                : RoundedButtonStart(btnStartFunc)
          ],
        ),
      ),
    );
  }
}

class StartPageArgs {
  List<Salah> salahList;

  StartPageArgs(this.salahList);
}

class RoundedButtonStart extends StatelessWidget {
  final Function callback;

  RoundedButtonStart(this.callback);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'إبدأ',
                style: GoogleFonts.tajawal(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListTilePermission extends StatelessWidget {
  final String text;
  final String btnTxt;
  final Function callback;
  final bool isEnabled;

  ListTilePermission({
    @required this.text,
    @required this.btnTxt,
    @required this.callback,
    @required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          isEnabled ? Icons.check : Icons.close,
          color: Colors.white,
          size: 20,
        ),
        title: Text(
          text,
          style: GoogleFonts.tajawal(
            color: Colors.white,
          ),
        ),
        trailing: isEnabled ? SizedBox() : RoundedButton(callback, btnTxt));
  }
}

class RoundedButton extends StatelessWidget {
  final Function callback;
  final String text;

  RoundedButton(this.callback, this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            text,
            style: GoogleFonts.tajawal(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
