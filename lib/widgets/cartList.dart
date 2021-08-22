import 'dart:async';
import 'dart:convert';

import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:ecommerce_apps/classes/Product.dart';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:ecommerce_apps/widgets/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CartList extends StatefulWidget {
  final User user;
  const CartList({Key? key, required this.user}) : super(key: key);

  @override
  _CartListState createState() => _CartListState(user: user);
}

class _CartListState extends State<CartList> {
  User user;
  late List<dynamic> products;
  late int totalPrice;
  TextEditingController _textEditingController = TextEditingController();
  StreamController _streamController = StreamController();
  _CartListState({required this.user});

  Future<List<dynamic>> getAllProductsFromCart({required int idUser}) async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/Products.php?getAllProductsFromCart=1&id-user=$idUser");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      products = jsonDecode(response.body) as List<dynamic>;
    }
    _streamController.add(products);
    return products;
  }

  updateParent() {
    setState(() {});
  }

  // Stream<List<dynamic>> getAllProductsFromCartStream(
  //     {required int idUser}) async* {
  //   Uri url = Uri.parse(
  //       "http://bagassatria-ecommerce.orgfree.com/Products.php?getAllProductsFromCart=1&id-user=$idUser");
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     products = jsonDecode(response.body) as List<dynamic>;
  //   }
  //   yield products;
  // }

  Stream<int> getTotalPriceProducts({required int idUser}) async* {
    while (true) {
      int totalPrice = 0;
      List<dynamic> products = await getAllProductsFromCart(idUser: idUser);
      products.forEach((product) {
        totalPrice +=
            int.parse(product["price"]) * int.parse(product["item_quantity"]);
      });
      yield totalPrice;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _streamController.stream.listen((event) => print(event));
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          title: Text(
            "Keranjang",
            style: TextStyle(fontSize: 15),
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
                GestureDetector(
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
        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  // future: getAllProductsFromCart(idUser: user.idUser),
                  stream: Stream.fromFuture(
                      getAllProductsFromCart(idUser: user.idUser)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SpinKitCircle(
                        color: Colors.white,
                        size: 50,
                      );
                    } else {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  "Maaf, keranjang anda kosong. Silahkan pilih product yang anda mau beli",
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
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                              Size(double.infinity, 40)),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        ColorTheme.fifthColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        List<dynamic> products = snapshot.data as List<dynamic>;
                        return WillPopScope(
                          onWillPop: () async {
                            Navigator.pushNamedAndRemoveUntil(
                                    context, "/", (route) => false)
                                .then((value) => setState(() {}));
                            return true;
                          },
                          child: Stack(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                child: ListView.builder(
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    Product cartProduct =
                                        Product.fromJson(json: products[index]);
                                    // totalPrice.then((value) => print(value));
                                    return CardViewProduct(
                                      updateParent: updateParent,
                                      idCart:
                                          int.parse(products[index]["id_cart"]),
                                      user: user,
                                      product: cartProduct,
                                      itemQuantity: int.parse(
                                        products[index]["item_quantity"],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                // left: -45,
                                top: MediaQuery.of(context).size.height - 105,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  color: ColorTheme.primaryColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Total: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            StreamBuilder(
                                              stream: CartList(
                                                user: user,
                                              )
                                                  .createState()
                                                  .getTotalPriceProducts(
                                                      idUser: user.idUser),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SpinKitCircle(
                                                    color: Colors.white,
                                                    size: 25,
                                                  );
                                                } else {
                                                  return Text(
                                                    NumberFormat.currency(
                                                            locale: "id",
                                                            symbol: "Rp. ",
                                                            decimalDigits: 0)
                                                        .format(snapshot.data),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                }
                                              },
                                            ),
                                          ]),
                                      TextButton.icon(
                                        onPressed: () {
                                          print("test");
                                        },
                                        icon: Icon(
                                          FontAwesome5.dollar_sign,
                                          size: 20,
                                        ),
                                        label: Text(
                                          "Langsung Beli",
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                color: ColorTheme.thirdColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  ColorTheme.secondaryColor),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  ColorTheme.thirdColor),
                                          fixedSize: MaterialStateProperty.all(
                                            Size(140, 35),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class CardViewProduct extends StatefulWidget {
  final User user;
  final Product product;
  final int itemQuantity;
  final int idCart;
  final updateParent;
  const CardViewProduct({
    Key? key,
    required this.user,
    required this.product,
    required this.itemQuantity,
    required this.idCart,
    required this.updateParent,
  }) : super(key: key);

  @override
  _CardViewProductState createState() => _CardViewProductState(
      user: user,
      product: product,
      itemQuantity: itemQuantity,
      idCart: idCart,
      updateParent: updateParent);
}

class _CardViewProductState extends State<CardViewProduct> {
  final User user;
  final Product product;
  final int idCart;
  final updateParent;
  int itemQuantity;
  TextEditingController _quantityTextInputController = TextEditingController();
  _CardViewProductState({
    required this.user,
    required this.product,
    required this.itemQuantity,
    required this.idCart,
    required this.updateParent,
  });

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> setItemQuantity(
      {required int idUser, required int idCart, required int value}) async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/Products.php?setItemQuantityInCart=1&id-user=$idUser&id-cart=$idCart&item-quantity=$value");
    var response = await http.get(url);
    if (response.statusCode == 200 && response.body == "true") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isProductExistInWishlist;
    bool isRemovingItem = false;
    _quantityTextInputController.text = itemQuantity.toString();
    int price = product.price * itemQuantity;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(product: product),
            ),
          );
        },
        title: LayoutBuilder(
          builder: (context, constraints) => Container(
            constraints: constraints,
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 100,
                  child: Image(
                    image: NetworkImage(
                      product.productImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 21,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.nameProduct,
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      NumberFormat.currency(
                        decimalDigits: 0,
                        name: "id",
                        symbol: "Rp. ",
                        locale: "id",
                      ).format(price),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      width: constraints.maxWidth - 71,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: product.isProductWishlisted(user.idUser),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SpinKitCircle(
                                  size: 25,
                                  color: Colors.white,
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
                                      var isAddedToWishlist = await product
                                          .addProductToWishlist(user: user);
                                      var snackBar;
                                      if (isAddedToWishlist) {
                                        snackBar = SnackBar(
                                          duration:
                                              Duration(milliseconds: 1500),
                                          content: Row(
                                            children: [
                                              Text(
                                                "${product.nameProduct}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  " sudah dimasukan ke whislist"),
                                            ],
                                          ),
                                        );
                                      } else {
                                        snackBar = SnackBar(
                                          duration:
                                              Duration(milliseconds: 1500),
                                          content: Row(
                                            children: [
                                              Text(
                                                "${product.nameProduct}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  " gagal dimasukan ke whislist"),
                                            ],
                                          ),
                                        );
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      updateParent();
                                      setState(() {});
                                    } else {
                                      var isRemoveFromWishlistSuccess =
                                          await product
                                              .removeProductFromWishlist(
                                                  user: user);

                                      final snackBar;
                                      if (isRemoveFromWishlistSuccess) {
                                        snackBar = SnackBar(
                                          duration:
                                              Duration(milliseconds: 1500),
                                          content: Row(
                                            children: [
                                              Text(
                                                "${product.nameProduct}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  " berhasil dihapus dari whislist"),
                                            ],
                                          ),
                                        );
                                      } else {
                                        snackBar = SnackBar(
                                          duration:
                                              Duration(milliseconds: 1500),
                                          content: Row(
                                            children: [
                                              Text(
                                                "${product.nameProduct}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                  },
                                  child: Icon(
                                    FontAwesome5.heart,
                                    color: isProductExistInWishlist
                                        ? ColorTheme.fourthColor
                                        : ColorTheme.secondaryColor,
                                  ),
                                );
                              }
                            },
                          ),
                          Container(
                            child: Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () async {
                                    if (itemQuantity < 2) {
                                      var alertDialog = StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text(
                                              "Apakah anda mau menghapus ${product.nameProduct}"),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                isRemovingItem = true;
                                                setState(() {});
                                                await product
                                                    .removeProductFromCart(
                                                        user: user,
                                                        idCart: idCart);
                                                isRemovingItem = false;
                                                setState(() {});
                                                Navigator.pop(context);
                                                updateParent();
                                              },
                                              child: isRemovingItem
                                                  ? Container(
                                                      width: 50,
                                                      child: SpinKitCircle(
                                                          size: 20,
                                                          color: Colors.white),
                                                    )
                                                  : Text("Yes"),
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        ColorTheme.thirdColor),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    side: BorderSide(
                                                        color: ColorTheme
                                                            .thirdColor,
                                                        width: 2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("No"),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        ColorTheme.fifthColor),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (_) => alertDialog);
                                      return null;
                                    }
                                    itemQuantity--;
                                    // var snackBar;
                                    bool isItemQuantitySet =
                                        await setItemQuantity(
                                            idUser: user.idUser,
                                            idCart: idCart,
                                            value: itemQuantity);
                                    // if (isItemQuantitySet) {
                                    //   snackBar = SnackBar(
                                    //       duration: Duration(seconds: 2),
                                    //       content: Text(
                                    //           "Jumlah item berhasil dikurangi"));
                                    // } else {
                                    //   snackBar = SnackBar(
                                    //       duration: Duration(seconds: 2),
                                    //       content: Text(
                                    //           "Jumlah item gagal dikurangi"));
                                    // }
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                    setState(() {});
                                  },
                                  icon: Icon(FontAwesome.left_circled),
                                  label: Text(""),
                                ),
                                Container(
                                  width: 50,
                                  height: 30,
                                  child: TextField(
                                    readOnly: true,
                                    textInputAction: TextInputAction.done,
                                    controller: _quantityTextInputController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: ColorTheme.thirdColor,
                                    style: TextStyle(
                                        color: ColorTheme.primaryColor),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 5,
                                        left: 5,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorTheme.thirdColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () async {
                                    itemQuantity++;
                                    // var snackBar;
                                    bool isItemQuantitySet =
                                        await setItemQuantity(
                                            idUser: user.idUser,
                                            idCart: idCart,
                                            value: itemQuantity);
                                    // if (isItemQuantitySet) {
                                    //   snackBar = SnackBar(
                                    //       duration: Duration(seconds: 2),
                                    //       content: Text(
                                    //           "Jumlah item berhasil ditambah"));
                                    // } else {
                                    //   snackBar = SnackBar(
                                    //       duration: Duration(seconds: 2),
                                    //       content: Text(
                                    //           "Jumlah item gagal ditambah"));
                                    // }
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);

                                    setState(() {});
                                  },
                                  icon: Icon(FontAwesome.right_circled),
                                  label: Text(""),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
