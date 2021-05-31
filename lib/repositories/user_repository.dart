import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class UserRepository {
  UserRepository(
    this.firebaseFirestore,
    this.firebaseStorage,
    this.sharedPreferences,
  );

  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final SharedPreferences sharedPreferences;

  Future<DocumentReference> get _userDocument async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.doc('/users/$userId');
  }

  Future<ApiResponse> setUser(User user) async {
    try {
      final userId = sharedPreferences.getString(Constants.USER_ID);
      firebaseFirestore.collection('/users').doc(userId).set(user.toJson());
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Stream<DocumentSnapshot<User>> getUser() async* {
    final userDocument = await _userDocument;
    yield* userDocument
        .withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!) ?? User(),
            toFirestore: (user, _) => user.toJson())
        .snapshots();
  }

  Future<DocumentSnapshot<User>> getUserDocument() async {
    final userDocument = await _userDocument;
    return userDocument
        .withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!) ?? User(),
            toFirestore: (user, _) => user.toJson())
        .get();
  }
}
