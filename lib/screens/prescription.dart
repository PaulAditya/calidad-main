import 'dart:typed_data';

import 'package:calidad_app/model/callDetails.dart';
import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';
import 'package:calidad_app/screens/printPrescription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:ext_storage/ext_storage.dart';

class Prescription extends StatelessWidget {
  final Map callDetails;

  const Prescription({
    Key key,
    @required this.callDetails,
  }) : super(key: key);

  Future<File> saveAsPdf(Patient patient, Doctor doctor, Map rx) async {
    try {
      final directory = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      final path = "$directory/prescrip.pdf";

      pw.Document pdf = pw.Document();
      final logo = pw.MemoryImage(
        (await rootBundle.load('assets/logo.jpg')).buffer.asUint8List(),
      );
      dynamic doctorSign;
      if (doctor.signature != null) {
        Uint8List bytes = (await NetworkAssetBundle(Uri.parse(doctor.signature))
                .load(doctor.signature))
            .buffer
            .asUint8List();
        doctorSign = pw.MemoryImage(bytes);
      }

      pdf.addPage(
        pw.Page(
            build: (pw.Context context) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(child: pw.Image(logo, width: 400, height: 100)),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Patient Details-",
                                style: pw.TextStyle(fontSize: 18)),
                            pw.Text("Name - ${patient.name}",
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Text("Age - ${patient.age}",
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Text("Gender - ${patient.gender}",
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Text("Mobile - ${patient.mobile}",
                                style: pw.TextStyle(fontSize: 16)),
                          ]),
                      pw.SizedBox(height: 20),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Doctor Details-",
                                style: pw.TextStyle(fontSize: 18)),
                            pw.Text("Name - ${doctor.name}",
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Text("Experience - ${doctor.experience}",
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Text("Email - ${doctor.email}",
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Text("Qualification - ${doctor.qualification}",
                                style: pw.TextStyle(fontSize: 16)),
                          ]),
                      pw.SizedBox(height: 20),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Prescription-",
                                style: pw.TextStyle(fontSize: 18)),
                            rx["medicines"] != null
                                ? pw.Text("Medicines - ${rx["medicines"]}",
                                    style: pw.TextStyle(fontSize: 16))
                                : pw.Container(),
                            rx["chiefComplaints"] != null
                                ? pw.Text(
                                    "ChiefComplaints - ${rx["chiefComplaints"]}",
                                    style: pw.TextStyle(fontSize: 16))
                                : pw.Container(),
                            rx["history"] != null
                                ? pw.Text("History - ${rx["history"]}",
                                    style: pw.TextStyle(fontSize: 16))
                                : pw.Container(),
                            rx["exams"] != null
                                ? pw.Text("Exams - ${rx["exams"]}",
                                    style: pw.TextStyle(fontSize: 16))
                                : pw.Container(),
                            rx["special"] != null
                                ? pw.Text("Special - ${rx["special"]}",
                                    style: pw.TextStyle(fontSize: 16))
                                : pw.Container(),
                          ]),
                      doctorSign != null
                          ? pw.Container(
                              child:
                                  pw.Image(doctorSign, width: 200, height: 50))
                          : pw.Container()
                    ])),
      );

      final file = File(path);

      return await file.writeAsBytes(await pdf.save());
    } catch (e) {
      print(e);
    }
  }

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
                      onPressed: () async {
                        File res;
                        try {
                          res = await saveAsPdf(patient, doctor, details.rx);
                        } catch (e) {
                          print(e);
                        }
                        if (res == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Cannot Save PDF")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Saved as PDF")));
                        }
                      },
                      child: Text(
                        "Save As PDF",
                        style: GoogleFonts.montserrat(
                            color: Colors.blue[900],
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    )),
                SizedBox(
                  height: 20,
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
