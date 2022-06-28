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
}