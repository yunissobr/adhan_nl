import 'package:adhan_app/database/db_provider.dart';
import 'package:adhan_app/model/salah.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalahItemWidget extends StatefulWidget {
  final Salah salah;

  SalahItemWidget({@required this.salah});

  @override
  _SalahItemWidgetState createState() => _SalahItemWidgetState();
}

class _SalahItemWidgetState extends State<SalahItemWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlurryContainer(
      height: height * .075,
      padding: EdgeInsets.all(0),
      borderRadius: BorderRadius.circular(12),
      bgColor: Color(0xFF837BA9),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 70,
              child: Text(
                widget.salah.name,
                style: GoogleFonts.tajawal(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              widget.salah.time,
              style: GoogleFonts.tajawal(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                widget.salah.isNotificationEnabled =
                    !widget.salah.isNotificationEnabled;
                await DBProvider.db.updateSalahNotification(widget.salah.englishName,widget.salah.isNotificationEnabled ? 1 : 0);
                setState(() {});
              },
              child: Icon(
                widget.salah.isNotificationEnabled
                    ? Icons.volume_up
                    : Icons.volume_mute,
                size: 30,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
