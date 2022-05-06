import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bala.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> with TickerProviderStateMixin {
  AnimationController? animation;
  late Animation<double> _fadeInFadeOut;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: Hero(

            tag: "image",
            child: Container(
              child: Image(
                image: AssetImage('images/FrontBanner.png'),
              ),

            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animation?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: Duration(seconds: 3),);
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation!);
    animation?.addStatusListener((status){
      if(status == AnimationStatus.completed){
        animation?.reverse();
      }
      else if(status == AnimationStatus.dismissed){
        animation?.forward();
      }
    });
    animation?.forward();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
    });
  }
}
