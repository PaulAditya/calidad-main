import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/screens/ecg.dart';
import 'package:calidad_app/screens/ehr_access.dart';
import 'package:calidad_app/screens/otoscope.dart';
import 'package:calidad_app/screens/peak_flow.dart';
import 'package:calidad_app/screens/prescription.dart';

import 'package:calidad_app/screens/spo2.dart';
import 'package:calidad_app/screens/stethoscope.dart';
import 'package:calidad_app/screens/temperature_input.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:calidad_app/widgets/deviceCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddVitalModal extends StatefulWidget {
  final Call call;

  const AddVitalModal({
    Key key,
    @required this.call,
  }) : super(key: key);

  @override
  _AddVitalModalState createState() => _AddVitalModalState();
}

class _AddVitalModalState extends State<AddVitalModal> {
  bool rx = false;
  Map prescription = new Map();
  FirebaseRepository _repo = FirebaseRepository();
  prescriptionAvailable() async {
    prescription = await _repo.getPrescription(widget.call.receiverId,
        widget.call.userId, widget.call.channelId, widget.call.patient["id"]);
    if (prescription != null) {
      setState(() {
        rx = true;
      });
    }
  }

  @override
  void initState() {
    prescriptionAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Icon(
                Icons.arrow_drop_down,
                size: 40,
                color: Colors.blue[900],
              ),
            ),
          ),
          Container(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                DeviceCard(
                    image: 'assets/thermometer.png',
                    title: 'Temperature',
                    page: Temperature(call: widget.call)),
                DeviceCard(
                    image: 'assets/oxygen.png',
                    title: 'Spo2',
                    page: Spo2Screen(call: widget.call)),
                DeviceCard(
                    image: 'assets/otoscope.png',
                    title: 'Otoscope',
                    page: Otoscope(
                      pageName: "Otoscope",
                      call: widget.call,
                      fileName: "otoscope",
                      camera: false,
                      gallery: true,
                      recorder: true,
                      description: false,
                      pdf: false,
                      lowQuality: false,
                    )),
                DeviceCard(
                    image: 'assets/dental.png',
                    title: 'Dental',
                    page: Otoscope(
                      pageName: "Dental",
                      call: widget.call,
                      fileName: "dental_video",
                      camera: false,
                      gallery: true,
                      recorder: true,
                      description: false,
                      pdf: false,
                      lowQuality: false,
                    )),
                DeviceCard(
                    image: 'assets/stethoscope.png',
                    title: 'Heart Sound',
                    page: Stethoscope(
                      imageName: "heart.jpeg",
                      call: widget.call,
                      fileName: "heart_audio",
                      noOfFiles: 4,
                    )),
                DeviceCard(
                    image: 'assets/lungs.png',
                    title: 'Lung Sound',
                    page: Stethoscope(
                      imageName: "lung.jpeg",
                      call: widget.call,
                      fileName: "lungs_audio",
                      noOfFiles: 8,
                    )),
                DeviceCard(
                    image: 'assets/stomach.png',
                    title: 'Abdomen',
                    page: Stethoscope(
                      imageName: "abdomen.jpeg",
                      call: widget.call,
                      fileName: "abdomen_audio",
                      noOfFiles: 4,
                    )),
                DeviceCard(
                    image: 'assets/dermis.png',
                    title: 'Skin',
                    page: Otoscope(
                      pageName: "Dermatological Exam",
                      call: widget.call,
                      fileName: "skin_image",
                      camera: true,
                      gallery: true,
                      recorder: false,
                      description: false,
                      pdf: false,
                      lowQuality: false,
                    )),
                DeviceCard(
                    image: 'assets/bp_reading.png',
                    title: 'Blood Pressure',
                    page: Otoscope(
                      pageName: "Blood Pressure",
                      call: widget.call,
                      fileName: "bp_reading",
                      camera: true,
                      gallery: true,
                      recorder: false,
                      description: false,
                      pdf: false,
                      lowQuality: true,
                    )),
                DeviceCard(
                    image: 'assets/file.png',
                    title: 'Documents',
                    page: Otoscope(
                      pageName: "Documents",
                      call: widget.call,
                      fileName: "xtra_files",
                      camera: true,
                      gallery: true,
                      recorder: false,
                      description: true,
                      pdf: true,
                      lowQuality: false,
                    )),
                DeviceCard(
                    image: 'assets/eye.png',
                    title: 'Eye',
                    page: Otoscope(
                      pageName: "Opthalmic Exam",
                      call: widget.call,
                      fileName: "eye_image",
                      camera: true,
                      gallery: true,
                      recorder: false,
                      description: false,
                      pdf: true,
                      lowQuality: false,
                    )),
                DeviceCard(
                    image: 'assets/ecg.png',
                    title: 'ECG',
                    page: ECG(
                      call: widget.call,
                    )),
                DeviceCard(
                    image: 'assets/e.png',
                    title: 'EHR access',
                    page: EHRAccess(
                      uid: widget.call.userId,
                      patientId: widget.call.patient["id"],
                      doctorId: widget.call.receiverId,
                    )),
                DeviceCard(
                    image: 'assets/peekflow.jpg',
                    title: 'Peakflow',
                    page: PeakFlow(
                      call: widget.call,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: rx
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Prescription(
                                  callDetails: prescription,
                                )));
                  }
                : null,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border:
                      Border.all(color: rx ? Colors.blue[900] : Colors.grey)),
              child: Center(
                child: Text(
                  "Prescription",
                  style: GoogleFonts.montserrat(
                      fontSize: 16, color: rx ? Colors.blue[900] : Colors.grey),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
