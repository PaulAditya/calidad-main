import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Users _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  Users get getUser => _user;

  void refreshUser() async {
    Users user = await _firebaseRepository.getCurrentUser();
    _user = user;
    notifyListeners();
  }

  void updateUser(Users user) async {
    _user = user;
    notifyListeners();
  }
}
