import 'package:ecommerce_apps/widgets/login.dart';
import 'package:ecommerce_apps/widgets/signup.dart';
import 'package:ecommerce_apps/widgets/userProfile.dart';
import 'package:ecommerce_apps/widgets/whislist.dart';
import 'package:flutter/material.dart';
import 'widgets/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/login",
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => Home(),
        "/login": (context) => Login(),
        "/signup": (context) => SignUp(),
        "/userProfile": (context) => UserProfile(),
        "/wishlist": (context) => Whislist(),
        // "/category-list": (context) => CategoryList(),
      },
    );
  }
}
