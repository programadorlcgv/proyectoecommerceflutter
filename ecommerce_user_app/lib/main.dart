import 'package:ecommerce_user_app/controllers/auth_service.dart';
import 'package:ecommerce_user_app/views/home.dart';
import 'package:ecommerce_user_app/views/login.dart';
import 'package:ecommerce_user_app/views/signup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
     routes: {
       "/":(context)=> CheckUser(),
        "/login": (context)=> LoginPage(),
        "/home": (context)=> HomePage(),
        "/signup": (context)=> SingupPage(),
     },
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:  Center(child: CircularProgressIndicator(),),);
  }
}


