import 'package:e_course_app/services/database_service.dart';
import 'package:e_course_app/services/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Stream<User?> firebaseUserStream = _auth.authStateChanges();

  static Future<User?> signinWithEmailPassword(String email, String password) async {
    try {
      Map<String, dynamic>? userData = await DatabaseService.getUserByEmail(email);
      if (userData != null) {
          LocalStorageService.localStorage.setStringList('user', <String> [userData['name'], userData['role'], email]);
          UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
          User? firebaseUser = result.user;
          if (firebaseUser != null && firebaseUser.email != null) {
            return firebaseUser;
          } else {
            signOut();
            return null;
          }
      } else {
        return null;
      }
    } on Exception catch(e) {
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}