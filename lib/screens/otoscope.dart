import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/provider/userProvider.dart';

import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Otoscope extends StatefulWidget {
  final Call call;
  final String fileName;
  final bool camera;
  final bool gallery;
  final bool recorder;
  final String pageName;
  final bool description;
  final bool pdf;
  final bool lowQuality;
  const Otoscope(
      {Key key,
      this.call,
      @required this.fileName,
      @required this.camera,
      @required this.gallery,
      @required this.recorder,
      @required this.pageName,
      @required this.description,
      @required this.pdf,
      @required this.lowQuality})
      : super(key: key);

  @override
  _OtoscopeState createState() => _OtoscopeState();
}

class _OtoscopeState extends State<Otoscope> {
  bool _isLoadingCamera = false;
  bool _isLoadingGallery = false;
  bool _uploading = false;
  bool _isLoadingPDf = false;
  double _progress;
  Map task;

  final FirebaseRepository _repo = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);

    UploadTask uploadTask;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(widget.pageName),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.recorder
                            ? Container(
                                child: GestureDetector(
                                  onTap: () async {
                                    await LaunchApp.openApp(
                                      androidPackageName:
                                          'com.shenyaocn.android.usbcamera',
                                      openStore: true,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue[900],
                                    ),
                                    height: 40,
                                    width: 60,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 40),
                        widget.camera
                            ? GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isLoadingCamera = !_isLoadingCamera;
                                  });
                                  Map map = await _repo.getUploadTask(
                                      user.getUser.uid,
                                      widget.camera,
                                      false,
                                      false,
                                      widget.lowQuality,
                                      context,
                                      widget.description);

                                  setState(() {
                                    _uploading = true;
                                  });
                                  if (map != null) {
                                    uploadTask = map["uploadTask"];
                                    uploadTask.snapshotEvents.listen((event) {
                                      setState(() {
                                        _progress = (((event.bytesTransferred
                                                        .toDouble() /
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
                                      widget.fileName,
                                    )
                                        .then((value) {
                                      if (value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Uploaded Succesfully")));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("Try Again")));
                                      }
                                      setState(() {
                                        _uploading = false;
                                        _isLoadingCamera = !_isLoadingCamera;
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      _uploading = false;
                                      _isLoadingCamera = !_isLoadingCamera;
                                    });
                                  }
                                },
                                child: !_isLoadingCamera
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue[900],
                                        ),
                                        height: 40,
                                        width: 60,
                                        child: Icon(
                                          Icons.camera,
                                          color: Colors.white,
                                        ))
                                    : Container(
                                        height: 40,
                                        width: 40,
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        )),
                              )
                            : Container(),
                        SizedBox(
                          width: 20,
                        ),
                        widget.gallery
                            ? GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isLoadingGallery = !_isLoadingGallery;
                                  });

                                  Map task = await _repo.getUploadTask(
                                      user.getUser.uid,
                                      widget.camera,
                                      true,
                                      false,
                                      false,
                                      context,
                                      widget.description);

                                  if (task != null) {
                                    setState(() {
                                      _uploading = true;
                                    });

                                    uploadTask = task["uploadTask"];
                                    uploadTask.snapshotEvents.listen((event) {
                                      setState(() {
                                        _progress = (((event.bytesTransferred
                                                        .toDouble() /
                                                    1024.0) /
                                                (event.totalBytes.toDouble() /
                                                    1024.0) *
                                                100)) /
                                            100.toDouble();
                                      });
                                    });
                                    _repo
                                        .uploadToStorage(
                                      task,
                                      widget.call,
                                      widget.fileName,
                                    )
                                        .then((value) {
                                      if (value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Uploaded Succesfully")));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("Try Again")));
                                      }
                                      setState(() {
                                        _uploading = false;
                                        _isLoadingGallery = !_isLoadingGallery;
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      _uploading = false;
                                      _isLoadingGallery = !_isLoadingGallery;
                                    });
                                  }
                                },
                                child: !_isLoadingGallery
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue[900],
                                        ),
                                        height: 40,
                                        width: 60,
                                        child: Icon(
                                          Icons.upload_outlined,
                                          color: Colors.white,
                                        ))
                                    : Container(
                                        height: 40,
                                        width: 40,
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        )),
                              )
                            : Container(),
                        SizedBox(width: 20),
                        widget.pdf
                            ? GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isLoadingPDf = !_isLoadingPDf;
                                  });
                                  Map map = await _repo.getUploadTask(
                                      user.getUser.uid,
                                      false,
                                      false,
                                      true,
                                      false,
                                      context,
                                      widget.description);

                                  setState(() {
                                    _uploading = true;
                                  });
                                  if (map != null) {
                                    uploadTask = map["uploadTask"];
                                    uploadTask.snapshotEvents.listen((event) {
                                      setState(() {
                                        _progress = (((event.bytesTransferred
                                                        .toDouble() /
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
                                      widget.fileName,
                                    )
                                        .then((value) {
                                      if (value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Uploaded Succesfully")));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("Try Again")));
                                      }
                                      setState(() {
                                        _uploading = false;
                                        _isLoadingPDf = !_isLoadingPDf;
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      _uploading = false;
                                      _isLoadingPDf = !_isLoadingPDf;
                                    });
                                  }
                                },
                                child: !_isLoadingPDf
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue[900],
                                        ),
                                        height: 40,
                                        width: 60,
                                        child: Icon(
                                          Icons.upload_file,
                                          color: Colors.white,
                                        ))
                                    : Container(
                                        height: 40,
                                        width: 40,
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        )))
                            : Container()
                      ],
                    )),
                    SizedBox(height: 40),
                  ],
                ),
              ),
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
