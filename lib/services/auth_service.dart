import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String?> get onAuthStateChange => _firebaseAuth.authStateChanges().map(
        (event) => event?.uid,
      );

  //email and password Sign Up
  Future<String?> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    //update the username
    await _firebaseAuth.currentUser?.updateDisplayName(name);
    await _firebaseAuth.currentUser?.reload();
    return _firebaseAuth.currentUser?.uid;
  }

  //Email & Password Sign In
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        ?.uid;
  }

  //SIgnOut
  signOut() {
    return _firebaseAuth.signOut();
  }

  Future<bool> isUserConnected() async {
    await Firebase.initializeApp();
    // String errorMsg;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}
