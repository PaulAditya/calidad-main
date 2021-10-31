import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    TextEditingController _email = TextEditingController();

    final FirebaseRepository repo = FirebaseRepository();
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.montserrat(
                        fontSize: height * 0.07,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
                                labelText: 'Enter Email Id',
                                labelStyle: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue[900]))),
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () async {
                              if (_key.currentState.validate()) {
                                try {
                                  await repo.resetPassword(_email.text);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Password Reset Email Sent")));
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  print("Exception " + e);
                                }
                              }
                            },
                            child: Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                shadowColor: Colors.blueAccent,
                                color: Colors.blue[900],
                                elevation: 7.0,
                                child: Center(
                                  child: Text(
                                    'Send Password Reset Email',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
