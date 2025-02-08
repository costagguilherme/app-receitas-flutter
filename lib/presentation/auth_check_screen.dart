import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/presentation/home_screen.dart';
import 'package:matc89_aplicativo_receitas/presentation/login_screen.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {

  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
       if (user == null) {
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
       } else {
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
       }
    });
  }

  @override void dispose() {
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
