import 'package:datapemilih/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            bodyText1: TextStyle(color: kBackgroundColor),
          )),
      home: LoginScreen(),
    );
  }
}
