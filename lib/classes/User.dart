import 'dart:convert';

import 'package:ecommerce_apps/classes/Product.dart';
import 'package:http/http.dart' as http;

class User {
  late String fullName, password, email, imageProfile;
  late int idUser, balance;
  User({
    required this.fullName,
    required this.password,
    required this.email,
    required this.idUser,
    required this.balance,
    required this.imageProfile,
  });

  factory User.fromJson({required Map<String, dynamic> json}) {
    return User(
      fullName: json["full_name"],
      password: json["password"],
      email: json["email"],
      idUser:
          json["id_user"] is int ? json["id_user"] : int.parse(json["id_user"]),
      balance:
          json["balance"] is int ? json["balance"] : int.parse(json["balance"]),
      imageProfile: json["user_image"],
    );
  }

  String toString() {
    String jsonEncoder = jsonEncode({
      "full_name": this.fullName,
      "password": this.password,
      "email": this.email,
      "id_user": this.idUser,
      "balance": this.balance,
      "user_image": this.imageProfile,
    });
    return jsonEncoder;
  }

  Future<void> addProductToWhislist({required Product product}) async {
    // var result = await http.get("");
  }
}
