import 'dart:convert';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:http/http.dart' as http;

class Product {
  late String nameProduct, category, productImage;
  late int id, price, quantity;

  Product({
    required this.id,
    required this.nameProduct,
    required this.category,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson({required Map<String, dynamic> json}) {
    return Product(
      id: json["id"] is int ? json["id"] : int.parse(json["id"]),
      nameProduct: json["name_product"],
      category: json["category"],
      price: json["price"] is int ? json["price"] : int.parse(json["price"]),
      quantity: json["quantity"] is int
          ? json["quantity"]
          : int.parse(json["quantity"]),
      productImage: json["product_image"],
    );
  }

  // factory Product.getAll() {
  //   Uri url = Uri.parse(
  //       "http://192.168.100.100/e-commerce-flutter-app/Products.php?getAllProducts=1");
  //   var response = http.get(url);
  //   response.then((value) {
  //     print(value);
  //     return Product(
  //       id: value["id"] is int ? value["id"] : int.parse(value["id"]),
  //       nameProduct: value["name_product"],
  //       category: value["category"],
  //       price:
  //           value["price"] is int ? value["price"] : int.parse(value["price"]),
  //       quantity: value["quantity"] is int
  //           ? value["quantity"]
  //           : int.parse(value["quantity"]),
  //       productImage: value["product_image"],
  //     );
  //   });
  // }

  Future<bool> isProductWishlisted(int idUser) async {
    Uri url = Uri.parse(
        "http://localhost/e-commerce-flutter-app/Products.php?isProductWishlisted=1&id-product=${this.id}&id-user=$idUser");
    var response = await http.get(url);
    if (response.body == "true") {
      return true;
    }
    return false;
  }

  Future<bool> addProductToWishlist({required User user}) async {
    Uri url = Uri.parse(
        "http://localhost/e-commerce-flutter-app/User.php?addProductToWishlist=1&product=${this.toString()}&id-user=${user.idUser}");
    var result = await http.get(url);
    if (result.body == "true") {
      return true;
    }
    return false;
  }

  Future<bool> removeProductFromWishlist({required User user}) async {
    Uri url = Uri.parse(
        "http://localhost/e-commerce-flutter-app/User.php?removeProductFromWishlist=1&id-product=${this.id}&id-user=${user.idUser}");
    var result = await http.get(url);
    if (result.body == "true") {
      return true;
    }
    return false;
  }

  String toString() {
    String jsonEncoder = jsonEncode({
      "id": this.id,
      "name_product": this.nameProduct,
      "category": this.category,
      "price": this.price,
      "quantity": this.quantity,
      "product_image": this.productImage,
    });
    return jsonEncoder;
  }
}
