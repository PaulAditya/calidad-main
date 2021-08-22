import 'package:calidad_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection("users");

  Users users = Users();

  Future<Users> getCurrentUser() async {
    User firebaseUser;
    Users user;
    try {
      firebaseUser = _auth.currentUser;
      user = users.fromUser(firebaseUser);
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<Users> signInWithEmailPass(String email, String password) async {
    Users user;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = cred.user;
      user = users.fromUser(firebaseUser);
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<Users> signUpWithEmailPassword(String email, String password) async {
    Users user;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = cred.user;
      user = users.fromUser(firebaseUser);
      return user;
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<bool> authenticateUser(Users user) async {
    try {
      QuerySnapshot result =
          await _userCollection.where("email", isEqualTo: user.email).get();

      final List<DocumentSnapshot> docs = result.docs;

      return docs.length == 0 ? false : true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> addDataToDb(Users currentUser) async {
    try {
      Users user = Users(
          uid: currentUser.uid,
          email: currentUser.email,
          profilePhoto: currentUser.profilePhoto,
          username: currentUser.username,
          patients: <Map>[]);

      _userCollection.doc(currentUser.uid).set(users.toMap(user));
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<Users> signInWithGoogle() async {
    Users user;
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      UserCredential authResult = await _auth.signInWithCredential(credential);
      User firebaseUser = authResult.user;
      user = users.fromUser(firebaseUser);
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }
}
