class CallDetails{
  String otoscope;
  String temperature;
  String stethoscope;
  String rx;

  CallDetails({this.otoscope,this.stethoscope,this.temperature,this.rx});

  CallDetails.fromMap(Map callDetails){
    
    this.otoscope = callDetails['otoscope'];
    this.stethoscope = callDetails['stethoscope'];
    this.temperature = callDetails['temperature'];
    this.rx = callDetails['rx'];
  
  }
}