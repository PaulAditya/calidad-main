class CallDetails {
  Map rx;
  Map patientDetails;

  CallDetails({this.rx, this.patientDetails});

  Map toMap() => {"rx": rx, "patient_details": patientDetails};

  CallDetails.fromMap(Map<String, dynamic> callDetails) {
    this.patientDetails = callDetails['patient_details'];
    this.rx = callDetails['rx'];
  }
}
