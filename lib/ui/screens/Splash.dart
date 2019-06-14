import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelivaato/ui/screens/Home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//          Expanded(
//            child: Container(
//                decoration: BoxDecoration(color: Color(0x00E46433)),
//                child: Align(
//                    alignment: FractionalOffset.centerRight,
//                    child: Text('Peli',
//                        textDirection: TextDirection.ltr,
//                        style: TextStyle(
//                            fontSize: 60.0,
//                            fontWeight: FontWeight.w700,
//                            color: Color(0xff0073AE))))),
//          ),
//          Expanded(
//              child: Container(
//                  decoration: BoxDecoration(color: Color(0x000073AE)),
//                  child: Align(
//                      alignment: FractionalOffset.centerLeft,
//                      child: Text('Vaato',
//                          textDirection: TextDirection.ltr,
//                          style: TextStyle(
//                              fontSize: 60.0,
//                              fontWeight: FontWeight.w700,
//                              color: Color(0xffE46433)))))),
//        ])
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Peli',
              style: TextStyle(
                  color: Color(0xff0073AE),
                  fontSize: 40.0,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.w600),
            ),
            Text('Vaato',
                style: TextStyle(
                    color: Color(0xffE46433),
                    fontSize: 40.0,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationToHomePage);
  }

  void navigationToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
}
