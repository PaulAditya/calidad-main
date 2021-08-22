import 'dart:io';

import 'package:calidad_app/model/appointmentDetails.dart';
import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/model/callDetails.dart';
import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/utils/call_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

class FirebaseMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final CollectionReference _doctorCollection =
      _firestore.collection("doctors");

  static final CollectionReference _userCollection =
      _firestore.collection("users");

  static final CollectionReference _callDetailsCollection =
      _firestore.collection("callDetails");
  Users users = Users();

  Future<bool> addPatient(Patient patient, String uid) async {
    try {
      DocumentSnapshot userDoc = await _userCollection.doc(uid).get();
      Users user = Users.fromMap(userDoc.data());

      List patients = user.patients;

      patients.add(patient.toJson());

      _userCollection.doc(uid).update({'patients': patients});
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> editPatient(Patient patient, String uid, int index) async {
    try {
      DocumentSnapshot userDoc = await _userCollection.doc(uid).get();
      Users user = Users.fromMap(userDoc.data());

      List patients = user.patients;
      patients[index] = patient.toJson();

      _userCollection.doc(uid).update({'patients': patients});
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<Map>> getPatients(String uid) async {
    try {
      DocumentSnapshot doc = await _userCollection.doc(uid).get();

      Users user = Users.fromMap(doc.data());

      List<Map> patients = user.patients;
      return patients;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map> getPrescription(String doctorId, String userId, String channelId,
      String patientId) async {
    try {
      String docId =
          doctorId + "-" + userId + "_" + patientId + "-" + channelId;
      var value = await _callDetailsCollection.doc(docId).get();

      CallDetails details = CallDetails.fromMap(value.data());
      if (details.rx != null) {
        Patient patient = await getPatientById(userId, patientId);
        Doctor doctor = await getDoctorDetails(doctorId);

        Map prescriptionDetail = new Map();
        prescriptionDetail["doctor"] = doctor;
        prescriptionDetail["patient"] = patient;
        prescriptionDetail["callDetails"] = details;

        return prescriptionDetail;
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Doctor> getDoctorDetails(String doctorId) async {
    try {
      DocumentSnapshot result = await _doctorCollection.doc(doctorId).get();
      Doctor doctor = Doctor.fromMap(result.data());
      return doctor;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> deletePatient(int index, String uid) async {
    try {
      DocumentSnapshot doc = await _userCollection.doc(uid).get();

      Users user = Users.fromMap(doc.data());

      List<Map> patients = user.patients;
      patients.removeAt(index);
      _userCollection.doc(uid).update({'patients': patients});

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<Doctor>> getDoctors() async {
    List<Doctor> doctors = new List<Doctor>();
    QuerySnapshot qs = await _doctorCollection.get();

    for (var i = 0; i < qs.docs.length; i++) {
      doctors.add(Doctor.fromMap(qs.docs[i].data()));
    }

    return doctors;
  }

  Future<bool> addDoctorAccess(
      String uid, String patientId, String doctorId) async {
    try {
      Patient patient = await getPatientById(uid, patientId);

      if (patient.allowedDoctors == null) patient.allowedDoctors = [];
      patient.allowedDoctors.add(doctorId);
      DocumentSnapshot ds = await _userCollection.doc(uid).get();
      Users user = Users.fromMap(ds.data());
      int index =
          user.patients.indexWhere((element) => element["id"] == patientId);
      user.patients[index] = patient.toJson();
      await _userCollection.doc(uid).update({'patients': user.patients});
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> doctorEHRAccess(
      String uid, String patientId, String doctorId) async {
    try {
      List allowedDoctors = await getAllowedDoctors(uid, patientId);

      return allowedDoctors == null ? false : allowedDoctors.contains(doctorId);
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<Patient> getPatientById(String uid, String patientId) async {
    try {
      DocumentSnapshot ds = await _userCollection.doc(uid).get();
      Users user = Users.fromMap(ds.data());

      Patient patient;
      user.patients.forEach((element) {
        Patient p = Patient.fromMap(element);
        if (p.id == patientId) {
          patient = p;
        }
      });

      return patient;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List> getAllowedDoctors(String uid, String patientId) async {
    try {
      Patient patient = await getPatientById(uid, patientId);
      return patient.allowedDoctors;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<AppointmentDetails>> getHistory(String uid) async {
    QuerySnapshot qs =
        await _callDetailsCollection.where("user_id", isEqualTo: uid).get();
    List<DocumentSnapshot> docs = qs.docs;
    List<AppointmentDetails> appDetails = new List();
    for (var i = 0; i < docs.length; i++) {
      Map details = new Map();
      details = docs[i].data();
      List str = docs[i].id.split("-");
      String channelId = str[2];
      details["channel_id"] = channelId;
      appDetails.add(AppointmentDetails.fromMap(details));
    }

    return appDetails;
  }

  Future<bool> uploadToStorage(Map map, Call call, String fileName) async {
    try {
      UploadTask uploadTask = map["uploadTask"];
      Reference ref = map["ref"];
      String url = await uploadTask.then((e) async {
        String u = await ref.getDownloadURL();

        if (map["description"] != null) {
          u = u + '@' + map["description"];
        }
        return u;
      });

      CallUtils cu = CallUtils();
      await cu.addFile(
        call: call,
        url: url,
        fileName: fileName,
      );
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<Map> getUploadTask(String uid, bool camera, bool gallery, bool pdf,
      bool lowQuality, BuildContext context, bool description) async {
    try {
      ImagePicker img = ImagePicker();
      var pickedFile;
      Map map = new Map();
      String contentType = pdf
          ? "document"
          : camera
              ? "image"
              : "video";
      if (pdf) {
        pickedFile = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);
      } else {
        pickedFile = camera
            ? await img.getImage(
                source: gallery ? ImageSource.gallery : ImageSource.camera,
                imageQuality: lowQuality ? 50 : 100)
            : await img.getVideo(source: ImageSource.gallery);
      }
      if (pickedFile != null) {
        if (description) {
          TextEditingController _desc = new TextEditingController();
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter Description"),
                  content: TextFormField(
                    controller: _desc,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[900]))),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (_desc.text.length == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Description cannot be empty")));
                          } else {
                            map = getMapfromPickedFile(
                                pickedFile, uid, contentType, _desc.text);

                            Navigator.pop(context);
                          }
                        },
                        child: Text("Ok")),
                    TextButton(
                        onPressed: () {
                          map = null;
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"))
                  ],
                );
              });
        } else if (gallery) {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Confirm"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          map = getMapfromPickedFile(
                              pickedFile, uid, contentType, null);

                          Navigator.pop(context);
                        },
                        child: Text("Ok")),
                    TextButton(
                        onPressed: () {
                          map = null;
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"))
                  ],
                );
              });
        } else {
          map = getMapfromPickedFile(pickedFile, uid, contentType, null);
        }
        return map;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Map getMapfromPickedFile(
      dynamic pickedFile, String uid, String fileType, String description) {
    UploadTask uploadTask;
    Reference ref;
    final DateTime now = DateTime.now();
    final int millSeconds = now.millisecondsSinceEpoch;
    final String month = now.month.toString();
    final String date = now.day.toString();
    final String storageId = (millSeconds.toString() + uid);
    final String today = ('$month-$date');
    Map map = new Map();
    String contentType = fileType == "image" ? 'image/jpeg' : 'video/mp4';
    File file = fileType == "document"
        ? File(pickedFile.files.single.path)
        : File(pickedFile.path);
    ref = FirebaseStorage.instance
        .ref()
        .child(fileType)
        .child(today)
        .child(storageId);
    uploadTask = fileType == "document"
        ? ref.putData(file.readAsBytesSync())
        : ref.putFile(file, SettableMetadata(contentType: contentType));
    if (uploadTask != null) {
      map["uploadTask"] = uploadTask;
      map["ref"] = ref;
      if (description != null) {
        map["description"] = description;
      }
      return map;
    }
    return null;
  }
}
