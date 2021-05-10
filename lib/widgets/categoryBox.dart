import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryBox extends StatelessWidget {
  final String title;

  const CategoryBox({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 10),
      
      width: 120,
      decoration: BoxDecoration(
        boxShadow:[ BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 2.0), // shadow direction: bottom right
          )],
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.blue[900], width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/$title.png',
            height: 40,
            width: 40,
          ),
          SizedBox(height: 10),
          Text(title,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.indigo[900]))
        ],
      ),
    );
  }
}
