import 'dart:convert';
import 'package:ecommerce_apps/classes/User.dart';
import 'package:http/http.dart' as http;

class Product {
  late String nameProduct, category, productImage, description;
  late int id, price, quantity;

  Product(
      {required this.id,
      required this.nameProduct,
      required this.category,
      required this.productImage,
      required this.price,
      required this.quantity,
      required this.description});

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
      description: json["description"] == null
          ? "Tidak ada deskripsi di produk ini"
          : json["description"],
    );
  }

  // factory Product.getAll() {
  //   Uri url = Uri.parse(
  //       "http://bagassatria-ecommerce.orgfree.com/Products.php?getAllProducts=1");
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
        "http://bagassatria-ecommerce.orgfree.com/Products.php?isProductWishlisted=1&id-product=${this.id}&id-user=$idUser");
    var response = await http.get(url);
    if (response.body == "true") {
      return true;
    }
    return false;
  }

  Future<bool> addProductToWishlist({required User user}) async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/Products.php?addProductToWishlist=1&product=${this.toString()}&id-user=${user.idUser}");
    var result = await http.get(url);
    if (result.body == "true") {
      return true;
    }
    return false;
  }

  Future<bool> removeProductFromWishlist({required User user}) async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/User.php?removeProductFromWishlist=1&id-product=${this.id}&id-user=${user.idUser}");
    var result = await http.get(url);
    if (result.body == "true") {
      return true;
    }
    return false;
  }

  Future<bool> addProductToCart({required User user}) async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/Products.php?addProductToCart=1&id-user=${user.idUser}&id-product=${this.id}");
    var result = await http.get(url);
    if (result.body == "true") {
      return true;
    }
    return false;
  }

  Future<bool> removeProductFromCart(
      {required User user, required int idCart}) async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/Products.php?removeProductFromCart=1&id-user=${user.idUser}&id-cart=${idCart}");
    var result = await http.get(url);
    if (result.body == "true") {
      return true;
    }
    return false;
  }

  Future<dynamic> isProductExistInCart({required int idUser}) async {
    Uri url = Uri.parse(
        "http://bagassatria-ecommerce.orgfree.com/Products.php?isProductExistInCart=1&id-user=$idUser&id-product=${this.id}");
    var response = await http.get(url);
    if (response.statusCode == 200 && response.body != "false") {
      return response.body;
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
      "description": this.description
    });
    return jsonEncoder;
  }
}
