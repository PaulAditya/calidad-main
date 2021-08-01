import 'package:calidad_app/model/patient.dart';

class AppointmentDetails {
  String uid;
  String rx;
  Patient patientDetails;
  String doctor;
  // String otoscope;
  // String temp;
  // String spo2;
  // String lungsAudio;
  // String heartAudio;
  // String abdomenAudio;
  // String dentalVideo;

  AppointmentDetails({this.uid, this.rx, this.patientDetails, this.doctor});

  AppointmentDetails.fromMap(Map map) {
    if (map["rx"] != null && map["rx"].toString().length > 0)
      this.rx = map["rx"];
    this.patientDetails = Patient.fromMap(map["patient_details"]);
    this.uid = map["patient_id"];
    this.doctor = map["doctor"];
  }
}
