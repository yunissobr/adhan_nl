import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showAlertDialog(BuildContext context,Function refresh) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("اعادة المحاولة",style: GoogleFonts.tajawal(),),
    onPressed: () {
      Navigator.of(context).pop();
      refresh();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

    content: Container(
      height: 165,
      child: Padding(
        padding: const EdgeInsets.only(top:18.0),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.signal_cellular_connected_no_internet_4_bar,
              color: Colors.red,
              size: 40,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "المرجو التأكد من توفر\n الاتصال بالانترنت",
              style: GoogleFonts.tajawal(
                  fontSize: 18,
                  height: 1.8
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}