import 'dart:async';
import 'dart:math';

import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/screens/call_screen.dart';
import 'package:calidad_app/utils/call_methods.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  static dial(
      {@required Users user,
      @required Doctor doctor,
      @required Map patient,
      context}) async {
    Call call = Call(
        callerId: user.uid,
        callerName: user.username,
        callerPic: user.profilePhoto,
        receiverId: doctor.uid,
        receiverName: doctor.name,
        channelId: Random().nextInt(1000).toString(),
        patient: patient);

    bool callMade = await callMethods.makeCall(call: call);

    if (callMade) {
      Navigator.pushReplacement(
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

  Future<bool> addTemperature({Call call, String value, String name}) {
    return callMethods.addTemperature(call: call, name: name, value: value);
  }

  Future<bool> addFile({Call call, String url, String fileName, int index}) {
    return callMethods.addFile(
        call: call, url: url, name: fileName, ind: index);
  }
}
