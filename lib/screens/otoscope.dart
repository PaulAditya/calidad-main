import 'dart:io';

import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/provider/userProvider.dart';

import 'package:calidad_app/utils/call_utils.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Otoscope extends StatefulWidget {
  final Call call;
  final String fileName;
  final bool camera;
  const Otoscope(
      {Key key, this.call, @required this.fileName, @required this.camera})
      : super(key: key);

  @override
  _OtoscopeState createState() => _OtoscopeState();
}

class _OtoscopeState extends State<Otoscope> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Otoscope"),
      ),
      body: Container(
          child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isLoading = !_isLoading;
                });
                await uploadToStorage(user.getUser.uid, widget.fileName)
                    .then((value) {
                  setState(() {
                    _isLoading = !_isLoading;
                  });
                });
              },
              child: !_isLoading
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[900],
                      ),
                      height: 60,
                      width: 80,
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
            SizedBox(width: 40),
            Container(
              child: !widget.camera
                  ? GestureDetector(
                      onTap: () async {
                        await LaunchApp.openApp(
                          androidPackageName: 'com.shenyaocn.android.usbcamera',
                          openStore: true,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue[900],
                        ),
                        height: 60,
                        width: 80,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            )
          ],
        ),
      )),
    );
  }

  Future uploadToStorage(String uid, String fileName) async {
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

      if (widget.camera) {
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
      await cu.addFile(widget.call, url, fileName);
    } catch (error) {
      print(error);
    }
  }
}
