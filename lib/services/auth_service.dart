import 'package:e_course_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Stream<User?> firebaseUserStream = _auth.authStateChanges();

  static Future<User?> signinWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;
      if (firebaseUser != null && firebaseUser.email != null) {
        Map<String, dynamic>? userData = await DatabaseService.getUserByEmail(firebaseUser.email!);
        if (userData != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList('user', <String> [userData['name'], userData['role'], firebaseUser.email ?? '']);
          print(prefs.getStringList('user'));
        } else {
          await signOut();
          return null;
        }
      } else {
        await signOut();
        return null;
      }
      return firebaseUser;
    } on Exception catch(e) {
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}