import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EHRAccess extends StatefulWidget {
  final String uid;
  final String patientId;
  final String doctorId;
  const EHRAccess(
      {Key key, @required this.uid, @required this.patientId, this.doctorId})
      : super(key: key);

  @override
  _EHRAccessState createState() => _EHRAccessState();
}

class _EHRAccessState extends State<EHRAccess> {
  final FirebaseRepository _repo = FirebaseRepository();
  bool _loading = false;
  bool _access = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    checkEHRAccess();
  }

  checkEHRAccess() async {
    bool res = await _repo.doctorEHRAccess(
        widget.uid, widget.patientId, widget.doctorId);
    setState(() {
      _loading = false;
      _access = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("EHR Access"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: _loading
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : _access
                  ? Container(
                      child: Text(
                        "This doctor has access to your EHR.",
                        style: GoogleFonts.montserrat(fontSize: 18),
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          "Allow this doctor access to your EHR?",
                          style: GoogleFonts.montserrat(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue[900])),
                          child: TextButton(
                              onPressed: () async {
                                _repo
                                    .addDoctorAccess(widget.uid,
                                        widget.patientId, widget.doctorId)
                                    .then((value) async {
                                  if (value) {
                                    bool res = await _repo.doctorEHRAccess(
                                        widget.uid,
                                        widget.patientId,
                                        widget.doctorId);
                                    print("object");
                                    if (res) {
                                      setState(() {
                                        _access = res;
                                      });
                                    }
                                  } else
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Try Again")));
                                });
                              },
                              child: Text("Allow",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 18, color: Colors.blue[900]))),
                        )
                      ],
                    ),
        ),
      ),
    );
  }
}
