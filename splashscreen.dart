import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginscreen/home_screen.dart';
import 'package:loginscreen/map_screen.dart';
import 'package:loginscreen/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState(){
    super.initState();

    final _auth= FirebaseAuth.instance;
    final user= _auth.currentUser;

    if(user!=null) {
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      });
    }
      else{
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_)=> LoginScreen()),
        );
      });
    }
    }

  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Container(
        height: double.infinity,
        width: double.infinity,
        child: const Image(
          image: AssetImage('assets/images/splashscreen.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
