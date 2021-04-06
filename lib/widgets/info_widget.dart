import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 15.0,
      ),
      child: BlurryContainer(
        height: height * .505,
        blur: 20,
        bgColor: Colors.black,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Text(
              'يذكر الشرقية إذ جُل. بين مشاركة واندونيسيا، مع. الشمال العالم اليابان، يبق مع. ومن قد الجو أساسي الأمريكية. أن مكن سقطت التقليدي, إذ عدم وباءت لمحاكم.\n\n ما إيطاليا الخاسرة ولم, , جُل لغزو الصفحة في. وبغطاء ا الأعمال بلا و, الا وسوء اتفاقية ما. وإعلان الساحلية ',
              style: GoogleFonts.tajawal(
                color: Colors.white,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  width: 99,
                ),
                Image.asset(
                  'assets/logo2.png',
                  width: 100,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
