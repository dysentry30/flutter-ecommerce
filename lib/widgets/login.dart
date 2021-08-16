import 'dart:async';
import 'dart:convert';

import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  SharedPreferences? session;

  String? username;
  String? password;

  FocusNode usernameTextFieldFocus = FocusNode();
  FocusNode passwordTextFieldFocus = FocusNode();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isWaiting = false;

  Future<bool> checkSession() async {
    session = await SharedPreferences.getInstance();
    dynamic user = session!.get("user");
    if (user != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    checkSession()
        .then((value) => value ? Navigator.popAndPushNamed(context, "/") : "");
  }

  void setFocus(FocusNode oldFocus, FocusNode nextFocus) {
    oldFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    usernameTextFieldFocus.dispose();
    passwordTextFieldFocus.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Shopping Online",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                SizedBox(
                  height: 71,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username atau Email",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        onChanged: (String value) {
                          username = value;
                          setState(() {});
                        },
                        onEditingComplete: () => setFocus(
                            usernameTextFieldFocus, passwordTextFieldFocus),
                        focusNode: usernameTextFieldFocus,
                        autofocus: true,
                        style: TextStyle(
                            color: ColorTheme.secondaryColor, fontSize: 12),
                        cursorColor: ColorTheme.thirdColor,
                        textInputAction: TextInputAction.next,
                        keyboardAppearance: Brightness.dark,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "E.g shop20 or shop@email.com",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorTheme.thirdColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        onChanged: (String value) {
                          password = value;
                          setState(() {});
                        },
                        focusNode: passwordTextFieldFocus,
                        autofocus: true,
                        style: TextStyle(
                            color: ColorTheme.secondaryColor, fontSize: 12),
                        cursorColor: ColorTheme.thirdColor,
                        textInputAction: TextInputAction.done,
                        keyboardAppearance: Brightness.dark,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorTheme.thirdColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: TextButton.icon(
                          onPressed: () async {
                            isWaiting = true;
                            setState(() {});
                            if (usernameController.text.isEmpty &&
                                passwordController.text.isEmpty) {
                              await Future.delayed(Duration(seconds: 1));
                              final snackBar = SnackBar(
                                content: Text(
                                    "Tolong untuk diisikan field yang kosong"),
                                duration: Duration(seconds: 2),
                              );
                              isWaiting = false;
                              setState(() {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                              return;
                            } else {
                              String username = this.username!;
                              String password = this.password!;
                              Uri url = Uri.parse(
                                  "http://192.168.100.100/e-commerce-flutter-app/User.php?login=1&username=${username}&password=${password}");
                              // Uri url = Uri.parse(
                              //     "http://192.168.100.100/e-commerce-flutter-app/User.php?login=1&username=vupton&password=c0305c6fef6466e56e6d140d87da8a76");
                              var response = await http.get(url);
                              if (response.statusCode == 200) {
                                if (response.body != "false") {
                                  Map<String, dynamic> data =
                                      jsonDecode(response.body)
                                          as Map<String, dynamic>;
                                  User user = User.fromJson(
                                    json: data,
                                  );
                                  session =
                                      await SharedPreferences.getInstance();
                                  await session!
                                      .setString("user", user.toString());
                                  Navigator.popAndPushNamed(context, "/");
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text(
                                        "Username atau Password anda salah, silahkan coba lagi."),
                                    duration: Duration(seconds: 2),
                                  );
                                  isWaiting = false;
                                  setState(() {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  });
                                }
                                isWaiting = false;
                                setState(() {});
                              }
                            }
                          },
                          icon: isWaiting
                              ? SpinKitCircle(
                                  color: ColorTheme.primaryColor,
                                  duration: Duration(seconds: 1),
                                  size: 24,
                                )
                              : Icon(
                                  Icons.login_rounded,
                                  color: ColorTheme.primaryColor,
                                ),
                          label: Text(
                            isWaiting ? "" : "Masuk",
                            style: TextStyle(
                              color: ColorTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: ColorTheme.thirdColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: ColorTheme.primaryColor,
                        thickness: 3,
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, "/signup");
                          },
                          icon: Icon(
                            Icons.app_registration,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: ColorTheme.primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "/");
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Kembali",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: ColorTheme.fourthColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
