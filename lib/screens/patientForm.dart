import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/screens/patients.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PatientForm extends StatefulWidget {
  final Patient patient;
  final Users user;
  final Doctor doctor;
  final int index;

  const PatientForm({Key key, this.user, this.doctor, this.patient, this.index})
      : super(key: key);

  @override
  _PatientFormState createState() => _PatientFormState();
}

enum Gender { Male, Female }

class _PatientFormState extends State<PatientForm> {
  Gender _gender = Gender.Male;
  FirebaseRepository _repo = FirebaseRepository();
  TextEditingController _name = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    if (widget.patient != null) {
      _name.text = widget.patient.name;
      _age.text = widget.patient.age;
      _height.text = widget.patient.height;
      _weight.text = widget.patient.weight;
      _mobile.text = widget.patient.mobile;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Users user = userProvider.getUser;

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Patients(user: widget.user, doctor: widget.doctor)));
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Patient"),
          backgroundColor: Colors.blue[900],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent))),
                ),
                SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Male'),
                      leading: Radio(
                        value: Gender.Male,
                        groupValue: _gender,
                        onChanged: (Gender value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Female'),
                      leading: Radio(
                        value: Gender.Female,
                        groupValue: _gender,
                        onChanged: (Gender value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _age,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent))),
                ),
                SizedBox(height: 10.0),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _weight,
                  decoration: InputDecoration(
                      labelText: 'Weight',
                      labelStyle: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent))),
                ),
                SizedBox(height: 10.0),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mobile,
                  decoration: InputDecoration(
                      labelText: 'Mobile No.',
                      labelStyle: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent))),
                ),
                SizedBox(height: 10.0),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _height,
                  decoration: InputDecoration(
                      labelText: 'Height',
                      labelStyle: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent))),
                ),
                SizedBox(height: 40.0),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_name.text.length > 0 && _age.text.length > 0) {
                        List patients = await _repo.getPatients(user.uid);

                        var i;
                        if (patients == null || patients.length == 0) {
                          i = 0;
                        } else {
                          i = int.parse(patients.last["id"]) + 1;
                        }

                        Patient p = Patient(
                            widget.patient == null
                                ? i.toString()
                                : widget.patient.id,
                            _name.text,
                            _age.text,
                            _weight.text,
                            _height.text,
                            _gender.toString().split('.').last,
                            _mobile.text);

                        if (widget.patient == null) {
                          _repo.addPatient(p, user.uid).then((value) {
                            _name.clear();
                            _age.clear();
                            _weight.clear();
                            _height.clear();
                            _mobile.clear();
                            setState(() {
                              _isLoading = false;
                            });
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Uploaded Succesfully")));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Patients(
                                          user: widget.user,
                                          doctor: widget.doctor)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Try Again")));
                            }
                          });
                        } else {
                          _repo
                              .editPatient(p, user.uid, widget.index)
                              .then((value) {
                            _name.clear();
                            _age.clear();
                            _weight.clear();
                            _height.clear();
                            _mobile.clear();
                            setState(() {
                              _isLoading = false;
                            });
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Uploaded Succesfully")));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Patients(
                                          user: widget.user,
                                          doctor: widget.doctor)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Try Again")));
                            }
                          });
                        }
                      } else {
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Name and Age cannot be empty")));
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Container(
                            height: 50.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.blueAccent,
                              color: Colors.blue[900],
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'SAVE',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
