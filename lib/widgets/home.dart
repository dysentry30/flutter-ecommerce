import 'dart:convert';

import 'package:ecommerce_apps/classes/Product.dart';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:ecommerce_apps/widgets/cartList.dart';
import 'package:ecommerce_apps/widgets/categoryList.dart';
import 'package:ecommerce_apps/widgets/productDetails.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences session;
  dynamic user;
  bool isWaitingForUser = true;

  Future<dynamic> getUserFromSession() async {
    session = await SharedPreferences.getInstance();
    var data = session.getString("user") ?? false;
    if (data == false) {
      return data;
    }
    var json = jsonDecode(data as String);
    dynamic user = User.fromJson(json: json);
    return user;
  }

  @override
  void initState() {
    super.initState();
    getUserFromSession().then((value) {
      if (value == false) {
        isWaitingForUser = false;
        setState(() {});
        return this.user = null as User;
      }
      this.user = value;
      isWaitingForUser = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isWaitingForUser
        ? SpinKitCircle(
            color: ColorTheme.primaryColor,
            size: 50,
            duration: Duration(seconds: 1),
          )
        : Scaffold(
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              title: SizedBox(
                height: 30,
                child: TextField(
                  cursorColor: Color(0xFFE9D985),
                  strutStyle: StrutStyle(height: 4, fontSize: 8),
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
                    hintText: "Cari Produk....",
                    hintStyle: TextStyle(color: Colors.grey),
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
                        Navigator.pushNamed(context, "/wishlist");
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      label: Text(""),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartList(user: user)));
                      },
                      icon: Icon(
                        Icons.local_grocery_store,
                        color: Colors.white,
                      ),
                      label: Text(""),
                    ),
                    Container(
                      child: this.user == null
                          ? GestureDetector(
                              child: Text("Login"),
                              onTap: () =>
                                  Navigator.popAndPushNamed(context, "/login"),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/userProfile");
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
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Start Top Categories
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: ColorTheme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Top Categories",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 1,
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      categoriesWidget("Elektronik", Icons.tv),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ! END TOP CATEGORIES

                    SizedBox(
                      height: 15,
                    ),
                    // * START CONTENT PRODUCT
                    ProductCard(
                      category: "a",
                    ),
                    ProductCard(
                      category: "b",
                    ),
                    ProductCard(
                      category: "c",
                    ),
                    ProductCard(
                      category: "d",
                    ),

                    // ! END CONTENT PRODUCT
                  ],
                ),
              ),
            ),
          );
  }

  TextButton categoriesWidget(String title, IconData icons) {
    return TextButton(
      onPressed: () {},
      child: Column(
        children: [
          Container(
            child: Icon(
              icons,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ColorTheme.secondaryColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  String category;
  ProductCard({
    Key? key,
    this.category = "",
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  final double gap = 50;

  final double heightCardProduct = 200;
  final double widthCardProduct = 200;

  final double heightContainerProduct = 185;

  Future<List<dynamic>> readJsonProducts() async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/Products.php?getAllProductsByCategory=1&category=${this.widget.category}");
    final response = await http.get(url);
    final dataProducts = jsonDecode(response.body) as List<dynamic>;
    return dataProducts;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget loading() {
    return Shimmer.fromColors(
      baseColor: ColorTheme.secondaryColor,
      highlightColor: ColorTheme.primaryColor,
      child: Container(
        height: heightCardProduct,
        width: widthCardProduct,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorTheme.secondaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.loose,
      children: [
        Container(
          height: heightContainerProduct,
          margin: EdgeInsets.only(
              bottom: (heightCardProduct - (heightCardProduct - 25)) + gap),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
            color: ColorTheme.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Positioned(
          top: 40,
          left: 25,
          child: FutureBuilder(
            future: readJsonProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loading();
              } else {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Produk tidak ditemukan"),
                    ),
                  );
                } else {
                  List<dynamic> products = snapshot.data as List<dynamic>;
                  return Container(
                    height: heightCardProduct + 15,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 8 / 7,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Product product =
                            Product.fromJson(json: products[index]);
                        return CardsProduct(
                          product: product,
                        );
                      },
                    ),
                  );
                }
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              bottom: (heightCardProduct - (heightCardProduct - 25)) + gap),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.widget.category,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryList(
                        category: this.widget.category,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.thirdColor),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

@immutable
class CardsProduct extends StatefulWidget {
  Product product;
  CardsProduct({
    Key? key,
    required this.product,
  }) : super(key: key);
  @override
  _CardsProductState createState() => _CardsProductState(
        product: product,
      );
}

class _CardsProductState extends State<CardsProduct> {
  Product product;
  late dynamic user;
  bool isProductExistInWishlist = false;
  _CardsProductState({
    required this.product,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProductDetails(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, BoxConstraints constraint) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: NetworkImage(product.productImage),
                    height: 126,
                    width: constraint.maxWidth,
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          product.nameProduct,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: FutureBuilder(
                            future: Home().createState().getUserFromSession(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SpinKitCircle(
                                  color: ColorTheme.secondaryColor,
                                  size: 20,
                                );
                              } else {
                                user = snapshot.data as User;
                                return FutureBuilder(
                                    future: product
                                        .isProductWishlisted(user.idUser),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SpinKitCircle(
                                          color: Colors.black,
                                          size: 20,
                                        );
                                      } else {
                                        isProductExistInWishlist =
                                            snapshot.data as bool;
                                        return GestureDetector(
                                          onTap: () async {
                                            if (user == false) {
                                              var snackBar = SnackBar(
                                                content: Text(
                                                    "Login terlebih dahulu sebelum melakukan whislist produk"),
                                              );
                                              Navigator.popAndPushNamed(
                                                  context, "/login");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              return;
                                            }
                                            if (!isProductExistInWishlist) {
                                              var isAddedToWishlist =
                                                  await product
                                                      .addProductToWishlist(
                                                          user: user);
                                              var snackBar;
                                              if (isAddedToWishlist) {
                                                snackBar = SnackBar(
                                                  duration: Duration(
                                                      milliseconds: 1500),
                                                  content: Row(
                                                    children: [
                                                      Text(
                                                        "${product.nameProduct}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          " sudah dimasukan ke whislist"),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                snackBar = SnackBar(
                                                  duration: Duration(
                                                      milliseconds: 1500),
                                                  content: Row(
                                                    children: [
                                                      Text(
                                                        "${product.nameProduct}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          " gagal dimasukan ke whislist"),
                                                    ],
                                                  ),
                                                );
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              var isRemoveFromWishlistSuccess =
                                                  await product
                                                      .removeProductFromWishlist(
                                                          user: user);

                                              final snackBar;
                                              if (isRemoveFromWishlistSuccess) {
                                                snackBar = SnackBar(
                                                  duration: Duration(
                                                      milliseconds: 1500),
                                                  content: Row(
                                                    children: [
                                                      Text(
                                                        "${product.nameProduct}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          " berhasil dihapus dari whislist"),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                snackBar = SnackBar(
                                                  duration: Duration(
                                                      milliseconds: 1500),
                                                  content: Row(
                                                    children: [
                                                      Text(
                                                        "${product.nameProduct}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          " gagal dihapus dari whislist"),
                                                    ],
                                                  ),
                                                );
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              // return;
                                            }
                                            setState(() {});
                                            return;
                                          },
                                          child: Icon(
                                            FontAwesome5.heart,
                                            color: isProductExistInWishlist
                                                ? ColorTheme.fourthColor
                                                : ColorTheme.secondaryColor,
                                          ),
                                        );
                                      }
                                    });
                              }
                            }),
                      ),
                    ],
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: "id", decimalDigits: 0, symbol: "Rp ")
                        .format(product.price),
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
