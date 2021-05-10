import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/screens/homePage.dart';
import 'package:calidad_app/screens/signUpScreen.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    final FirebaseRepository repo = FirebaseRepository();
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding:
                              EdgeInsets.only(left: 10, top: height * 0.08),
                          child: Text(
                            'Hello',
                            style: GoogleFonts.montserrat(
                              fontSize: height * 0.1,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: RichText(
                            text: TextSpan(
                                text: 'There',
                                style: GoogleFonts.montserrat(
                                  fontSize: height * 0.1,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                          fontSize: height * 0.1,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[900]))
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _email,
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Required*"),
                              EmailValidator(
                                  errorText: "Enter a valid email address")
                            ]),
                            decoration: InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue[900]))),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _password,
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Required*"),
                              MinLengthValidator(6,
                                  errorText: "Minimum length should be 6")
                            ]),
                            decoration: InputDecoration(
                                labelText: 'PASSWORD',
                                labelStyle: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue[900]))),
                            obscureText: true,
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(top: 15.0, left: 20.0),
                            child: InkWell(
                              child: Text(
                                'Forgot Password',
                                style: GoogleFonts.montserrat(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          GestureDetector(
                            onTap: () async {
                              if (_formkey.currentState.validate()) {
                                try {
                                  Users user = await repo.signInWithEmailPass(
                                      _email.text, _password.text);
                                  if (user != null) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            child: Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.blueAccent,
                                color: Colors.blue[900],
                                elevation: 7.0,
                                child: Center(
                                  child: Text(
                                    'LOGIN',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.blueAccent,
                              color: Colors.blue[900],
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () async {
                                  Users user = await _googleSignIn();
                                  if (user != null) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    'Sign-in with Google',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'New User ?',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ));
                        },
                        child: Text(
                          'Register',
                          style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<Users> _googleSignIn() async {
    final FirebaseRepository repo = FirebaseRepository();
    try {
      Users user = await repo.signInWithGoogle();
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
