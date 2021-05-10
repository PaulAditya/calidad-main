import 'package:calidad_app/model/doctor.dart';
import 'package:calidad_app/model/user.dart';
import 'package:calidad_app/utils/firebaseMethods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<Users> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<Users> signInWithGoogle() => _firebaseMethods.signInWithGoogle();

  Future<Users> signInWithEmailPass(String email, String password) =>
      _firebaseMethods.signInWithEmailPass(email, password);

  Future<List<Doctor>> getDoctors() => _firebaseMethods.getDoctors();

  Future<String> getPrescription(call) =>
      _firebaseMethods.getPrescription(call);

  Future<Users> signUpWithEmailPassword(String email, String password) =>
      _firebaseMethods.signUpWithEmailPassword(email, password);
}
