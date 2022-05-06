import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel userModel) => json.encode(userModel.toJson());

class UserModel {
  late String uid, name, image, number, status, typing, online;

  UserModel({
    required this.uid,
    required this.name,
    required this.image,
    required this.number,
    required this.status,
    required this.typing,
    required this.online,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      uid: json["uid"],
      name: json["name"],
      image: json["image"],
      number: json["number"],
      status: json["status"],
      typing: json["typing"],
      online: json["online"]);

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "image": image,
    "number": number,
    "status": status,
    "typing": typing,
    "online": online,
  };
}
