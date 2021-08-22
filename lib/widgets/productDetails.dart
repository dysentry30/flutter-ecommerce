import 'package:ecommerce_apps/ColorTheme.dart';
import 'package:ecommerce_apps/classes/Product.dart';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:ecommerce_apps/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ProductDetails extends StatefulWidget {
  Product product;
  ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState(product: product);
}

class _ProductDetailsState extends State<ProductDetails> {
  String urlImage = "assets/images/television.jpg";
  Product product;

  _ProductDetailsState({required this.product});

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
            return WillPopScope(
              onWillPop: () => Navigator.pushNamedAndRemoveUntil(
                  context, "/", (route) => false).then((value) {
                setState(() {});
                return true;
              }),
              child: SafeArea(
                child: Scaffold(
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
                            onPressed: () {},
                            icon: Icon(
                              Icons.local_grocery_store,
                              color: Colors.white,
                            ),
                            label: Text(""),
                          ),
                          Container(
                            child: user == null
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
                  body: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      child: Container(
                        height: constraints.maxHeight,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageFullScreen(
                                          urlImage: product.productImage),
                                    ),
                                  ),
                                  child: Container(
                                    width: constraints.maxWidth,
                                    height: 230,
                                    child: Stack(
                                      children: [
                                        Hero(
                                          tag: "fullScreenImage",
                                          child: Container(
                                            width: constraints.maxWidth,
                                            child: Image(
                                              image: NetworkImage(
                                                  "${product.productImage}"),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 195,
                                          left: constraints.maxWidth - 40,
                                          child: Tooltip(
                                            preferBelow: false,
                                            message:
                                                "Tap on the image to see in full screen",
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Icon(
                                                FontAwesome5.exclamation_circle,
                                                semanticLabel:
                                                    "Exclamation Circle",
                                                color: ColorTheme.fifthColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: constraints.maxWidth - 30,
                                  margin: EdgeInsets.only(
                                      top: 20, left: 15, right: 15),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${product.nameProduct}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            width: constraints.maxWidth - 30,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  NumberFormat.currency(
                                                          decimalDigits: 0,
                                                          locale: "id",
                                                          symbol: "Rp. ")
                                                      .format(product.price),
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                                FutureBuilder(
                                                    future: product
                                                        .isProductWishlisted(
                                                            user.idUser),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return SpinKitCircle(
                                                          color: Colors.black,
                                                          size: 20,
                                                        );
                                                      } else {
                                                        var isProductExistInWishlist =
                                                            snapshot.data
                                                                as bool;
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            if (user == false) {
                                                              var snackBar =
                                                                  SnackBar(
                                                                content: Text(
                                                                    "Login terlebih dahulu sebelum melakukan whislist produk"),
                                                              );
                                                              Navigator
                                                                  .popAndPushNamed(
                                                                      context,
                                                                      "/login");
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackBar);
                                                              return;
                                                            }
                                                            if (!isProductExistInWishlist) {
                                                              var isAddedToWishlist =
                                                                  await product
                                                                      .addProductToWishlist(
                                                                          user:
                                                                              user);
                                                              var snackBar;
                                                              if (isAddedToWishlist) {
                                                                snackBar =
                                                                    SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1500),
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
                                                                snackBar =
                                                                    SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1500),
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
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackBar);
                                                            } else {
                                                              var isRemoveFromWishlistSuccess =
                                                                  await product
                                                                      .removeProductFromWishlist(
                                                                          user:
                                                                              user);

                                                              final snackBar;
                                                              if (isRemoveFromWishlistSuccess) {
                                                                snackBar =
                                                                    SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1500),
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
                                                                snackBar =
                                                                    SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1500),
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
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackBar);
                                                              // return;
                                                            }
                                                            setState(() {});
                                                            return;
                                                          },
                                                          child: Icon(
                                                            FontAwesome5.heart,
                                                            color: isProductExistInWishlist
                                                                ? ColorTheme
                                                                    .fourthColor
                                                                : ColorTheme
                                                                    .secondaryColor,
                                                          ),
                                                        );
                                                      }
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Divider(
                                  color: ColorTheme.secondaryColor,
                                  thickness: 5,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: constraints.maxWidth - 30,
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Informasi Produk",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      SubInformationProduct(
                                        title: "Kategori",
                                        value: product.category,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 5,
                                        color: ColorTheme.secondaryColor,
                                      ),
                                      SubInformationProduct(
                                        title: "Min. Pemesanan",
                                        value: "1",
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 5,
                                        color: ColorTheme.secondaryColor,
                                      ),
                                      Container(
                                        width: constraints.maxWidth - 30,
                                        // width: 150,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${product.description}",
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 5,
                                        color: ColorTheme.secondaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              // top: 590,
                              top: MediaQuery.of(context).size.height - 105,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                width: constraints.maxWidth,
                                height: 50,
                                color: ColorTheme.primaryColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                    AddToCartButton(
                                      user: user,
                                      product: product,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}

class AddToCartButton extends StatefulWidget {
  final User user;
  final Product product;
  const AddToCartButton({
    Key? key,
    required this.user,
    required this.product,
  }) : super(key: key);

  @override
  _AddToCartButtonState createState() =>
      _AddToCartButtonState(user: user, product: product);
}

class _AddToCartButtonState extends State<AddToCartButton> {
  final User user;
  final Product product;

  _AddToCartButtonState({required this.user, required this.product});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: product.isProductExistInCart(idUser: user.idUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TextButton(
            autofocus: false,
            clipBehavior: Clip.none,
            onPressed: () {},
            child: Center(
              child: SpinKitCircle(
                color: Colors.black,
                size: 25,
              ),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: ColorTheme.thirdColor,
                    width: 2,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(ColorTheme.thirdColor),
              foregroundColor:
                  MaterialStateProperty.all(ColorTheme.secondaryColor),
              fixedSize: MaterialStateProperty.all(
                Size(140, 35),
              ),
            ),
          );
        } else {
          // * check if "isProductExistInCart" not contains id cart
          final isProductExistInCart = snapshot.data;
          return TextButton.icon(
            onPressed: () async {
              var snackBar;
              // * if product not exist in cart table
              if (isProductExistInCart == false) {
                final dynamic isProductAddedToCart =
                    await product.addProductToCart(user: user);
                if (isProductAddedToCart) {
                  snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Row(children: [
                      Text(
                        product.nameProduct,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" berhasil dimasukan ke dalam keranjang"),
                    ]),
                  );
                } else {
                  snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Row(children: [
                      Text(
                        product.nameProduct,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" gagal dimasukan ke dalam keranjang"),
                    ]),
                  );
                }
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                setState(() {});
              } else {
                final int idCart = int.parse(isProductExistInCart.toString());
                var isRemoveProductFromCartSuccess = await product
                    .removeProductFromCart(user: user, idCart: idCart);
                if (isRemoveProductFromCartSuccess) {
                  snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Row(children: [
                      Text(
                        product.nameProduct,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" berhasil dihapus dari keranjang"),
                    ]),
                  );
                } else {
                  snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Row(children: [
                      Text(
                        product.nameProduct,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" gagal dihapus dari keranjang"),
                    ]),
                  );
                }
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                setState(() {});
              }
            },
            icon: Icon(
              isProductExistInCart == false
                  ? FontAwesome.cart_plus
                  : Icons.delete_forever,
              size: 20,
            ),
            label: Text(
              "Keranjang",
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: isProductExistInCart == false
                        ? ColorTheme.thirdColor
                        : ColorTheme.fourthColor,
                    width: 2,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  isProductExistInCart == false
                      ? ColorTheme.thirdColor
                      : ColorTheme.fourthColor),
              foregroundColor: MaterialStateProperty.all(
                  isProductExistInCart == false
                      ? ColorTheme.secondaryColor
                      : Colors.white),
              fixedSize: MaterialStateProperty.all(
                Size(140, 35),
              ),
            ),
          );
        }
      },
    );
  }
}

class SubInformationProduct extends StatelessWidget {
  final String title, value;
  const SubInformationProduct(
      {Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: constraints.maxWidth - 30,
      width: 150,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$title: ",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              Text(
                "$value",
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@immutable
class ImageFullScreen extends StatefulWidget {
  final String urlImage;
  ImageFullScreen({Key? key, required this.urlImage}) : super(key: key);
  @override
  _ImageFullScreenState createState() =>
      _ImageFullScreenState(urlImage: urlImage);
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  final String urlImage;

  _ImageFullScreenState({required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Hero(
          tag: "fullScreenImage",
          child: Image.network(urlImage),
        ),
      ),
    );
  }
}
