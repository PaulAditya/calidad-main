import 'dart:async';
import 'dart:io';
import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/utils/call_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

import 'package:provider/provider.dart';

class Stethoscope extends StatefulWidget {
  const Stethoscope(
      {Key key,
      @required this.call,
      @required this.fileName,
      @required this.noOfFiles,
      @required this.imageName})
      : super(key: key);
  final Call call;
  final List imageName;
  final String fileName;
  final int noOfFiles;
  @override
  _StethoscopeState createState() => _StethoscopeState();
}

class _StethoscopeState extends State<Stethoscope> {
  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Stethoscope'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(height: 400.0),
                  items: widget.imageName.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          child: Image.asset(i),
                        );
                      },
                    );
                  }).toList(),
                ),
                // Container(
                //   height: 250,
                //   child: Image.asset('assets/${widget.imageName}'),
                // ),
                SizedBox(height: 20),
                Column(
                  children: List.generate(
                      widget.noOfFiles,
                      (index) => RecordUpload(
                          user: user,
                          index: index,
                          fileName: widget.fileName,
                          call: widget.call)),
                ),
              ],
            ),
          ),
        ));
  }
}

class RecordUpload extends StatefulWidget {
  const RecordUpload({Key key, this.user, this.index, this.fileName, this.call})
      : super(key: key);

  @override
  _RecordUploadState createState() => _RecordUploadState();
  final UserProvider user;
  final int index;
  final String fileName;
  final Call call;
}

class _RecordUploadState extends State<RecordUpload> {
  bool _isUploading = false;
  bool _isRecording = false;
  bool _isSent = false;
  FlutterAudioRecorder recorder;

  Future<String> _localPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  _stopRecording() async {
    await recorder.stop().then((value) {
      setState(() {
        _isRecording = false;
      });
    });
  }

  _record(int index) async {
    var filename = await _localPath();
    File file = File(filename + '/${widget.fileName}$index.wav');

    if (await file.exists()) {
      await file.delete();
    }

    recorder = new FlutterAudioRecorder(
        filename + '/${widget.fileName}$index.wav',
        sampleRate: 22000,
        audioFormat: AudioFormat.WAV);

    await recorder.initialized;
    await recorder.start().then((value) {
      setState(() {
        _isRecording = true;
      });
    });
  }

  Future<bool> uploadToStorage(String uid, String fileName, int index) async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + uid);
      final String today = ('$month-$date');
      String dir = await _localPath();

      File file = File(dir + '/${widget.fileName}$index.wav');

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
      await cu.addFile(
          call: widget.call, url: url, fileName: fileName, index: index);
      return true;
    } catch (error) {
      print(error);
    }
    return false;
  }

  @override
  void initState() {
    _isSent = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 60,
              child: _isSent
                  ? Icon(
                      Icons.done,
                      color: Colors.blue[900],
                      size: 14,
                    )
                  : Text(
                      (widget.index + 1).toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 14, color: Colors.blue[900]),
                    ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[900]),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
            ),
            GestureDetector(
              child: Container(
                height: 40.0,
                width: 60,
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
                  _record(widget.index);
                }
              },
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isUploading = !_isUploading;
                });
                await uploadToStorage(
                        widget.user.getUser.uid, widget.fileName, widget.index)
                    .then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Uploaded Succesfully")));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Try Again")));
                  }
                  setState(() {
                    _isSent = true;
                    _isUploading = !_isUploading;
                  });
                });
              },
              child: !_isUploading
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[900],
                      ),
                      height: 40,
                      width: 60,
                      child: Icon(
                        Icons.upload_outlined,
                        color: Colors.white,
                      ))
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
