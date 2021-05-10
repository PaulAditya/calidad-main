import 'package:calidad_app/model/call.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("call");

  final CollectionReference callDetailCollection =
      FirebaseFirestore.instance.collection("callDetails");

  

  Future<bool> makeCall({Call call}) async {
    try {
      Map<String, dynamic> map = call.toMap(call);
      String docId =
          call.receiverId + "-" + call.callerId + "-" + call.channelId;
      await callCollection.doc(call.receiverId).set(map);
      Map<String,dynamic> vitals = Map<String,dynamic> ();
      vitals["temperature"] = null;
      vitals["otoscope"] = null;
      vitals["heart_audio"] = null;
      vitals["lungs_audio"] = null;
      vitals["abdomen_audio"] = null;
      vitals["skin_image"] = null;
      vitals["dental_video"] = null;
      vitals["rx"] = null;
      
      await callDetailCollection.doc(docId).set(vitals);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addTemperature({Call call, String temp}) async {
    try {
      String docId =
          call.receiverId + "-" + call.callerId + "-" + call.channelId;
      Map<String, dynamic> vitals = Map();
      vitals["temperature"] = temp;
      await callDetailCollection.doc(docId).update(vitals);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addFile({Call call, String url, String name}) async {
    try {
      String docId =
          call.receiverId + "-" + call.callerId + "-" + call.channelId;
      Map<String, String> vitals = Map();
      vitals[name] = url;
      await callDetailCollection.doc(docId).update(vitals);
      return true;
    } catch (e) {
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
