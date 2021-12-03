import 'dart:convert';
import 'dart:typed_data';

import 'package:calidad_app/model/callDetails.dart';
import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';
import 'package:calidad_app/model/prescription.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/services.dart';

class PrintPrescription extends StatefulWidget {
  final Map callDetails;
  const PrintPrescription({Key key, @required this.callDetails})
      : super(key: key);

  @override
  _PrintPrescriptionState createState() => _PrintPrescriptionState();
}

class _PrintPrescriptionState extends State<PrintPrescription> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice _device;
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  Future<List<LineText>> preparePrescription(
      Doctor doctor, CallDetails details) async {
    List<LineText> list = [];
    Prescription prescription = new Prescription(doctor, details);
    Map presMap = new Map();
    presMap = prescription.toMap();

    presMap.forEach((key, value) {
      if (value == null) {
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "$key - NOT AVAILABLE",
            weight: 1,
            align: LineText.ALIGN_LEFT,
            linefeed: 1));
      } else {
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "$key - $value",
            weight: 1,
            align: LineText.ALIGN_LEFT,
            linefeed: 1));
      }
    });
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(doctor.signature))
            .load(doctor.signature))
        .buffer
        .asUint8List();
    List<int> imageBytes = bytes;
    String base64Image = base64Encode(imageBytes);
    list.add(LineText(
        
        type: LineText.TYPE_IMAGE,
        content: base64Image,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    Patient patient = widget.callDetails["patient"];
    Doctor doctor = widget.callDetails["doctor"];
    CallDetails details = widget.callDetails["callDetails"];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Print Prescription'),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(tips),
                    ),
                  ],
                ),
                Divider(),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data
                        .map((d) => ListTile(
                              title: Text(d.name ?? ''),
                              subtitle: Text(d.address),
                              onTap: () async {
                                setState(() {
                                  _device = d;
                                });
                              },
                              trailing: _device != null &&
                                      _device.address == d.address
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                            ))
                        .toList(),
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                            child: Text('connect'),
                            onPressed: _connected
                                ? null
                                : () async {
                                    if (_device != null &&
                                        _device.address != null) {
                                      await bluetoothPrint.connect(_device);
                                    } else {
                                      setState(() {
                                        tips = 'please select device';
                                      });
                                    }
                                  },
                          ),
                          SizedBox(width: 10.0),
                          OutlinedButton(
                            child: Text('disconnect'),
                            onPressed: _connected
                                ? () async {
                                    await bluetoothPrint.disconnect();
                                  }
                                : null,
                          ),
                        ],
                      ),
                      OutlinedButton(
                        child: Text('Print Prescription'),
                        onPressed: _connected
                            ? () async {
                                Map<String, dynamic> config = Map();
                                List<LineText> list = [];
                                list =
                                    await preparePrescription(doctor, details);

                                await bluetoothPrint.printReceipt(config, list);
                              }
                            : null,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () =>
                      bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }
}
