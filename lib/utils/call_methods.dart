import 'package:calidad_app/model/call.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("call");

  final CollectionReference callDetailCollection =
      FirebaseFirestore.instance.collection("callDetails");

  List abdomen_audio = [];
  List heart_audio = [];
  List lungs_audio = [];

  

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
      vitals["spo2"] = null;
      await callDetailCollection.doc(docId).set(vitals);
       abdomen_audio = ["null","null","null","null"];
   heart_audio = ["null","null","null","null"];
   lungs_audio = ["null","null","null","null","null","null","null","null"];
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

  Future<bool> addFile({Call call, String url, String name, }) async {
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

  Future<bool> addAudioFile({Call call, String url, String name, int ind }) async {
    try {
      String docId =
          call.receiverId + "-" + call.callerId + "-" + call.channelId;
      Map<String, dynamic> vitals = Map();
      
      if(name == "abdomen_audio"){
       
        abdomen_audio.insert(ind, url);
      
       
      vitals[name] = abdomen_audio;
     }else if(name == "heart_audio"){
      heart_audio.insert(ind, url);
       vitals[name] = heart_audio;
    
     }else if(name == "lungs_audio"){
      lungs_audio.insert(ind, url);
       vitals[name] = lungs_audio;
       
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
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
