
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceCard extends StatelessWidget {
  final String image;
  final String title;
  final Widget page;

  const DeviceCard({
    Key key,
    @required this.image,
    @required this.title,
    @required this.page,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 120,
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => page));
              },
              child: Image.asset(
                image,
                height: 40,
                width: 40,
              ),
              shape: CircleBorder(
                  side: BorderSide(color: Colors.blue[900], width: 2)),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
          ),
          SizedBox(height: 10),
          Center(child: Text(title, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w500),))
        ],
      ),
    );
  }
}
