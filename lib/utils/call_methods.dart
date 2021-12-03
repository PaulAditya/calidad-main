import 'package:calidad_app/model/call.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("call");

  final CollectionReference callDetailCollection =
      FirebaseFirestore.instance.collection("callDetails");

  List<dynamic> abdomen_audio;
  List<dynamic> heart_audio;
  List<dynamic> lungs_audio;
  List<dynamic> skin_image;
  List<dynamic> otoscope;
  List<dynamic> dental_video;
  List<dynamic> eye_image;
  List<dynamic> xtra_files;
  List<dynamic> ecg;
  List<dynamic> eye_pdf;
  List<dynamic> temperature_image;
  List<dynamic> spo2_image;
  Future<bool> makeCall({Call call}) async {
    try {
      Map<String, dynamic> map = call.toMap(call);
      String docId =
          call.receiverId + "-" + call.callerId + "-" + call.channelId;
      await callCollection.doc(call.receiverId).set(map);
      DateTime now = DateTime.now();
      abdomen_audio = [null, null, null, null];
      heart_audio = [null, null, null, null];
      lungs_audio = [null, null, null, null, null, null, null, null];
      otoscope = [];
      dental_video = [];
      eye_image = [];
      xtra_files = [];
      skin_image = [];
      ecg = [];
      eye_pdf = [];
      temperature_image = [];
      spo2_image = [];
      Map<String, dynamic> vitals = Map<String, dynamic>();
      vitals["doctor"] = call.receiverName;
      vitals["doctor_id"] = call.receiverId;
      vitals["patient_id"] = call.callerId;
      vitals["user_id"] = call.userId;
      vitals["temperature"] = null;
      vitals["otoscope"] = null;
      vitals["heart_audio"] = null;
      vitals["lungs_audio"] = null;
      vitals["abdomen_audio"] = null;
      vitals["skin_image"] = null;
      vitals["eye_image"] = null;
      vitals["dental_video"] = null;
      vitals["rx"] = null;
      vitals["spo2"] = null;
      vitals["bp_reading"] = null;
      vitals["patient_details"] = call.patient;
      vitals["temperature_image"] = null;
      vitals["spo2_image"] = null;
      vitals["xtra_files"] = null;
      vitals["ecg"] = null;
      vitals["eye_pdf"] = null;
      vitals["peakFlow"] = null;
      vitals["date"] = now;

      await callDetailCollection.doc(docId).set(vitals);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addVitals({Call call, String name, String value}) async {
    try {
      String docId =
          call.receiverId + "-" + call.callerId + "-" + call.channelId;
      Map<String, dynamic> vitals = Map();
      vitals[name] = value;
      await callDetailCollection.doc(docId).update(vitals);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addFile({Call call, String url, String name, int ind}) async {
    try {
      String docId =
          call.receiverId + "-" + call.callerId + "-" + call.channelId;
      Map<String, dynamic> vitals = Map();

      if (name == "abdomen_audio") {
        abdomen_audio[ind] = url;

        vitals[name] = abdomen_audio;
      } else if (name == "heart_audio") {
        heart_audio[ind] = url;
        vitals[name] = heart_audio;
      } else if (name == "lungs_audio") {
        lungs_audio[ind] = url;
        vitals[name] = lungs_audio;
      } else if (name == "otoscope") {
        otoscope.add(url);
        vitals[name] = otoscope;
      } else if (name == "skin_image") {
        skin_image.add(url);
        vitals[name] = skin_image;
      } else if (name == "dental_video") {
        dental_video.add(url);
        vitals[name] = dental_video;
      } else if (name == "eye_image") {
        eye_image.add(url);
        vitals[name] = eye_image;
      } else if (name == "bp_reading") {
        String bpReading = url;
        vitals[name] = bpReading;
      } else if (name == "spo2_image") {
        spo2_image.add(url);
        vitals[name] = spo2_image;
      } else if (name == "temperature_image") {
        print(temperature_image.length);
        temperature_image.add(url);
        vitals[name] = temperature_image;
      } else if (name == "xtra_files") {
        xtra_files.add(url);
        vitals[name] = xtra_files;
      } else if (name == "ecg") {
        ecg.add(url);

        vitals[name] = ecg;
      } else if (name == "eye_pdf") {
        eye_pdf.add(url);

        vitals[name] = eye_pdf;
      }
      print(vitals);

      await callDetailCollection.doc(docId).update(vitals);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
