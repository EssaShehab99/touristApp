import '/data/utils/enum.dart';

class User {
  int? id;
  String? name;
  String email;
  String? phone;
  int? age;
  String password;

  User(
      {this.id,
      this.name,
      required this.email,
       this.phone,
       this.age,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      age: json["age"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "age": age,
      "password": password,
    };
  }
//

}
