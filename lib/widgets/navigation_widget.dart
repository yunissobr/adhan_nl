import 'package:adhan_app/services/qibla_service.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blurrycontainer/blurrycontainer.dart';


class NavigationWidget extends StatefulWidget {
  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  double direction = 0;

  void updateDirection() async{

    double dir = await getQiblaDirection();
    setState(() {
      direction = dir;
    });
  }
  @override
  void initState() {
    super.initState();
    updateDirection();
  }
  @override
  Widget build(BuildContext context)  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 10.0,
      ),
      child: BlurryContainer(
        height: height * .5,
        bgColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildCompass(direction),
            Text(
              '**قد يتأثر الهاتف بالمعادن المحيطة !  لا تعتمد عليه إلا في حالة عدم معرفتك لاتجاه القبلة',
              style: GoogleFonts.tajawal(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildCompass(double navDirection) {
  return StreamBuilder<double>(
    stream: FlutterCompass.events,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error reading heading: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      double direction = snapshot.data;

      // if direction is null, then device does not support this sensor
      // show error message
      if (direction == null)
        return Center(
          child: Text("Device does not have sensors !"),
        );
      return Container(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:25.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Transform.rotate(
                  angle: ((direction ?? 0) * (math.pi / 180) * -1),
                  child: Image.asset(
                    'assets/compass.png',
                    width: 170,
                  ),
                ),
                Container(
                  child: Transform.rotate(
                    angle: ((direction - navDirection ?? 0) *
                        (math.pi / 180) *
                        -1),
                    child: Image.asset(
                      'assets/needle.png',
                      width: 22.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}