import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/family.dart';
import '../utils/constants.dart';
import '../utils/log.dart';
import 'family_members_repository.dart';

class FamilyRepository {
  FamilyRepository(
    this.firebaseFirestore,
    this.firebaseStorage,
    this.sharedPreferences,
    this.familyMembersRepository,
  );

  final FamilyMembersRepository familyMembersRepository;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final SharedPreferences sharedPreferences;

  Future<CollectionReference> get _familiesCollection async {
    return firebaseFirestore.collection('/families');
  }

  Future<DocumentReference> familyDocument(String familyId) async {
    return firebaseFirestore.doc('/families/$familyId');
  }

  Stream<List<QueryDocumentSnapshot<Family>?>> getFamilies() async* {
    final familiesCollection = await _familiesCollection;
    final userId = await sharedPreferences.getString(Constants.USER_ID) ?? '';
    final familyList = await familiesCollection
        .withConverter<Family>(
          fromFirestore: (snapshots, _) => Family.fromJson(snapshots.data()!) ?? Family(),
          toFirestore: (family, _) => family.toJson(),
        )
        .get();
    final familyIncludingUser = await _getFamiliesWhereUserExists(familyList, userId);
    final families = await Future.wait(familyIncludingUser);
    yield* Stream.value(families);
  }

  Future<Iterable<Future<QueryDocumentSnapshot<Family>?>>> _getFamiliesWhereUserExists(QuerySnapshot<Family> familyList, String userId) async {
    return familyList.docs.map(
      (family) async {
        final familyMemberList = await familyMembersRepository.getFamilyMemberListAsync(family.data().id ?? '');
        if (familyMemberList.docs.any((familyMember) {
          return familyMember.data().id == userId;
        })) {
          return family;
        }
      },
    );
  }

  Stream<DocumentSnapshot<Family>> getFamily(String familyId) async* {
    final _familyDocument = await familyDocument(familyId);
    yield* _familyDocument
        .withConverter<Family>(
          fromFirestore: (snapshots, _) => Family.fromJson(snapshots.data()!) ?? Family(),
          toFirestore: (family, _) => family.toJson(),
        )
        .snapshots();
  }

  Future<DocumentSnapshot<Family>> getFamilyAsync(String familyId) async {
    final _familyDocument = await familyDocument(familyId);
    return _familyDocument
        .withConverter<Family>(
          fromFirestore: (snapshots, _) => Family.fromJson(snapshots.data()!) ?? Family(),
          toFirestore: (family, _) => family.toJson(),
        )
        .get();
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

  Future<ApiResponse> addFamilyToFamilyMember(Family family, String userId) async {
    try {
      final _familyCollection = firebaseFirestore.collection('/users/$userId/families');
      _familyCollection.doc(family.id).set(family.toJson());
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
