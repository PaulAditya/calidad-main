import 'dart:async';
import 'dart:typed_data';

import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/utils/call_utils.dart';
import 'package:calidad_app/utils/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class Spo2Screen extends StatefulWidget {
  const Spo2Screen({Key key, this.call}) : super(key: key);

  @override
  _Spo2ScreenState createState() => _Spo2ScreenState();
  final Call call;
}

class _Spo2ScreenState extends State<Spo2Screen> {
  UsbDevice device;

  int counter = 0;
  bool deviceState = false;
  List<String> _stream = [];
  List<UsbDevice> _ports = [];
  List<Widget> _serialData = [];
  bool isLoading = false;
  StreamSubscription usb;

  DeviceUtils dv = DeviceUtils();

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
        print(line);
        _stream.add(line);
      });

      Timer(Duration(seconds: 30), () {
        _subscription.cancel();
        _transaction = null;
        res = avgSpo2(_stream);

        CallUtils callutils = CallUtils();
        callutils.addTemperature(
            call: widget.call, value: res.toString(), name: "spo2");
        setState(() {
          _serialData.add(Text(
            res.toString(),
            style: TextStyle(color: Colors.black),
          ));

          deviceState = !deviceState;
        });
        _stream.clear();
      });
    }
  }

  double avgSpo2(List<String> stream) {
    double spo2 = 0;
    spo2 = double.parse(stream.last);

    return spo2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("SpO2"),
      ),
      backgroundColor: Colors.white,
      body: Container(
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
                          SizedBox(height: 20),
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
                                      height: 20,
                                      width: 20,
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
    );
  }
}
