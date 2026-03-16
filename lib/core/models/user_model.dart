import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uId;
  final String? email;
  final String? name;
  final String? phone;
  final String? image;

  const UserModel({this.uId, this.email, this.name, this.phone, this.image});
  //from firebase
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uId: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      phone: user.phoneNumber ?? '',
      image: user.photoURL ?? '',
    );
  }
  //from secure storage
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
    );
  }

  //to store in secure storage
  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
      'phone': phone,
      'image': image,
    };
  }
}
