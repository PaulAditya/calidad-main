import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';

import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/screens/patientForm.dart';
import 'package:calidad_app/screens/search_page.dart';
import 'package:calidad_app/utils/call_utils.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Patients extends StatefulWidget {
  final bool call;
  final Doctor doctor;

  const Patients({
    Key key,
    @required this.call,
    @required this.doctor,
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
  List filteredList = [];
  TextEditingController _search = TextEditingController();

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
        filteredList = value;
        return value;
      });
    });
  }

  filterList(List list, String param) {
    list = list
        .where((element) =>
            element['name'].toLowerCase().contains(param.toLowerCase()))
        .toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientForm(
                          user: user,
                          doctor: widget.doctor,
                          call: widget.call)));
            },
            child: Icon(
              Icons.add_circle,
              size: 50,
              color: Colors.blue[900],
            ),
          )),
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
                height: 50,
                child: TextField(
                  onEditingComplete: () {
                    setState(() {
                      filteredList = filterList(patients, _search.text);
                    });
                  },
                  controller: _search,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 12),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search',
                    hintStyle: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 14),
                    suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        onPressed: () {}),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : patients.length == 0
                      ? Center(
                          child: Text("No Patients Added",
                              style: GoogleFonts.montserrat(fontSize: 24)))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              width: 150,
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue[900],
                                  )),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 180,
                                    child: ListTile(
                                      onTap: () async {
                                        if (widget.call) {
                                          await CallUtils.dial(
                                              user: user,
                                              doctor: widget.doctor,
                                              patient: filteredList[index],
                                              context: context);
                                        }
                                      },
                                      title: Text(
                                        "Name - ${filteredList[index]['name']}",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        "Age - ${filteredList[index]['age']}",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PatientForm(
                                                        patient:
                                                            Patient.fromMap(
                                                                filteredList[
                                                                    index]),
                                                        index: index,
                                                      )));
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirm"),
                                                  content: Text(
                                                      "Confirm Delete Patient?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          await _repo
                                                              .deletePatient(
                                                                  index,
                                                                  user.uid);

                                                          List p = await _repo
                                                              .getPatients(
                                                                  user.uid);

                                                          setState(() {
                                                            _isLoading = false;
                                                            patients = p;
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("Delete",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .red))),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("Cancel",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .blue))),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          child: Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.red[700],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
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
