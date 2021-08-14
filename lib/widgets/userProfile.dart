import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:ecommerce_apps/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Home().createState().getUserFromSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitCircle(
              size: 50,
              color: Colors.white,
            );
          } else {
            User user = snapshot.data as User;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  title: Text(
                    "Akun Saya",
                    style: TextStyle(fontSize: 15),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: ColorTheme.primaryColor,
                  elevation: 5,
                  actions: [
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                          label: Text(""),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.local_grocery_store,
                            color: Colors.white,
                          ),
                          label: Text(""),
                        ),
                      ],
                    )
                  ],
                ),
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
                                        backgroundImage: AssetImage(
                                            "assets/images/${user.imageProfile}"),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${user.fullName}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${user.email}",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
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
                                        "Daftar Transaksi",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
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
                                                  onTap: () => print(
                                                      "Transaksi Berlangsung"),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 15),
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          FontAwesome5
                                                              .cart_arrow_down,
                                                          color: ColorTheme
                                                              .thirdColor,
                                                          size: 40,
                                                        ),
                                                        SizedBox(height: 12),
                                                        Container(
                                                          width: 80,
                                                          child: Text(
                                                            "Transaksi Berlangsung",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                  onTap: () =>
                                                      print("Semua Transaksi"),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 15),
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          FontAwesome5.history,
                                                          color: ColorTheme
                                                              .thirdColor,
                                                          size: 40,
                                                        ),
                                                        SizedBox(height: 12),
                                                        Container(
                                                          width: 80,
                                                          child: Text(
                                                            "Riwayat Semua Transaksi",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
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
                                                      vertical: 10,
                                                      horizontal: 15),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        FontAwesome.money,
                                                        color: ColorTheme
                                                            .thirdColor,
                                                        size: 40,
                                                      ),
                                                      SizedBox(height: 12),
                                                      Container(
                                                        width: 200,
                                                        child: Text(
                                                          NumberFormat.currency(
                                                                  symbol:
                                                                      "Rp. ",
                                                                  name: "id",
                                                                  decimalDigits:
                                                                      0)
                                                              .format(
                                                                  user.balance),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
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
        });
  }
}
