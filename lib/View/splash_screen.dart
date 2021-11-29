import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:musicplayer/View/slide_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {Get.off( SlidePage());});}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(backgroundColor: Colors.black, body: Container(child: Image.asset('assets/Welcome To.png', fit: BoxFit.fill,),),),
      ],);
  }
}
