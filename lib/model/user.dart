import 'package:firebase_auth/firebase_auth.dart';

class Users {
  String uid;
  String email;
  String username;
  String profilePhoto;
  List<Map> patients;

  Users(
      {this.uid, this.email, this.username, this.profilePhoto, this.patients});

  Map toMap(Users user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['username'] = user.username;
    data["profile_photo"] = user.profilePhoto;
    data["patients"] = user.patients;
    return data;
  }

  Users fromUser(User firebaseUser) {
    Users user = new Users(
      email: firebaseUser.email,
      uid: firebaseUser.uid,
      profilePhoto: firebaseUser.photoURL,
      username: firebaseUser.displayName,
    );
    return user;
  }

  Users.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.profilePhoto = mapData['profile_photo'];
    this.patients = List.from(mapData['patients']);
  }
}
