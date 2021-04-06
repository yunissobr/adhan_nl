import 'package:adhan_app/providers/initial_screen_provider.dart';
import 'package:adhan_app/screens/home_page.dart';
import 'package:adhan_app/screens/start_page.dart';
import 'package:adhan_app/services/salah_service.dart';
import 'package:adhan_app/shared_pref/location_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'helpers/permission_handler.dart';
import 'model/salah.dart';

class CustomDialogBox extends StatefulWidget {
  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();

  CustomDialogBox();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  bool showTryButton = false;

  initChecks() async {
    setState(() {
      showTryButton = false;
    });

    Provider.of<InitialScreenProvider>(context, listen: false)
        .updateGps(true, false);
    Provider.of<InitialScreenProvider>(context, listen: false)
        .updatePermission(true, false);
    Provider.of<InitialScreenProvider>(context, listen: false)
        .updateInternet(true, false);
    await checkLocationPermission();
    await requestNotificationPermission();
  }

  Future checkLocationPermission() async {
    Provider.of<InitialScreenProvider>(context, listen: false)
        .updatePermission(false, await requestLocationPermission());
    if (await requestLocationPermission()) {
      await checkGPS();
    } else {
      Fluttertoast.showToast(
          msg: 'يرجى منح صلاحية الوصول الى الموقع',
          backgroundColor: Colors.red);
      setState(() {
        showTryButton = true;
      });
    }
  }

  Future checkGPS() async {
    Provider.of<InitialScreenProvider>(context, listen: false)
        .updateGps(false, (await checkGPSEnabled()));
    if (await checkGPSEnabled()) {
      await saveUserCurrentLocation();
    } else {
      Fluttertoast.showToast(
          msg: 'المرجو تشغيل GPS ', backgroundColor: Colors.red);
      setState(() {
        showTryButton = true;
      });
    }
  }

  Future saveUserCurrentLocation() async {
    try {
      geoLocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest)
          .then((Position position) async {
        print('from saveLoc ${position.latitude}');
        setLatitude(position.latitude);
        setLongitude(position.longitude);
        await downloadSalah();
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  Future downloadSalah() async {
    List<Salah> downloadedSalah = await getSalahOfTheDay();
    if (downloadedSalah.isEmpty) {
      Fluttertoast.showToast(
          msg: 'لا يوجد اتصال بالانترنت', backgroundColor: Colors.red);
      Provider.of<InitialScreenProvider>(context, listen: false)
          .updateInternet(false, false);
      setState(() {
        showTryButton = true;
      });
    } else {
      Navigator.pushReplacementNamed(
        context,
        HomePage.route,
        arguments: StartPageArgs(downloadedSalah),
      );
      print('${downloadedSalah.length}');
    }
    Provider.of<InitialScreenProvider>(context, listen: false)
        .updateInternet(false, downloadedSalah.length > 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    initChecks();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initChecks());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    bool internetLoading =
        Provider.of<InitialScreenProvider>(context).internetIsLoading ?? false;
    bool internetSuccess =
        Provider.of<InitialScreenProvider>(context).internetIsSuccess ?? false;
    bool gpsLoading =
        Provider.of<InitialScreenProvider>(context).gpsIsLoading ?? false;
    bool gpsSuccess =
        Provider.of<InitialScreenProvider>(context).gpsIsSuccess ?? false;
    bool permissionLoading =
        Provider.of<InitialScreenProvider>(context).permissionIsLoading ??
            false;
    bool permissionSuccess =
        Provider.of<InitialScreenProvider>(context).permissionIsSuccess ??
            false;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CheckItem(
                      permissionLoading, permissionSuccess, Icons.add_location),
                  CheckItem(gpsLoading, gpsSuccess, Icons.gps_fixed),
                  CheckItem(
                      internetLoading, internetSuccess, Icons.network_check),
                ],
              ),
              SizedBox(
                height: 29,
              ),
              showTryButton ?
              FlatButton(
                onPressed: initChecks,
                child: Text(
                  'اعادة المحاولة',
                  style: GoogleFonts.tajawal(
                    color: Colors.blue,
                    fontSize: 16.0,
                  ),
                ),
              ) : Center()
            ],
          ),
        ),
      ],
    );
  }
}

class CheckItem extends StatelessWidget {
  final bool isLoading;
  final bool success;
  final IconData mainIcon;

  CheckItem(this.isLoading, this.success, this.mainIcon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          mainIcon,
          size: 40,
          color: Colors.black38,
        ),
        SizedBox(
          height: 16,
        ),
        !isLoading
            ? success
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 20,
                  )
                : Icon(
                    Icons.close,
                    color: Colors.red,
                      size: 20,
                  )
            : SizedBox(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
                ),
                width: 15,
                height: 15,
              ),
      ],
    );
  }
}
