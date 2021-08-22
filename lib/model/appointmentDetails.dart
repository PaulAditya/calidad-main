import 'package:calidad_app/model/patient.dart';

class AppointmentDetails {
  String uid;
  Map rx;
  Patient patientDetails;
  String doctor;
  String doctorId;
  String channeId;
  // String otoscope;
  // String temp;
  // String spo2;
  // String lungsAudio;
  // String heartAudio;
  // String abdomenAudio;
  // String dentalVideo;

  AppointmentDetails(
      {this.uid,
      this.rx,
      this.patientDetails,
      this.doctor,
      this.doctorId,
      this.channeId});

  AppointmentDetails.fromMap(Map map) {
    if (map["rx"] != null && map["rx"].toString().length > 0)
      this.rx = map["rx"];
    this.patientDetails = Patient.fromMap(map["patient_details"]);
    this.uid = map["user_id"];
    this.doctor = map["doctor"];
    this.doctorId = map["doctor_id"];
    this.channeId = map["channel_id"];
  }
}
