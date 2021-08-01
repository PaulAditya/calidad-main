import 'dart:async';

import 'dart:typed_data';

import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/provider/userProvider.dart';
import 'package:calidad_app/utils/call_utils.dart';

import 'package:calidad_app/utils/device_utils.dart';
import 'package:calidad_app/utils/firebaseRepository.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class Temperature extends StatefulWidget {
  const Temperature({Key key, @required this.call}) : super(key: key);

  @override
  _TemperatureState createState() => _TemperatureState();
  final Call call;
}

class _TemperatureState extends State<Temperature> {
  UsbDevice device;

  int counter = 0;
  bool deviceState = false;
  List<String> _stream = [];
  List<UsbDevice> _ports = [];
  List<Widget> _serialData = [];
  bool isLoading = false;
  StreamSubscription usb;

  DeviceUtils dv = DeviceUtils();
  bool _isLoadingCamera = false;
  bool _isLoadingGallery = false;
  double _progress;
  bool _uploading = false;
  bool _uploadingGallery = false;

  @override
  void initState() {
    super.initState();

    usb = UsbSerial.usbEventStream.listen((UsbEvent event) async {
      _ports = await dv.getPorts();

      setState(() {
        _serialData = [];
        if (_ports.length == 0) {
          device = null;
        } else {
          device = _ports[0];
        }
      });
    });

    _getPorts();
  }

  _getPorts() async {
    _ports = await dv.getPorts();
    setState(() {
      if (_ports.length == 0) {
        device = null;
      } else {
        device = _ports[0];
      }
    });
  }

  @override
  void dispose() {
    usb.cancel();
    super.dispose();
  }

  void connect(UsbDevice device) async {
    UsbPort _port;
    double res;
    Transaction<String> _transaction;
    StreamSubscription _subscription;

    if (device != null) {
      _port = await device.create();
      if (!await _port.open()) {
        return;
      }
      await _port.setDTR(true);
      await _port.setRTS(true);
      await _port.setPortParameters(
          115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

      _transaction = Transaction.stringTerminated(
          _port.inputStream, Uint8List.fromList([13, 10]));

      _subscription = _transaction.stream.listen((String line) {
        _stream.add(line);
      });

      Timer(Duration(seconds: 7), () {
        _subscription.cancel();
        _transaction = null;
        res = avgTemp(_stream);

        CallUtils callutils = CallUtils();
        callutils.addVitals(
            call: widget.call,
            value: "${res.toString()}*F",
            name: "temperature");
        setState(() {
          _serialData.add(Text(
            "${res.toString()}*F",
            style: TextStyle(color: Colors.black),
          ));

          deviceState = !deviceState;
        });
        _stream.clear();
      });
    }
  }

  double avgTemp(List<String> stream) {
    double f = 0;
    f = double.parse(stream.last.substring(0, 4));

    return f;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = Provider.of<UserProvider>(context, listen: false);
    Users user = up.getUser;
    FirebaseRepository _repo = FirebaseRepository();
    UploadTask uploadTask;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Temperature"),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              height: 200,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: isLoading
                  ? CircularProgressIndicator()
                  : device != null
                      ? Container(
                          child: Column(
                            children: [
                              Text("Device Connected"),
                              Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: !deviceState
                                      ? ElevatedButton(
                                          child: Text("Start"),
                                          onPressed: () async {
                                            setState(() {
                                              _serialData.clear();
                                              deviceState = !deviceState;
                                            });
                                            connect(device);
                                          },
                                        )
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          child: CircularProgressIndicator(),
                                        )),
                              ..._serialData
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                          "No Device Connected",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ))),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _isLoadingCamera = !_isLoadingCamera;
                  });
                  Map map = await _repo
                      .getUploadTask(
                          user.uid, true, false, false, true, context, false)
                      .then((value) {
                    setState(() {
                      _uploading = true;
                    });
                    return value;
                  });
                  uploadTask = map["uploadTask"];
                  uploadTask.snapshotEvents.listen((event) {
                    setState(() {
                      _progress =
                          ((((event.bytesTransferred.toDouble() / 1024.0)) /
                                  (event.totalBytes.toDouble() / 1024.0)))
                              .toDouble();
                      print(_progress);
                    });
                  });
                  await _repo
                      .uploadToStorage(
                    map,
                    widget.call,
                    "temperature_image",
                  )
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Uploaded Succesfully")));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Try Again")));
                    }
                    setState(() {
                      _uploading = false;
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
                    : _uploading
                        ? Container(
                            height: 40,
                            width: 40,
                            color: Colors.transparent,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: _progress,
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue)),
                            ),
                          )
                        : Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _isLoadingGallery = !_isLoadingGallery;
                  });
                  Map map = await _repo
                      .getUploadTask(
                          user.uid, false, true, false, true, context, false)
                      .then((value) {
                    setState(() {
                      _uploadingGallery = true;
                    });
                    return value;
                  });
                  uploadTask = map["uploadTask"];
                  uploadTask.snapshotEvents.listen((event) {
                    setState(() {
                      _progress =
                          ((((event.bytesTransferred.toDouble() / 1024.0)) /
                                  (event.totalBytes.toDouble() / 1024.0)))
                              .toDouble();
                    });
                  });
                  await _repo
                      .uploadToStorage(
                    map,
                    widget.call,
                    "temperature_image",
                  )
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Uploaded Succesfully")));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Try Again")));
                    }
                    setState(() {
                      _uploadingGallery = false;
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
                          Icons.upload_file,
                          color: Colors.white,
                        ))
                    : _uploadingGallery
                        ? Container(
                            height: 40,
                            width: 40,
                            color: Colors.transparent,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: _progress,
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue)),
                            ),
                          )
                        : Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )),
              )
            ],
          )
        ],
      ),
    );
  }
}
