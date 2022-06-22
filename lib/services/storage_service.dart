import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final storage = FirebaseStorage.instance;

  static Reference getRef(String ref) {
    return storage.ref(ref);
  }
}
