import 'package:calidad_app/model/callDetails.dart';
import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';
import 'package:calidad_app/screens/printPrescription.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Prescription extends StatelessWidget {
  final Map callDetails;

  const Prescription({
    Key key,
    @required this.callDetails,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Patient patient = callDetails["patient"];
    Doctor doctor = callDetails["doctor"];
    CallDetails details = callDetails["callDetails"];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Prescription'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Patient
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Patient -",
                            style: GoogleFonts.montserrat(
                                fontSize: 20, color: Colors.blue[900])),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Name - ${patient.name}",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Age - ${patient.age}",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Gender - ${patient.gender}",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Mobile - ${patient.mobile}",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    /////Doctor
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Doctor - ",
                            style: GoogleFonts.montserrat(
                                fontSize: 20, color: Colors.blue[900])),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Name - ${doctor.name}",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Qualification - ${doctor.qualification}",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Speciality - ${doctor.speciality}",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Experience - ${doctor.experience}",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Prescription -",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              color: Colors.blue[900],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        details.rx["medicines"] != null
                            ? Text("Medicines - ${details.rx["medicines"]}",
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, color: Colors.black))
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        details.rx["chiefComplaints"] != null
                            ? Text(
                                "Chief Complaints - ${details.rx["chiefComplaints"]}",
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, color: Colors.black))
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        details.rx["history"] != null
                            ? Text("History - ${details.rx["history"]}",
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, color: Colors.black))
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        details.rx["exams"] != null
                            ? Text("Examinations - ${details.rx["exams"]}",
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, color: Colors.black))
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        details.rx["special"] != null
                            ? Text("Special - ${details.rx["special"]}",
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, color: Colors.black))
                            : Container(),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Colors.blue[900],
                        )),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PrintPrescription(callDetails: callDetails)));
                      },
                      child: Text(
                        "Print",
                        style: GoogleFonts.montserrat(
                            color: Colors.blue[900],
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
