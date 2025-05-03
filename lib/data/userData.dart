import 'dart:convert';

class UserData {
  String name;
  String email;
  String phone;
  String gender;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
  });

  // fromJson method to convert JSON into UserData object
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
    );
  }

  // toJson method to convert UserData object into JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
    };
  }
}

/*
Example usage:

void main() {
  String jsonString = '''
  {
    "message": "Successful query",
    "data": [
        {
            "id": 280,
            "name": "diaa",
            "email": "aa@aa.com",
            "phone": "2222222",
            "gender": "male"
        }
    ],
    "status": true,
    "code": 200
  }
  ''';

  var jsonData = jsonDecode(jsonString);
  var userJson = jsonData['data'][0];
  UserData user = UserData.fromJson(userJson);
  String username = user.name;
  print('Username: $username');
  String jsonOutput = jsonEncode(user.toJson());
  print('Converted JSON: $jsonOutput');
}
*/
