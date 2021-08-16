import 'dart:convert';

import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var isWaitingValidate, isValidateEmail, isUsernameExist, isWaiting;
  late String username, email, fullName, password;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _fullNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  late SharedPreferences session;

  final _formKey = GlobalKey<FormState>();
  late bool isEmailExist;

  Future<bool> checkUsername(String username) async {
    Uri url = Uri.parse(
        "http://192.168.100.100/e-commerce-flutter-app/User.php?checkUsername=1&username=$username");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body == "true") {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<bool> checkEmail(String email) async {
    Uri url = Uri.parse(
        "http://192.168.100.100/e-commerce-flutter-app/User.php?checkEmail=1&email=$email");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body == "true") {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    isEmailExist = false;
    isWaiting = false;
    isUsernameExist = false;

    // session = SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();

    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _fullNameFocusNode.dispose();
  }

  void setFocus(FocusNode oldFocus, FocusNode nextFocus) {
    oldFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Center(
            child: Form(
              key: _formKey,
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
                          "Nama Lengkap",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: _fullNameController,
                          onChanged: (String value) {},
                          onEditingComplete: () {
                            setFocus(_fullNameFocusNode, _emailFocusNode);
                          },
                          focusNode: _fullNameFocusNode,
                          autofocus: true,
                          style: TextStyle(
                              color: ColorTheme.secondaryColor, fontSize: 12),
                          cursorColor: ColorTheme.thirdColor,
                          textInputAction: TextInputAction.next,
                          keyboardAppearance: Brightness.dark,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "E.g Budiman Hartono",
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
                          "Email",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          validator: (String? value) {
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                .hasMatch(value!)) {
                              return "Pastikan yang anda masukan adalah email";
                            }
                          },
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onEditingComplete: () async {
                            isValidateEmail = true;
                            setState(() {});

                            isEmailExist =
                                await checkEmail(_emailController.text);
                            print(isEmailExist);
                            if (!isEmailExist) {
                              setFocus(_emailFocusNode, _usernameFocusNode);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Email tersedia"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Email sudah terpakai"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                            isValidateEmail = false;
                            setState(() {});
                          },
                          focusNode: _emailFocusNode,
                          autofocus: true,
                          style: TextStyle(
                              color: ColorTheme.secondaryColor, fontSize: 12),
                          cursorColor: ColorTheme.thirdColor,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          keyboardAppearance: Brightness.dark,
                          decoration: InputDecoration(
                            suffix: Container(
                              width: 30,
                              child: isValidateEmail == true
                                  ? SpinKitCircle(
                                      color: Colors.black,
                                      size: 15,
                                    )
                                  : SizedBox.shrink(),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "E.g budi@gmail.com",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: !isEmailExist
                                    ? ColorTheme.thirdColor
                                    : ColorTheme.fourthColor,
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
                          "Username",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Field ini tidak boleh kosong";
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _usernameController,
                          focusNode: _usernameFocusNode,
                          onEditingComplete: () async {
                            if (_formKey.currentState!.validate()) {
                              this.isWaitingValidate = true;
                              setState(() {});
                              isUsernameExist = await checkUsername(username);
                              if (isUsernameExist) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(children: [
                                      Text(
                                        "$username",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(" sudah terpakai"),
                                    ]),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(children: [
                                      Text(
                                        "$username",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(" tersedia"),
                                    ]),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                setFocus(
                                    _usernameFocusNode, _passwordFocusNode);
                              }
                              this.isWaitingValidate = false;
                              setState(() {});
                            }
                          },
                          onChanged: (String value) {
                            username = value;
                          },
                          autofocus: true,
                          style: TextStyle(
                              color: ColorTheme.secondaryColor, fontSize: 12),
                          cursorColor: ColorTheme.thirdColor,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          keyboardAppearance: Brightness.dark,
                          decoration: InputDecoration(
                            suffix: Container(
                              width: 30,
                              child: isWaitingValidate == true
                                  ? SpinKitCircle(
                                      color: Colors.black,
                                      size: 15,
                                    )
                                  : SizedBox.shrink(),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "E.g budihartono30",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: !isUsernameExist
                                    ? ColorTheme.thirdColor
                                    : ColorTheme.fourthColor,
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
                          controller: _passwordController,
                          obscureText: true,
                          onChanged: (String value) {
                            this.password = value;
                          },
                          focusNode: _passwordFocusNode,
                          autofocus: true,
                          style: TextStyle(
                              color: ColorTheme.secondaryColor, fontSize: 12),
                          cursorColor: ColorTheme.thirdColor,
                          keyboardType: TextInputType.emailAddress,
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
                          // color: Colors.red,
                          child: TextButton.icon(
                            onPressed: () async {
                              isWaiting = true;
                              setState(() {});
                              String username = this.username;
                              String password = this.password;
                              String fullName = _fullNameController.text;
                              String email = _emailController.text;
                              int balance = 0;
                              dynamic newUser = {
                                "username": username,
                                "password": password,
                                "full_name": fullName,
                                "balance": balance,
                                "email": email,
                              };
                              newUser = jsonEncode(newUser);
                              // Uri url = Uri.parse(
                              //     "http://192.168.100.100/e-commerce-flutter-app/User.php?login=1&username=${username}&password=${password}");
                              Uri url = Uri.parse(
                                  "http://localhost/e-commerce-flutter-app/User.php?signUp=1&newUser=$newUser");
                              var response = await http.get(url);
                              if (response.statusCode == 200) {
                                if (response.body != "false") {
                                  // Map<String, dynamic> data =
                                  //     jsonDecode(response.body)
                                  //         as Map<String, dynamic>;
                                  // User user = User.fromJson(
                                  //   json: data,
                                  // );
                                  // session =
                                  //     await SharedPreferences.getInstance();
                                  // await session.setString(
                                  //     "user", user.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Berhasil didaftarkan"),
                                    ),
                                  );
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/", (route) => false);
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text(
                                      "Gagal didaftarkan, silahkan coba lagi.",
                                    ),
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
                            },
                            icon:
                                // SpinKitCircle(
                                //         color: ColorTheme.primaryColor,
                                //         duration: Duration(seconds: 1),
                                //         size: 24,
                                //       )
                                Icon(
                              Icons.app_registration,
                              color: ColorTheme.primaryColor,
                            ),
                            label: Text(
                              "Daftar",
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: TextButton.icon(
                            onPressed: () {
                              return Navigator.pop(context);
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
      ),
    );
  }
}
