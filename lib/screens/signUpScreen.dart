import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  final FirebaseRepository repo = FirebaseRepository();
  TextEditingController _userName = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return new Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, top: height * 0.08),
            child: RichText(
              text: TextSpan(
                  text: 'Register',
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: height * 0.1,
                      fontWeight: FontWeight.bold),
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
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Required*"),
                      EmailValidator(errorText: "Enter a valid email address")
                    ]),
                    controller: _email,
                    decoration: InputDecoration(
                        labelText: 'EMAIL',
                        labelStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        // hintText: 'EMAIL',
                        // hintStyle: ,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    validator: RequiredValidator(errorText: "Required*"),
                    controller: _userName,
                    decoration: InputDecoration(
                        labelText: 'USER NAME ',
                        labelStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Required*"),
                      MinLengthValidator(6,
                          errorText: "Minimum length should be 6")
                    ]),
                    controller: _password,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD ',
                        labelStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Required*"),
                      MinLengthValidator(6,
                          errorText: "Minimum length should be 6")
                    ]),
                    controller: _confirmPassword,
                    decoration: InputDecoration(
                        labelText: 'CONFIRM PASSWORD ',
                        labelStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                    obscureText: true,
                  ),
                  SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () async {
                      if (_confirmPassword.text == _password.text) {
                        if (_formkey.currentState.validate()) {
                          Users user = await repo.signUpWithEmailPassword(
                              _email.text, _password.text, _userName.text);
                          if (user != null) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          user: user,
                                        )));
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Passwords Do Not Match")));
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
                              'SIGNUP',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text('Go Back',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ]),
      ),
    ));
  }
}
