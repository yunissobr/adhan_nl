import 'package:adhan_app/custom_dialog.dart';
import 'package:adhan_app/database/db_provider.dart';
import 'package:adhan_app/model/salah.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'home_page.dart';

class InitialScreen extends StatefulWidget {
  static String route = '/InitialScreen';
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    SchedulerBinding.instance.addPostFrameCallback((_) => yourFunction(context));
  }

  void updateFirstUse() async {
    int timestamp =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toUtc()
            .millisecondsSinceEpoch;
    List<Salah> listSalah = await DBProvider.db.findSalahByTimestamp(timestamp);
    if (listSalah.length > 0) {
      Navigator.pushReplacementNamed(
        context,
        HomePage.route,
      );
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox();
          });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateFirstUse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: SizedBox(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
          ),
          width: 20,
          height: 20,
        )),
      ),
    );
  }
}
