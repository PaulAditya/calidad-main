import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/utils/call_utils.dart';
import 'package:calidad_app/utils/permissions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DoctorDetails extends StatefulWidget {
  final Doctor doctor;

  const DoctorDetails({Key key, @required this.doctor}) : super(key: key);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool isDisabled;
  @override
  void initState() {
    super.initState();
    isDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.doctor.uid);
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: true);
    Users user = userProvider.getUser;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue[900],
          leading: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.indigo[900],
                size: 14,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(top: 50, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Image.asset(
                            'assets/doctor.png',
                            height: 60,
                            width: 60,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    1.0, 2.0), // shadow direction: bottom right
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Dr. ${widget.doctor.name}",
                                style: GoogleFonts.montserrat(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Center(
                              child: Text(
                                widget.doctor.speciality,
                                style: GoogleFonts.montserrat(
                                    color: Colors.blue[900],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              children: [
                                Text(
                                  "Rating - ${widget.doctor.rating} / 5",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14,
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "Timings - ${widget.doctor.from} - ${widget.doctor.till}",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.timer,
                                  color: Colors.blue[900],
                                  size: 14,
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Experience - ${widget.doctor.experience} years",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Qualifications - ${widget.doctor.qualification}",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Address - ${widget.doctor.address}",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: widget.doctor.isAvailable
                          ? Colors.blueAccent
                          : Colors.redAccent,
                      color: widget.doctor.isAvailable
                          ? Colors.blue[900]
                          : Colors.redAccent,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () async {
                          if (widget.doctor.isAvailable) {
                           
                            if (await Permissions
                                .cameraAndMicrophonePermissionsGranted()) {
                              
                              
                              await CallUtils.dial(
                                      patient: user, doctor: widget.doctor, context: context);
                                 
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            widget.doctor.isAvailable
                                ? 'Call'
                                : 'Not Available',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
