import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  static FirebaseFirestore store = FirebaseFirestore.instance;

  static CollectionReference videoCollection() {
    return store.collection('videos');
  }

  static CollectionReference userCollection() {
    return store.collection('users');
  }

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    DocumentSnapshot<Object?> ds = await userCollection().doc(email).get();
    if (ds.data() != null) {
      return ds.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  static Future<void> createUser(String name, String email, String role) async {
    try {
      Map<String, String> userData = {
        'name': name,
        'role': role
      };
      await userCollection().doc(email).set(userData);
    } catch(e) {
      print('Error when creating user data : $e');
    }
  }

  static Future<void> 
  deleteVideo(String videoId) async {
    try {
      await videoCollection().doc(videoId).delete();
    } catch (e) {
      print('Error when deleting video : $e');
    }
  }
}