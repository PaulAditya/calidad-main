import 'dart:async';

import 'package:usb_serial/usb_serial.dart';

class DeviceUtils {

 

  Future<List<UsbDevice>> getPorts() async {
    List<UsbDevice> devices = [];
    devices = await UsbSerial.listDevices();
    return devices;
  }

}