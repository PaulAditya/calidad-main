import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/utils/call_utils.dart';

import 'package:calidad_app/utils/firebaseRepository.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

class PeekFlow extends StatefulWidget {
  final Call call;
  const PeekFlow({
    Key key,
    @required this.call,
  }) : super(key: key);

  @override
  _PeekFlowState createState() => _PeekFlowState();
}

class _PeekFlowState extends State<PeekFlow> {
  bool _isLoading = false;

  TextEditingController _peekflow = new TextEditingController();
  final FirebaseRepository _repo = FirebaseRepository();
  final CallUtils cu = CallUtils();

  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("PeekFlow"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Center(
                  child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _peekflow,
                    decoration: InputDecoration(
                        labelText: 'Enter Value',
                        labelStyle: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[900]))),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isLoading = !_isLoading;
                        });

                        if (_peekflow.text != null) {
                          cu
                              .addVitals(
                                  call: widget.call,
                                  value: _peekflow.text,
                                  name: "peekFlow")
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Uploaded Succesfully")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Try Again")));
                            }
                            setState(() {
                              _peekflow.clear();
                              _isLoading = !_isLoading;
                            });
                          });
                        } else {
                          setState(() {
                            _peekflow.clear();
                            _isLoading = !_isLoading;
                          });
                        }
                      },
                      child: !_isLoading
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue[900],
                              ),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ))
                          : Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ))),
                ],
              ))),
        ));
  }
}
