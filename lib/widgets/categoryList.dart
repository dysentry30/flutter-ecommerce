import 'dart:convert';

import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:ecommerce_apps/classes/Product.dart';
import 'package:ecommerce_apps/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class CategoryList extends StatefulWidget {
  String category;

  CategoryList({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  dynamic user;
  Future<List<dynamic>> readJsonProducts() async {
    Uri url = Uri.parse(
        "http://192.168.100.100/e-commerce-flutter-app/Products.php?getAllProductsByCategory=1&category=${this.widget.category}");
    final response = await http.get(url);
    final dataProducts = jsonDecode(response.body) as List<dynamic>;
    return dataProducts;
  }

  Widget loading() {
    return Shimmer.fromColors(
      baseColor: ColorTheme.secondaryColor,
      highlightColor: ColorTheme.primaryColor,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 30,
        itemBuilder: (context, _) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorTheme.secondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Home().createState().getUserFromSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitCircle(
              color: Colors.white,
              size: 50,
            );
          } else {
            user = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                title: Text(this.widget.category),
                foregroundColor: Colors.white,
                elevation: 5,
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/userProfile");
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              AssetImage("assets/images/${user.imageProfile}"),
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
                        future: readJsonProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loading();
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
        });
  }
}
