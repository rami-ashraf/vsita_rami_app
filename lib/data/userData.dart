import 'dart:convert';

class UserData {
  int? id; // optional field
  String name;
  String email;
  String phone;
  String gender;

  UserData({
    this.id, // not required
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
  });

  // fromJson method to convert JSON into UserData object
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'], // may be null
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
    );
  }

  // toJson method to convert UserData object into JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // include id only if it's not null
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
    };
  }
}
