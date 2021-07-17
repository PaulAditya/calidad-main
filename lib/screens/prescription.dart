import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Prescription extends StatelessWidget {
  final String rx;
  final String patient;
  final String doctor;

  const Prescription({
    Key key,
    @required this.rx,
    @required this.patient,
    @required this.doctor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Prescription'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  child: Column(
                children: [
                  Text("Patient Details",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("$patient",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
              SizedBox(
                height: 30,
              ),
              Container(
                  child: Column(
                children: [
                  Text("Doctor Details",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("$doctor",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
              SizedBox(
                height: 50,
              ),
              Center(
                  child: Column(
                children: [
                  Text("Prescription",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(rx,
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
