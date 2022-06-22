import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  static FirebaseFirestore store = FirebaseFirestore.instance;

  static CollectionReference videoCollection() {
    return store.collection('videos');
  }
}