import 'dart:convert';

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
