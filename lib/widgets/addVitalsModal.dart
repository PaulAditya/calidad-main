import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/screens/otoscope.dart';
import 'package:calidad_app/screens/prescription.dart';

import 'package:calidad_app/screens/spo2.dart';
import 'package:calidad_app/screens/stethoscope.dart';
import 'package:calidad_app/screens/temperature_input.dart';
import 'package:calidad_app/widgets/deviceCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddVitalModal extends StatelessWidget {
  final Call call;
  final bool rx;
  final String pres;

  const AddVitalModal(
      {Key key, @required this.call, @required this.rx, @required this.pres})
      : super(key: key);
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
                    page: Temperature(call: call)),
                DeviceCard(
                    image: 'assets/oxygen.png',
                    title: 'Spo2',
                    page: Spo2Screen(call: call)),
                DeviceCard(
                    image: 'assets/otoscope.png',
                    title: 'Otoscope',
                    page: Otoscope(
                      call: call,
                      fileName: "otoscope",
                      camera: false,
                      gallery: false,
                      recorder: true,
                    )),
                DeviceCard(
                    image: 'assets/dental.png',
                    title: 'Dental',
                    page: Otoscope(
                      call: call,
                      fileName: "dental_video",
                      camera: false,
                      gallery: false,
                      recorder: true,
                    )),
                DeviceCard(
                    image: 'assets/stethoscope.png',
                    title: 'Heart Sound',
                    page: Stethoscope(
                      imageName: "heart.jpeg",
                      call: call,
                      fileName: "heart_audio",
                      noOfFiles: 4,
                    )),
                DeviceCard(
                    image: 'assets/lungs.png',
                    title: 'Lung Sound',
                    page: Stethoscope(
                      imageName: "lung.jpeg",
                      call: call,
                      fileName: "lungs_audio",
                      noOfFiles: 8,
                    )),
                DeviceCard(
                    image: 'assets/stomach.png',
                    title: 'Abdomen',
                    page: Stethoscope(
                      imageName: "abdomen.jpeg",
                      call: call,
                      fileName: "abdomen_audio",
                      noOfFiles: 4,
                    )),
                DeviceCard(
                    image: 'assets/dermis.png',
                    title: 'Skin',
                    page: Otoscope(
                      call: call,
                      fileName: "skin_image",
                      camera: true,
                      gallery: true,
                      recorder: false,
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
                            builder: (context) =>
                                Prescription(rx: pres, call: call)));
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
