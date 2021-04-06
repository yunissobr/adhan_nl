
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission(PermissionGroup permission) async {
  final PermissionHandler _permissionHandler = PermissionHandler();
  var result = await _permissionHandler.requestPermissions([permission]);
  if (result[permission] == PermissionStatus.granted) {
    return true;
  }
  return false;
}

Future checkGps(BuildContext context,Function callback) async {
  if (!(await Geolocator().isLocationServiceEnabled())) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Icon(
                      Icons.location_off,
                      size: 50,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    'يرجى التأكد من تشغيل GPS والمحاولة مرة أخرى',
                    style: GoogleFonts.tajawal(
                      height: 1.9,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "اعادة المحاولة",
                    style: GoogleFonts.tajawal(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    callback();
                  })
            ],
          );
        });
  }
}

Future<bool> checkGPSEnabled() async {
  return await Geolocator().isLocationServiceEnabled();
}

Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
  var granted = await requestPermission(PermissionGroup.location);
  return granted;
}

Future<bool> requestNotificationPermission({Function onPermissionDenied}) async {
  var granted = await requestPermission(PermissionGroup.notification);
  return granted;
}
