import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/screens/doctorDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({
    Key key,
    this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Consumer<UserProvider>(
                builder: (context, user, _) => DoctorDetails(doctor: doctor))),
      ),
      child: Container(
        height: 100,
        width: width,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Image.asset('assets/doctor.png'),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.speciality,
                            style: GoogleFonts.montserrat(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                                fontSize: 12)),
                        SizedBox(height: 5),
                        Text(doctor.name,
                            style: GoogleFonts.montserrat(
                                color: Colors.blueGrey[900],
                                fontWeight: FontWeight.w500,
                                fontSize: 14)),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 16,
                              color: Colors.blue[900],
                            ),
                            SizedBox(width: 5),
                            Text("10am - 2pm",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.star,
                    //       color: Colors.yellow,
                    //       size: 16,
                    //     ),
                    //     SizedBox(width: 5),
                    //     Text(doctor.rating,
                    //         style: GoogleFonts.montserrat(
                    //             fontWeight: FontWeight.bold, fontSize: 16)),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
