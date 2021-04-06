import 'package:adhan_app/model/salah.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';

class SummaryWidget extends StatefulWidget {
  final Salah salah;
  final String currentAddress;
  final double remainingTime;

  SummaryWidget({
    @required this.salah,
    @required this.currentAddress,
    @required this.remainingTime,
  });

  @override
  _SummaryWidgetState createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  String currentDate;
  final String locale = 'en';
  HijriCalendar _todayHijri = new HijriCalendar.now();


  void getCurrentDate() {
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    currentDate = formatter.format(now);
    setState(() {});
  }

  void getCountDown() {}

  @override
  void initState() {
    super.initState();
    getCurrentDate();
    HijriCalendar.setLocal(locale);
  }

  @override
  Widget build(BuildContext context) {
    int endTime = DateTime.now().millisecondsSinceEpoch +
        widget.remainingTime.truncate() * 3600000 +
        (((widget.remainingTime - widget.remainingTime.truncate()) * 60)
                .truncate() *
            60000);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        SizedBox(
          height: height * 0.06,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: BlurryContainer(
            height: height * 0.275,
            borderRadius: BorderRadius.circular(12),
            bgColor: Color(0xFFC78BA5),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 3,
                ),
                Text(
                  'صلاة ${widget.salah.name}',
                  style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '${widget.salah.time}',
                  style: GoogleFonts.roboto(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                CountdownTimer(
                  endTime: endTime,
                  widgetBuilder: (_, CurrentRemainingTime time) {
                    return Text(
                      time != null
                          ? '${time.sec ?? '00'} : ${time.min ?? '00'} : ${time.hours ?? '00'} -'
                          : '00:00:00',
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${_todayHijri.toFormat("MMMM dd yyyy")}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1,),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '$currentDate',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          widget.currentAddress,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
