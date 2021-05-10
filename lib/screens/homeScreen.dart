import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/screens/homePage.dart';
import 'package:calidad_app/screens/loginScreen.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseRepository repo = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: FutureBuilder(future: repo.getCurrentUser(),
        builder: (context, AsyncSnapshot<Users> snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return LoginScreen();
              }
            },),
      ),
    );
  }
}