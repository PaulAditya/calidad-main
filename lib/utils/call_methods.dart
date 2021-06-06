import 'package:calidad_app/model/call.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("call");

  final CollectionReference callDetailCollection =
      FirebaseFirestore.instance.collection("callDetails");

  List<dynamic> abdomen_audio = [null, null, null, null];
  List<dynamic> heart_audio = [null, null, null, null];
  List<dynamic> lungs_audio = [null, null, null, null, null, null, null, null];
  List<dynamic> skin_image = [];
  List<dynamic> otoscope = [];
  List<dynamic> dental_video = [];
  List<dynamic> eye_image = [];

  Future<bool> makeCall({Call call}) async {
    try {
      Map<String, dynamic> map = call.toMap(call);
      String docId =
          call.receiverId + "-" + call.callerId + "-" + call.channelId;
      await callCollection.doc(call.receiverId).set(map);
      Map<String, dynamic> vitals = Map<String, dynamic>();
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
      vitals["patient_details"] = call.patient;
      await callDetailCollection.doc(docId).set(vitals);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addTemperature({Call call, String name, String value}) async {
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
      }

      await callDetailCollection.doc(docId).update(vitals);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      abdomen_audio.clear();
      heart_audio.clear();
      lungs_audio.clear();
      dental_video.clear();
      otoscope.clear();
      skin_image.clear();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
