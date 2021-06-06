import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/screens/patientForm.dart';
import 'package:calidad_app/utils/call_utils.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Patients extends StatefulWidget {
  final Users user;
  final Doctor doctor;

  const Patients({
    Key key,
    this.user,
    this.doctor,
  }) : super(key: key);

  @override
  _PatientsState createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  FirebaseRepository _repo = FirebaseRepository();
  Users user;
  UserProvider userProvider;
  List<Map> patients;
  bool _isLoading;

  Future<List<Map>> getPatients(String uid) async {
    return await _repo.getPatients(uid);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.refreshUser();
      user = userProvider.getUser;
      patients = await getPatients(user.uid).then((value) {
        setState(() {
          _isLoading = false;
        });

        return value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patients"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 100,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientForm()));
                    },
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      size: 40,
                      color: Colors.blue[900],
                    ),
                  )),
              SizedBox(height: 10),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : patients.length == 0
                      ? Center(
                          child: Text("No Patients Added",
                              style: GoogleFonts.montserrat(fontSize: 24)))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                  )),
                              child: ListTile(
                                onTap: () async {
                                  if (widget.user != null &&
                                      widget.doctor != null) {
                                    await CallUtils.dial(
                                        user: user,
                                        doctor: widget.doctor,
                                        patient: patients[index],
                                        context: context);
                                  }
                                },
                                title: Text(
                                  "Name - ${patients[index]['name']}",
                                  style: GoogleFonts.montserrat(fontSize: 18),
                                ),
                                subtitle: Text(
                                  "Age - ${patients[index]['age']}",
                                  style: GoogleFonts.montserrat(fontSize: 16),
                                ),
                              ),
                            );
                          })
            ],
          ),
        ),
      ),
    );
  }
}
