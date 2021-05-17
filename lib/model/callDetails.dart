class CallDetails {
  String otoscope;
  String temperature;
  List heartAudio;
  List lungsAudio;
  List abdomenAudio;
  String skinImage;
  String dentalVideo;
  String spo2;
  String rx;

  CallDetails(
      {this.skinImage,
      this.dentalVideo,
      this.otoscope,
      this.lungsAudio,
      this.heartAudio,
      this.abdomenAudio,
      this.spo2,
      this.temperature,
      this.rx});

  CallDetails.fromMap(Map<String,dynamic> callDetails) {
    this.otoscope = callDetails['otoscope'];
    this.heartAudio = callDetails['heart_audio'];
    this.temperature = callDetails['temperature'];
    this.rx = callDetails['rx'];
    this.abdomenAudio = callDetails['abdomen_audio'];
    this.lungsAudio = callDetails['lungs_audio'];
    this.spo2 = callDetails['spo2'];
    this.skinImage = callDetails['skin_image'];
    this.dentalVideo = callDetails['dental_video'];
  }
}
