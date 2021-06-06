class Patient {
  String name;
  String age;
  String weight;
  String gender;

  Patient(String name, String age, String weight, String gender) {
    this.name = name;
    this.age = age;
    this.weight = weight;
    this.gender = gender;
  }

  Map toJson() =>
      {'name': name, 'age': age, 'weight': weight, 'gender': gender};

  Patient.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.age = mapData['age'];
    this.weight = mapData['weight'];
    this.gender = mapData['gender'];
  }
}
