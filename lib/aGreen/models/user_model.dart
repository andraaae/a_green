import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  int? id;
 final String? username;
  final String? email;
  final String? password;
 final String? phone;
 final String? address;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.phone,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
