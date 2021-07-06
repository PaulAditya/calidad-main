class Patient {
  String id;
  String name;
  String age;
  String weight;
  String height;
  String gender;

  Patient(String id, String name, String age, String weight, String height,
      String gender) {
    this.id = id;
    this.name = name;
    this.age = age;
    this.weight = weight;
    this.height = height;
    this.gender = gender;
  }

  Map toJson() => {
        'name': name,
        'age': age,
        'weight': weight,
        'height': height,
        'gender': gender,
        'id': id
      };

  Patient.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData["id"];
    this.name = mapData['name'];
    this.age = mapData['age'];
    this.weight = mapData['weight'];
    this.height = mapData['height'];
    this.gender = mapData['gender'];
  }
}
