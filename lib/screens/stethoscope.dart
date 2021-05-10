import 'dart:async';
import 'dart:io';
import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/utils/call_utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

import 'package:provider/provider.dart';

class Stethoscope extends StatefulWidget {
  const Stethoscope({Key key, @required this.call,@required this.fileName}) : super(key: key);
  final Call call;
  final String fileName;
  @override
  _StethoscopeState createState() => _StethoscopeState();
}

Future<String> _localPath() async {
  final directory = await getExternalStorageDirectory();
  return directory.path;
}

class _StethoscopeState extends State<Stethoscope> {
  bool _isUploading = false;
  bool _isRecording = false;
  FlutterAudioRecorder recorder;

  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            title: const Text('Stethoscope'),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 60.0,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Icon(
                        _isRecording
                            ? Icons.pause
                            : Icons.radio_button_checked_rounded,
                        color: Colors.white,
                      )),
                    ),
                    onTap: () async {
                      if (_isRecording) {
                        _stopRecording();
                      } else {
                        _record();
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isUploading = !_isUploading;
                      });
                      await uploadToStorage(user.getUser.uid, widget.fileName).then((value) {
                        setState(() {
                          _isUploading = !_isUploading;
                        });
                      });
                    },
                    child: !_isUploading?Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[900],
                      ),
                      height: 60,
                      width: 80,
                      child:  Icon(
                              Icons.upload_outlined,
                              color: Colors.white,
                            )
                      
                    
                         
                    ) : Container(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(backgroundColor: Colors.white,)),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  _stopRecording() async {
    await recorder.stop().then((value) {
      setState(() {
        _isRecording = false;
      });
    });
  }

  _record() async {
    var filename = await _localPath();
    File file = File(filename+'/${widget.fileName}.wav');
    
    if(await file.exists()){
      await file.delete();
    }

    recorder = new FlutterAudioRecorder(filename + '/${widget.fileName}.wav',
        sampleRate: 22000, audioFormat: AudioFormat.WAV);

    await recorder.initialized;
    await recorder.start().then((value) {
      setState(() {
        _isRecording = true;
      });
    });
  }

  Future uploadToStorage(String uid, String fileName) async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + uid);
      final String today = ('$month-$date');
      String dir = await _localPath();

      File file = File(dir + '/${widget.fileName}.wav');

      
      setState(() {
        _isUploading = true;
      });
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("audio")
          .child(today)
          .child(storageId + '.wav');
      UploadTask uploadTask =
          ref.putFile(file, SettableMetadata(contentType: 'audio/wav'));

      String url = await uploadTask.then((e) async {
        return await ref.getDownloadURL();
      });

      CallUtils cu = CallUtils();
      await cu.addFile(widget.call, url, fileName);
    } catch (error) {
      print(error);
    }
  }
}
