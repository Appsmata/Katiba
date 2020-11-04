// This file declares the start screen which will handle
// first time settings and the next screen

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katiba/screens/cc_init_load.dart';
import 'package:katiba/screens/dd_home_view.dart';
import 'package:katiba/utils/preferences.dart';

class AppStart extends StatefulWidget {
  @override
  createState() => new SplashPageState();
}

class SplashPageState extends State<AppStart> {
  final globalKey = new GlobalKey<ScaffoldState>();

@override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), _handleTapEvent);
    return MaterialApp(
      home: Scaffold(
      body: Center( 
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage("assets/images/splash.jpg"),
              fit: BoxFit.cover
            )
          ),
          )
        )
      )
    ); 
  }

  void _handleTapEvent() async {
    bool katibadbLoaded = await Preferences.isKatibadbLoaded();

      if (this.mounted) {
      setState(() {
        if (katibadbLoaded != null && katibadbLoaded)
        {
          Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new DdHomeView()));
        }
        else {
          Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new CcInitLoad()));
        }
      });
    }
  }

}
