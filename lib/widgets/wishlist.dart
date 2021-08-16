import 'dart:convert';

import 'package:ecommerce_apps/classes/Product.dart';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:ecommerce_apps/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  late User user;

  Future<List<dynamic>> getAllWishListProducts(int idUser) async {
    Uri url = Uri.parse(
        "http://192.168.100.100/e-commerce-flutter-app/Products.php?getAllWishlistProducts=1&id-user=$idUser");
    var response = await http.get(url);
    List<dynamic> allProducts = jsonDecode(response.body) as List<dynamic>;
    return allProducts;
  }

  // Future<bool> isProductWishlistExist({required int idProduct}) {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: Home().createState().getUserFromSession(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitCircle(
                size: 50,
                color: Colors.white,
              );
            } else {
              user = snapshot.data as User;
              return Scaffold(
                appBar: AppBar(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  title: SizedBox(
                    height: 30,
                    child: TextField(
                      cursorColor: Color(0xFFE9D985),
                      strutStyle: StrutStyle(height: 3, fontSize: 8),
                      onChanged: (String search) {},
                      enableInteractiveSelection: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9D985), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Cari Wishlist Kamu....",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        alignLabelWithHint: true,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  foregroundColor: Colors.white,
                  elevation: 5,
                  actions: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "/wishlist");
                          },
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
                        GestureDetector(
                          child: this.user == null
                              ? GestureDetector(
                                  child: Text("Login"),
                                  onTap: () => Navigator.popAndPushNamed(
                                      context, "/login"),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/userProfile");
                                  },
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: AssetImage(
                                        "assets/images/${user.imageProfile}"),
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    )
                  ],
                ),
                body: Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: FutureBuilder(
                          future: getAllWishListProducts(user.idUser),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SpinKitCircle(
                                color: Colors.white,
                                size: 50,
                              );
                            } else {
                              List<dynamic> products =
                                  snapshot.data as List<dynamic>;
                              return GridView.builder(
                                itemCount: products.length,
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 4 / 5,
                                ),
                                itemBuilder: (context, index) {
                                  Product product =
                                      Product.fromJson(json: products[index]);
                                  return Container(
                                    child: CardsProduct(
                                      product: product,
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
