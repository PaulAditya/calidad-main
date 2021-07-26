import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/provider/userProvider.dart';

import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

class ECG extends StatefulWidget {
  final Call call;
  const ECG({
    Key key,
    @required this.call,
  }) : super(key: key);

  @override
  _ECGState createState() => _ECGState();
}

class _ECGState extends State<ECG> {
  bool _isLoading = false;

  bool _uploading = false;
  double _progress;
  Map task;

  TextEditingController _description = new TextEditingController();
  final FirebaseRepository _repo = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);

    UploadTask uploadTask;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("ECG"),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = !_isLoading;
                            });
                            Map map = await _repo.getUploadTask(
                                user.getUser.uid, false, false, true);

                            setState(() {
                              _uploading = true;
                            });
                            if (map != null) {
                              uploadTask = map["uploadTask"];
                              uploadTask.snapshotEvents.listen((event) {
                                setState(() {
                                  _progress =
                                      (((event.bytesTransferred.toDouble() /
                                                  1024.0) /
                                              (event.totalBytes.toDouble() /
                                                  1024.0) *
                                              100)) /
                                          100.toDouble();
                                });
                              });
                              _repo
                                  .uploadToStorage(
                                map,
                                widget.call,
                                "ecg",
                              )
                                  .then((value) {
                                if (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Uploaded Succesfully")));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Try Again")));
                                }
                                setState(() {
                                  _uploading = false;
                                  _isLoading = !_isLoading;
                                });
                              });
                            } else {
                              setState(() {
                                _uploading = false;
                                _isLoading = !_isLoading;
                              });
                            }
                          },
                          child: !_isLoading
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue[900],
                                  ),
                                  height: 40,
                                  width: 60,
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.white,
                                  ))
                              : Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ))))),
            ),
            _uploading
                ? Container(
                    color: Colors.transparent,
                    child: Center(
                      child: CircularProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue)),
                    ),
                  )
                : Container()
          ],
        ));
  }
}
