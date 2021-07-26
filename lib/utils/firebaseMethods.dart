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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final CollectionReference _doctorCollection =
      _firestore.collection("doctors");

  static final CollectionReference _userCollection =
      _firestore.collection("users");

  static final CollectionReference _callDetailsCollection =
      _firestore.collection("callDetails");
  Users users = Users();

  Future<Users> getCurrentUser() async {
    User firebaseUser;
    Users user;
    try {
      firebaseUser = _auth.currentUser;
      user = users.fromUser(firebaseUser);
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<Users> signInWithEmailPass(String email, String password) async {
    Users user;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = cred.user;
      user = users.fromUser(firebaseUser);
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<Users> signUpWithEmailPassword(String email, String password) async {
    Users user;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = cred.user;
      user = users.fromUser(firebaseUser);
      return user;
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<bool> authenticateUser(Users user) async {
    try {
      QuerySnapshot result =
          await _userCollection.where("email", isEqualTo: user.email).get();

      final List<DocumentSnapshot> docs = result.docs;

      return docs.length == 0 ? false : true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> addDataToDb(Users currentUser) async {
    try {
      Users user = Users(
          uid: currentUser.uid,
          email: currentUser.email,
          profilePhoto: currentUser.profilePhoto,
          username: currentUser.username,
          patients: <Map>[]);

      _userCollection.doc(currentUser.uid).set(users.toMap(user));
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

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

  Future<Users> signInWithGoogle() async {
    Users user;
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      UserCredential authResult = await _auth.signInWithCredential(credential);
      User firebaseUser = authResult.user;
      user = users.fromUser(firebaseUser);
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<String> getPrescription(Call call) async {
    String rx;
    CollectionReference callDetailCollection =
        FirebaseFirestore.instance.collection("callDetails");

    String docId = "${call.receiverId}-${call.callerId}-${call.channelId}";
    var value = await callDetailCollection.doc(docId).get();

    CallDetails details = CallDetails.fromMap(value.data());
    rx = details.rx;

    return rx;
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

  Future<List<AppointmentDetails>> getHistory(String uid) async {
    QuerySnapshot qs =
        await _callDetailsCollection.where("user_id", isEqualTo: uid).get();
    List<DocumentSnapshot> docs = qs.docs;
    List<AppointmentDetails> app_details = new List();
    for (var i = 0; i < docs.length; i++) {
      app_details.add(AppointmentDetails.fromMap(docs[i].data()));
    }

    return app_details;
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

  Future<Map> getUploadTask(
      String uid, bool camera, bool galleryCam, bool pdf) async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + uid);
      final String today = ('$month-$date');
      ImagePicker img = ImagePicker();

      UploadTask uploadTask;
      Reference ref;
      Map map = new Map();

      if (camera) {
        return img
            .getImage(
                source: ImageSource.camera,
                imageQuality: 50,
                maxHeight: 640,
                maxWidth: 480)
            .then((value) {
          if (value != null) {
            File file = File(value.path);

            ref = FirebaseStorage.instance
                .ref()
                .child("image")
                .child(today)
                .child(storageId);
            uploadTask =
                ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
            map["uploadTask"] = uploadTask;
            map["ref"] = ref;
            return map;
          }
          return null;
        });
      } else if (pdf) {
        FilePickerResult res = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

        if (res != null) {
          File file = File(res.files.single.path);
          ref = FirebaseStorage.instance
              .ref()
              .child("document")
              .child(today)
              .child(storageId);
          uploadTask = ref.putData(file.readAsBytesSync());
          if (uploadTask != null) {
            map["uploadTask"] = uploadTask;
            map["ref"] = ref;
          }
          return map;
        }
        return null;
      } else if (!galleryCam) {
        return img.getVideo(source: ImageSource.gallery).then((value) {
          if (value != null) {
            File file = File(value.path);

            ref = FirebaseStorage.instance
                .ref()
                .child("video")
                .child(today)
                .child(storageId);
            uploadTask =
                ref.putFile(file, SettableMetadata(contentType: 'video/mp4'));
            if (uploadTask != null) {
              map["uploadTask"] = uploadTask;
              map["ref"] = ref;
            }

            return map;
          }
          return null;
        });
      } else if (galleryCam) {
        return img
            .getImage(
                source: ImageSource.gallery,
                imageQuality: 50,
                maxHeight: 640,
                maxWidth: 480)
            .then((value) {
          if (value != null) {
            File file = File(value.path);

            ref = FirebaseStorage.instance
                .ref()
                .child("image")
                .child(today)
                .child(storageId);
            uploadTask =
                ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
            if (uploadTask != null) {
              map["uploadTask"] = uploadTask;
              map["ref"] = ref;
            }
            return map;
          }
          return null;
        });
      }
    } catch (error) {
      print(error);
    }
    return null;
  }
}
