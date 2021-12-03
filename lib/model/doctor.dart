class Doctor {
  String uid;
  String name;
  String rating;
  bool isAvailable;
  String speciality;
  String from;
  String till;
  String experience;
  String email;
  String qualification;
  String address;
  String signature;

  Doctor(
      {this.address,
      this.uid,
      this.name,
      this.rating,
      this.isAvailable,
      this.speciality,
      this.email,
      this.from,
      this.till,
      this.experience,
      this.qualification,
      this.signature});

  Map toMap(Doctor doc) {
    var data = Map<String, dynamic>();
    data['address'] = doc.address;
    data['uid'] = doc.uid;
    data['from'] = doc.from;
    data['till'] = doc.till;
    data['qualification'] = doc.qualification;
    data['experience'] = doc.experience;
    data['email'] = doc.email;
    data['name'] = doc.name;
    data['rating'] = doc.rating;
    data['isAvailable'] = doc.isAvailable;
    data['speciality'] = doc.speciality;
    data['sign'] = doc.signature;

    return data;
  }

  Doctor.fromMap(Map<dynamic, dynamic> mapData) {
    this.address = mapData['address'];
    this.email = mapData['email'];
    this.experience = mapData['experience'];
    this.from = mapData['from'];
    this.till = mapData['till'];
    this.qualification = mapData['qualification'];
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.rating = mapData['rating'];
    this.isAvailable = mapData['isAvailable'];
    this.speciality = mapData['speciality'];
    this.signature = mapData['sign'];
  }
}
