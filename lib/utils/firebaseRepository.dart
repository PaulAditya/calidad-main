import 'package:calidad_app/model/appointmentDetails.dart';
import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/utils/firebaseMethods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<Users> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<Users> signInWithGoogle() => _firebaseMethods.signInWithGoogle();

  Future<Users> signInWithEmailPass(String email, String password) =>
      _firebaseMethods.signInWithEmailPass(email, password);

  Future<List<Doctor>> getDoctors() => _firebaseMethods.getDoctors();

  Future<String> getPrescription(call) =>
      _firebaseMethods.getPrescription(call);

  Future<Users> signUpWithEmailPassword(String email, String password) =>
      _firebaseMethods.signUpWithEmailPassword(email, password);

  Future<bool> authenticateUser(Users user) =>
      _firebaseMethods.authenticateUser(user);

  Future<bool> addDataToDb(Users currentUser) =>
      _firebaseMethods.addDataToDb(currentUser);

  Future<bool> addPatient(Patient patient, String uid) =>
      _firebaseMethods.addPatient(patient, uid);

  Future<List<Map>> getPatients(String uid) =>
      _firebaseMethods.getPatients(uid);

  Future<List<AppointmentDetails>> getHistory(String uid) =>
      _firebaseMethods.getHistory(uid);

  Future<bool> deletePatient(int index, String uid) =>
      _firebaseMethods.deletePatient(index, uid);

  Future<bool> editPatient(Patient patient, String uid, int index) =>
      _firebaseMethods.editPatient(patient, uid, index);

  Future<bool> uploadToStorage(Map map, Call call, String fileName) =>
      _firebaseMethods.uploadToStorage(map, call, fileName);

  Future<Map> getUploadTask(String uid, bool camera, bool galleryCam, bool pdf,
          bool lowQuality, BuildContext context, bool desc) =>
      _firebaseMethods.getUploadTask(
          uid, camera, galleryCam, pdf, lowQuality, context, desc);
}
