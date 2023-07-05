import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? username;
  String? email;
  String? photo;
  String? password;

  UserModel({this.name, this.username, this.email, this.photo, this.password});

  UserModel.fromJson(DocumentSnapshot json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    photo = json['photo'];
    password = json['password'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['password'] = this.password ?? "";
    return data;
  }
}
