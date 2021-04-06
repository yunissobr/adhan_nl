import 'package:flutter/material.dart';

class InitialScreenProvider extends ChangeNotifier {
  bool internetIsLoading;
  bool internetIsSuccess;
  bool gpsIsLoading;
  bool gpsIsSuccess;
  bool permissionIsLoading;
  bool permissionIsSuccess;

  void updateInternet(bool internetLoading,bool internetSuccess){
    internetIsLoading = internetLoading;
    internetIsSuccess = internetSuccess;
    notifyListeners();
  }

  void updateGps(bool gpsLoading,bool gpsSuccess){
    gpsIsLoading = gpsLoading;
    gpsIsSuccess = gpsSuccess;
    notifyListeners();
  }

  void updatePermission(bool permissionLoading,bool permissionSuccess){
    permissionIsLoading = permissionLoading;
    permissionIsSuccess = permissionSuccess;
    notifyListeners();
  }
}