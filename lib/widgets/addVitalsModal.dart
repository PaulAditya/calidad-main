
import 'package:calidad_app/model/call.dart';
import 'package:calidad_app/screens/otoscope.dart';
import 'package:calidad_app/screens/stethoscope.dart';
import 'package:calidad_app/screens/temperature_input.dart';
import 'package:calidad_app/widgets/deviceCard.dart';
import 'package:flutter/material.dart';

class AddVitalModal extends StatelessWidget {
  final Call call;

  const AddVitalModal({Key key, @required this.call}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Center(
              child: Icon(
                Icons.arrow_drop_down,
                size: 40,
                color: Colors.blue[900],
              ),
            ),
          ),
          Container(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                DeviceCard(image: 'assets/thermometer.png', title: 'Temperature', page: Temperature(call: call)),
                DeviceCard(image: 'assets/otoscope.png', title: 'Otoscope', page: Otoscope(call: call, fileName: "otoscope",camera: false,)),
                DeviceCard(image: 'assets/dental.png', title: 'Dental', page: Otoscope(call: call, fileName: "dental_video", camera: false,)),
                DeviceCard(image: 'assets/stethoscope.png', title: 'Heart Sound', page: Stethoscope(call: call, fileName: "heart_audio",)),
                DeviceCard(image: 'assets/lungs.png', title: 'Lung Sound', page: Stethoscope(call: call, fileName: "lungs_audio",)),
                DeviceCard(image: 'assets/stomach.png', title: 'Abdomen', page: Stethoscope(call: call, fileName: "abdomen_audio",)),
                DeviceCard(image: 'assets/dermis.png', title: 'Skin', page: Otoscope(call: call, fileName: "skin_image", camera: true,)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
