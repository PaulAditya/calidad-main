import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/screens/patients.dart';

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
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Users user = userProvider.getUser;

    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.blue[900],
        //   leading: GestureDetector(
        //     onTap: Navigator.of(context).pop,
        //     child: Container(
        //       margin: EdgeInsets.all(12),
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10), color: Colors.white),
        //       child: Icon(
        //         Icons.arrow_back_ios_sharp,
        //         color: Colors.indigo[900],
        //         size: 14,
        //       ),
        //     ),
        //   ),
        // ),
        body: Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.indigo[900], Colors.blue[400]]),
              color: Colors.blue[900],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          // margin: EdgeInsets.only(top: 150, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Colors.indigo[900],
                    size: 14,
                  ),
                ),
              ),
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
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            widget.doctor.speciality,
                            style: GoogleFonts.montserrat(
                                color: Colors.blue[900],
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Text(
                              "Timings - ${widget.doctor.from} - ${widget.doctor.till}",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.w500),
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
              Consumer<UserProvider>(
                builder: (context, userProvider, child) => GestureDetector(
                  onTap: () async {
                    if (widget.doctor.isAvailable) {
                      if (await Permissions
                          .cameraAndMicrophonePermissionsGranted()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Patients(
                                      doctor: widget.doctor,
                                      call: true,
                                    )));
                      }
                    }
                  },
                  child: Container(
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
                      child: Center(
                        child: Text(
                          widget.doctor.isAvailable ? 'Call' : 'Not Available',
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
              )
              // GestureDetector(
              //   onTap: () async {
              //     if (widget.doctor.isAvailable) {
              //       if (await Permissions
              //           .cameraAndMicrophonePermissionsGranted()) {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => Patients(
              //                       doctor: widget.doctor,
              //                       user: user,
              //                     )));
              //       }
              //     }
              //   },
              //   child: Container(
              //     height: 50.0,
              //     child: Material(
              //       borderRadius: BorderRadius.circular(10.0),
              //       shadowColor: widget.doctor.isAvailable
              //           ? Colors.blueAccent
              //           : Colors.redAccent,
              //       color: widget.doctor.isAvailable
              //           ? Colors.blue[900]
              //           : Colors.redAccent,
              //       elevation: 7.0,
              //       child: Center(
              //         child: Text(
              //           widget.doctor.isAvailable ? 'Call' : 'Not Available',
              //           style: GoogleFonts.montserrat(
              //             fontSize: 20,
              //             color: Colors.white,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        )
      ],
    ));
  }
}
