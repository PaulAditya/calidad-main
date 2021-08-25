import 'package:calidad_app/model/callDetails.dart';
import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/patient.dart';

class Prescription {
  String patientName;
  String patientAge;
  String patientGender;
  String patientMobile;
  String doctorName;
  String doctorQualification;
  String doctorSpeciality;
  String doctorExperience;
  String medicine;
  String chiefComplaints;
  String history;
  String examinations;
  String specialInstruction;
  String investigations;

  Prescription(Doctor doctor, CallDetails details) {
    this.patientName = details.patientDetails["name"];
    this.patientAge = details.patientDetails["age"];
    this.patientGender = details.patientDetails["gender"];
    this.patientMobile = details.patientDetails["mobile"];
    this.doctorExperience = doctor.experience;
    this.doctorName = doctor.name;
    this.doctorQualification = doctor.qualification;
    this.doctorSpeciality = doctor.speciality;
    this.medicine = details.rx["medicines"];
    this.examinations = details.rx["exams"];
    this.chiefComplaints = details.rx["chiefComplaints"];
    this.history = details.rx["history"];
    this.specialInstruction = details.rx["specials"];
    this.investigations = details.rx["investigations"];
  }

  Map toMap() {
    Map res = new Map();
    res["patientName"] = this.patientName;
    res["patientAge"] = this.patientAge;
    res["patientGender"] = this.patientGender;
    res["patientMobile"] = this.patientMobile;
    res["doctorName"] = this.doctorName;
    res["doctorExperience"] = this.doctorExperience;
    res["doctorQualification"] = this.doctorQualification;
    res["doctorSpeciality"] = this.doctorSpeciality;
    res["medicine"] = this.medicine;
    res["specialInstruction"] = this.specialInstruction;
    res["history"] = this.history;
    res["investigations"] = this.investigations;
    res["examinations"] = this.examinations;
    res["chiefComplaints"] = this.chiefComplaints;
    return res;
  }
}
