class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? fssai;

  UserModel(
      {this.uid, this.email, this.firstName, this.secondName, this.fssai});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      fssai: map['fssai'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'fssai': fssai,
    };
  }
}
