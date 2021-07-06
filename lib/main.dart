import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/screens/landingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Calidad',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: LandingScreen()));
  }
}
