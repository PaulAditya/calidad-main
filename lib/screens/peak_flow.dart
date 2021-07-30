import 'package:calidad_app/model/call.dart';

import 'package:calidad_app/utils/call_utils.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeakFlow extends StatefulWidget {
  final Call call;
  const PeakFlow({
    Key key,
    @required this.call,
  }) : super(key: key);

  @override
  _PeakFlowState createState() => _PeakFlowState();
}

class _PeakFlowState extends State<PeakFlow> {
  bool _isLoading = false;

  TextEditingController _peakflow = new TextEditingController();

  final CallUtils cu = CallUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("PeakFlow"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Center(
                  child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _peakflow,
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

                        if (_peakflow.text != null) {
                          cu
                              .addVitals(
                                  call: widget.call,
                                  value: "${_peakflow.text} L/min",
                                  name: "peakFlow")
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
                              _peakflow.clear();
                              _isLoading = !_isLoading;
                            });
                          });
                        } else {
                          setState(() {
                            _peakflow.clear();
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
