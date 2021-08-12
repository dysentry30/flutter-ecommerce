// import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: 80,
                      child: Card(
                        elevation: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/default.jpg"),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Bagas Satria Nurwinanto",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: constraints.maxWidth,
                      height: 180,
                      child: Card(
                        elevation: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Stack(
                            children: [
                              Text(
                                "Daftar Transaksi",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 15),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          onTap: () =>
                                              print("Transaksi Berlangsung"),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  FontAwesome5.cart_arrow_down,
                                                  color: ColorTheme.thirdColor,
                                                  size: 40,
                                                ),
                                                SizedBox(height: 12),
                                                Container(
                                                  width: 80,
                                                  child: Text(
                                                    "Transaksi Berlangsung",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 15),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          onTap: () => print("Semua Transaksi"),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  FontAwesome5.history,
                                                  color: ColorTheme.thirdColor,
                                                  size: 40,
                                                ),
                                                SizedBox(height: 12),
                                                Container(
                                                  width: 80,
                                                  child: Text(
                                                    "Riwayat Semua Transaksi",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: constraints.maxWidth,
                      height: 180,
                      child: Card(
                        elevation: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Stack(
                            children: [
                              Text(
                                "Saldo Anda",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          child: Column(
                                            children: [
                                              Icon(
                                                FontAwesome.money,
                                                color: ColorTheme.thirdColor,
                                                size: 40,
                                              ),
                                              SizedBox(height: 12),
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  "Rp. 100.000.000.000",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
