class Patient {
  String id;
  String name;
  String age;
  String weight;
  String height;
  String gender;
  String mobile;
  String location;
  String email;
  List allowedDoctors;

  Patient(
      String id,
      String name,
      String age,
      String weight,
      String height,
      String gender,
      String mobile,
      String email,
      String location,
      List allowedDoctors) {
    this.id = id;
    this.name = name;
    this.age = age;
    this.weight = weight;
    this.height = height;
    this.gender = gender;
    this.mobile = mobile;
    this.email = email;
    this.location = location;
    this.allowedDoctors = allowedDoctors;
  }

  Map toJson() => {
        'name': name,
        'age': age,
        'weight': weight,
        'height': height,
        'gender': gender,
        'id': id,
        'mobile': mobile,
        'location': location,
        "email": email,
        "allowedDoctors": allowedDoctors
      };

  Patient.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData["id"];
    this.name = mapData['name'];
    this.age = mapData['age'];
    this.weight = mapData['weight'];
    this.height = mapData['height'];
    this.gender = mapData['gender'];
    this.mobile = mapData['mobile'];
    this.email = mapData['email'];
    this.location = mapData['location'];
    this.allowedDoctors = mapData['allowedDoctors'];
  }
}
