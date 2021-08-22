import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

  // Future<bool> addProductToWishlist({required Product product}) async {
  //   Uri url = Uri.parse(
  //       "http://localhost/e-commerce-flutter-app/User.php?addProductToWishlist=1&product=${product.toString()}&id-user=${this.idUser}");
  //   var result = await http.get(url);
  //   if (result.body == "true") {
  //     return true;
  //   }
  //   return false;
  // }

  Future<bool> logout() async {
    var session = await SharedPreferences.getInstance();
    var isLogout = await session.remove("user");
    return isLogout;
  }
}
