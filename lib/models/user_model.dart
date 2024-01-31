class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? userName;
  String? profession;
  String? gender;
  int? age;
  String? bio;
  String? profileImage;








  UserModel({this.uid, this.email, this.firstName,  this.userName});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      userName:map['userName'],


    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': firstName,
      'username':userName,

    };
  }
}

