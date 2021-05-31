import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/family.dart';
import '../models/family_member.dart';
import '../utils/constants.dart';
import '../utils/log.dart';

class FamilyRepository {
  FamilyRepository(
    this.firebaseFirestore,
    this.firebaseStorage,
    this.sharedPreferences,
  );

  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final SharedPreferences sharedPreferences;

  Future<CollectionReference> get _familiesCollection async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.collection('/users/$userId/families');
  }

  Future<DocumentReference> _familyCollection(String familyId) async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.doc('/users/$userId/families/$familyId');
  }

  Future<DocumentReference> familyDocument(String familyId) async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.doc('/users/$userId/families/$familyId');
  }

  Stream<QuerySnapshot<Family>> getFamilies() async* {
    final familiesCollection = await _familiesCollection;
    yield* familiesCollection
        .withConverter<Family>(
          fromFirestore: (snapshots, _) =>
              Family.fromJson(snapshots.data()!) ?? Family((b) => b..familyMembers = ListBuilder([])),
          toFirestore: (family, _) => family.toJson(),
        )
        .snapshots();
  }

  Stream<DocumentSnapshot<Family>> getFamily(String familyId) async* {
    final _familyDocument = await familyDocument(familyId);
    yield* _familyDocument
        .withConverter<Family>(
          fromFirestore: (snapshots, _) =>
              Family.fromJson(snapshots.data()!) ?? Family((b) => b..familyMembers = ListBuilder([])),
          toFirestore: (family, _) => family.toJson(),
        )
        .snapshots();
  }

  Future<ApiResponse> addFamily(Family family) async {
    try {
      logger(family);
      final familyCollection = await _familiesCollection;
      familyCollection.doc(family.id).set(family.toJson());
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse> addFamilyMember(FamilyMember familyMember, String familyId) async {
    try {
      logger(familyMember);
      final _familyDocument = await familyDocument(familyId);
      final family = await _familyDocument
          .withConverter<Family>(
              fromFirestore: (snapshot, _) => Family.fromJson(snapshot.data()!) ?? Family(),
              toFirestore: (family, _) => family.toJson())
          .get();
      if (family.data() != null) {
        final familyFamilyMembers = family.data()?.familyMembers.asList() ?? [];
        final familyMemberList = [...familyFamilyMembers, familyMember];

        final familyRebuild = family.data()?.rebuild(
              (b) => b..familyMembers = familyMemberList.toBuiltList().toBuilder(),
            );
        return addFamily(familyRebuild!);
      } else {
        return ApiResponse.error('Couldn\'t add family member because family doesn\'t exist.');
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
