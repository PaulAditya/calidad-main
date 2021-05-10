import 'dart:async';
import 'dart:math';

import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/screens/call_screen.dart';
import 'package:calidad_app/utils/call_methods.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  static dial(
      {@required Users patient, @required Doctor doctor, context}) async {
    Call call = Call(
      callerId: patient.uid,
      callerName: patient.username,
      callerPic: patient.profilePhoto,
      receiverId: doctor.uid,
      receiverName: doctor.name,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
    return false;
  }

  static endCall(Call call) async {
    bool res = await callMethods.endCall(call: call);
    return res;
  }

  Future<bool> addTemperature({Call call, String temp}) {
    return callMethods.addTemperature(call: call, temp: temp);
  }

  Future<bool> addFile(Call call, String url, String fileName) {
    return callMethods.addFile(call: call, url: url, name: fileName);
  }

  
}
