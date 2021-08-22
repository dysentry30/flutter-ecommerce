import 'dart:convert';

import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:ecommerce_apps/classes/Product.dart';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:ecommerce_apps/widgets/home.dart';
import 'package:ecommerce_apps/widgets/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  late User user;

  Future<List<dynamic>> getAllWishListProducts(int idUser) async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/Products.php?getAllWishlistProducts=1&id-user=$idUser");
    var response = await http.get(url);
    List<dynamic> allProducts = jsonDecode(response.body) as List<dynamic>;
    return allProducts;
  }

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
                              if (!snapshot.hasData) {
                                return Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                            "assets/images/empty.jpg",
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Maaf, Wishlist anda kosong. Silahkan pilih product yang anda sukai",
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: TextButton.icon(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.arrow_back),
                                            label: Text("Kembali"),
                                            style: ButtonStyle(
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size(
                                                      double.infinity, 40)),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                ColorTheme.fifthColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                                // return SvgPicture.network(
                                //     "https://mightymamma.com/wp-content/uploads/2019/03/Tink-Happy-Thoughts.svg");
                              } else {
                                List<dynamic> products =
                                    snapshot.data as List<dynamic>;
                                bool isProductExistInWishlist;
                                return WillPopScope(
                                  onWillPop: () async {
                                    Navigator.pushNamedAndRemoveUntil(
                                            context, "/", (route) => false)
                                        .then((value) => setState(() {}));
                                    return true;
                                  },
                                  child: ListView.builder(
                                    // itemExtent: 50,
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      Product wishlistProduct =
                                          Product.fromJson(
                                              json: products[index]);
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: ListTile(
                                          onTap: () {},
                                          title: LayoutBuilder(
                                            builder: (context, constraints) =>
                                                Container(
                                              constraints: constraints,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 100,
                                                    child: Image(
                                                      image: NetworkImage(
                                                        wishlistProduct
                                                            .productImage,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 21,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        wishlistProduct
                                                            .nameProduct,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        NumberFormat.currency(
                                                          decimalDigits: 0,
                                                          name: "id",
                                                          symbol: "Rp. ",
                                                          locale: "id",
                                                        ).format(wishlistProduct
                                                            .price),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 35,
                                                      ),
                                                      Container(
                                                        width: constraints
                                                                .maxWidth -
                                                            71,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            FutureBuilder(
                                                              future: wishlistProduct
                                                                  .isProductWishlisted(
                                                                      user.idUser),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return SpinKitCircle(
                                                                    size: 25,
                                                                    color: Colors
                                                                        .white,
                                                                  );
                                                                } else {
                                                                  isProductExistInWishlist =
                                                                      snapshot.data
                                                                          as bool;
                                                                  return GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (user ==
                                                                          false) {
                                                                        var snackBar =
                                                                            SnackBar(
                                                                          content:
                                                                              Text("Login terlebih dahulu sebelum melakukan whislist produk"),
                                                                        );
                                                                        Navigator.popAndPushNamed(
                                                                            context,
                                                                            "/login");
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(snackBar);
                                                                        return;
                                                                      }
                                                                      if (!isProductExistInWishlist) {
                                                                        var isAddedToWishlist =
                                                                            await wishlistProduct.addProductToWishlist(user: user);
                                                                        var snackBar;
                                                                        if (isAddedToWishlist) {
                                                                          snackBar =
                                                                              SnackBar(
                                                                            duration:
                                                                                Duration(milliseconds: 1500),
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${wishlistProduct.nameProduct}",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(" sudah dimasukan ke whislist"),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          snackBar =
                                                                              SnackBar(
                                                                            duration:
                                                                                Duration(milliseconds: 1500),
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${wishlistProduct.nameProduct}",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(" gagal dimasukan ke whislist"),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(snackBar);
                                                                      } else {
                                                                        var isRemoveFromWishlistSuccess =
                                                                            await wishlistProduct.removeProductFromWishlist(user: user);

                                                                        final snackBar;
                                                                        if (isRemoveFromWishlistSuccess) {
                                                                          snackBar =
                                                                              SnackBar(
                                                                            duration:
                                                                                Duration(milliseconds: 1500),
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${wishlistProduct.nameProduct}",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(" berhasil dihapus dari whislist"),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          snackBar =
                                                                              SnackBar(
                                                                            duration:
                                                                                Duration(milliseconds: 1500),
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${wishlistProduct.nameProduct}",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(" gagal dihapus dari whislist"),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(snackBar);
                                                                        // return;
                                                                      }
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child: Icon(
                                                                      FontAwesome5
                                                                          .heart,
                                                                      color: isProductExistInWishlist
                                                                          ? ColorTheme
                                                                              .fourthColor
                                                                          : ColorTheme
                                                                              .secondaryColor,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                            AddToCartButton(
                                                              user: user,
                                                              product:
                                                                  wishlistProduct,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
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
