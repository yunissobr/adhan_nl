import 'dart:io';
import 'dart:typed_data';

import 'package:adhan_app/database/db_provider.dart';
import 'package:adhan_app/screens/initial_screen.dart';
import 'package:adhan_app/shared_pref/method_pref.dart';
import 'package:adhan_app/shared_pref/preferred_adhan_pref.dart';
import 'package:adhan_app/shared_pref/salah_reminder_pref.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  String dropDownLng = 'العربية';
  String dropDownAdhan = 'adan1';
  String dropDownMethod = 'ISNA';
  String dropDownReminder = '3';
  AudioPlayer audioPlayer = AudioPlayer();
  List<String> lngList = <String>['العربية', 'Dutch'];
  List<String> adhanList = <String>['adan1', 'adan2', 'adan3'];
  List<String> methodList = <String>[
    'ISNA',
    'SMJ',
  ];

  List<String> reminderList = <String>[
    '3',
    '5',
    '10',
    '15',
    '20',
    '30',
  ];

  void initSalahReminder() async {
    dropDownReminder = '3';
    setState(() {});
  }

  void initPreferredAdhan() async {
    dropDownAdhan = await getPreferredAdhan();
    setState(() {});
  }

  Future<ByteData> loadAsset(String audioName) async {
    return await rootBundle.load('assets/$audioName.mp3');
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  playLocal(String audioName) async {
    final file =
        new File('${(await getTemporaryDirectory()).path}/$audioName.mp3');
    await file.writeAsBytes((await loadAsset(audioName)).buffer.asUint8List());
    int result = await audioPlayer.play(file.path, isLocal: true);
  }

  initPreferredMethod() async {
    dropDownMethod = await getMethod();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSalahReminder();
    initPreferredAdhan();
    initPreferredMethod();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 10.0,
      ),
      child: BlurryContainer(
        height: height * 0.5,
        bgColor: Colors.black,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.language,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                'اللغة',
                style: GoogleFonts.tajawal(
                  color: Colors.white,
                ),
              ),
              trailing: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                ),
                child: dropDownSettings(() {}, dropDownLng, lngList),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.music_note,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                'اعدادات الاذان',
                style: GoogleFonts.tajawal(
                  color: Colors.white,
                ),
              ),
              trailing: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                ),
                child: DropdownButton<String>(
                  value: dropDownAdhan,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: GoogleFonts.tajawal(
                    color: Colors.black,
                  ),
                  underline: Container(
                    height: 1,
                    color: Colors.white24,
                  ),
                  onChanged: (String newValue) async {
                    dropDownAdhan = newValue;
                    playLocal(dropDownAdhan.toLowerCase());
                    setPreferredAdhan(dropDownAdhan);
                    Fluttertoast.showToast(
                        msg: "تم",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {});
                  },
                  items:
                      adhanList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.tajawal(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.alarm,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                'تنبيهات الصلاة (بالدقائق)',
                style: GoogleFonts.tajawal(
                  color: Colors.white,
                ),
              ),
              trailing: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                ),
                child: DropdownButton<String>(
                  value: dropDownReminder,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: GoogleFonts.tajawal(
                    color: Colors.black,
                  ),
                  underline: Container(
                    height: 1,
                    color: Colors.white24,
                  ),
                  onChanged: (String newValue) async {
                    dropDownReminder = newValue;
                    setSalahReminder(int.parse(dropDownReminder));
                    Fluttertoast.showToast(
                        msg: "تم",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {});
                  },
                  items: reminderList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.tajawal(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                'طريقه حسابة الصلاه',
                style: GoogleFonts.tajawal(
                  color: Colors.white,
                ),
              ),
              trailing: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                ),
                child: DropdownButton<String>(
                  value: dropDownMethod,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: GoogleFonts.tajawal(
                    color: Colors.black,
                  ),
                  underline: Container(
                    height: 1,
                    color: Colors.white24,
                  ),
                  onChanged: (String newValue) async {
                    dropDownMethod = newValue;
                    print(newValue);
                    if (newValue != await getMethod()) {
                      await setMethod(newValue);
                      await DBProvider.db.deleteAll();
                      Navigator.pushReplacementNamed(
                          context, InitialScreen.route);
                    }
                    setState(() {});
                  },
                  items:
                      methodList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.tajawal(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton<String> dropDownSettings(
      Function callback, String drpDwnVal, List<String> items) {
    return DropdownButton<String>(
      value: drpDwnVal,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      iconSize: 24,
      elevation: 16,
      style: GoogleFonts.tajawal(
        color: Colors.black,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (String newValue) async {
//        dropDownLng = newValue;
//        setState(() {});
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: GoogleFonts.tajawal(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
