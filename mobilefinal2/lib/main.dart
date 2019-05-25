import 'package:flutter/material.dart';
import 'package:mobilefinal2/ui/signin_page.dart';
import 'package:mobilefinal2/ui/regis_page.dart';
import 'package:mobilefinal2/ui/profi_page.dart';
import 'package:mobilefinal2/ui/home.dart';
import 'package:mobilefinal2/ui/friend_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Final',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/regis": (context) => RegistPage(),
        "/home": (context) => Home(),
        "/profile": (context) => Profile(),
        "/friend": (context) => FriendPage(),
      },
    );
  }
}
