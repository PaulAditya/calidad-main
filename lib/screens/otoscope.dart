import 'dart:io';

import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/provider/userProvider.dart';

import 'package:calidad_app/utils/call_utils.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Otoscope extends StatefulWidget {
  final Call call;
  final String fileName;
  final bool camera;
  final bool gallery;
  final bool recorder;
  const Otoscope(
      {Key key,
      this.call,
      @required this.fileName,
      @required this.camera,
      @required this.gallery,
      @required this.recorder})
      : super(key: key);

  @override
  _OtoscopeState createState() => _OtoscopeState();
}

class _OtoscopeState extends State<Otoscope> {
  bool _isLoadingCamera = false;
  bool _isLoadingGallery = false;

  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("Otoscope"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Center(
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
                          await uploadToStorage(user.getUser.uid,
                                  widget.fileName, widget.camera, widget.call)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Uploaded Succesfully")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Try Again")));
                            }
                            setState(() {
                              _isLoadingCamera = !_isLoadingCamera;
                            });
                          });
                        },
                        child: !_isLoadingCamera
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                                width: 60,
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )),
                      )
                    : Container(),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isLoadingGallery = !_isLoadingGallery;
                    });
                    await uploadToStorage(user.getUser.uid, widget.fileName,
                            false, widget.call)
                        .then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Uploaded Succesfully")));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Try Again")));
                      }
                      setState(() {
                        _isLoadingGallery = !_isLoadingGallery;
                      });
                    });
                  },
                  child: !_isLoadingGallery
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
                          height: 40,
                          width: 60,
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )),
                )
              ],
            )),
          ),
        ));
  }

  Future<bool> uploadToStorage(
      String uid, String fileName, bool camera, Call call) async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + uid);
      final String today = ('$month-$date');
      ImagePicker img = ImagePicker();
      UploadTask uploadTask;
      Reference ref;

      if (camera) {
        final pickedfile = await img.getImage(source: ImageSource.camera);
        File file = File(pickedfile.path);

        ref = FirebaseStorage.instance
            .ref()
            .child("image")
            .child(today)
            .child(storageId);
        uploadTask =
            ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        final pickedfile = await img.getVideo(source: ImageSource.gallery);
        File file = File(pickedfile.path);

        ref = FirebaseStorage.instance
            .ref()
            .child("video")
            .child(today)
            .child(storageId);
        uploadTask =
            ref.putFile(file, SettableMetadata(contentType: 'video/mp4'));
      }
      String url = await uploadTask.then((e) async {
        return await ref.getDownloadURL();
      });

      CallUtils cu = CallUtils();
      await cu.addFile(
        call: call,
        url: url,
        fileName: fileName,
      );
      return true;
    } catch (error) {
      print(error);
    }
    return false;
  }
}
