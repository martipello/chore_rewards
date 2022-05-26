import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/family_member.dart';
import '../utils/log.dart';

class FamilyMembersRepository {
  FamilyMembersRepository(
    this.firebaseFirestore,
    this.firebaseStorage,
    this.sharedPreferences,
  );

  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final SharedPreferences sharedPreferences;

  Future<CollectionReference> _familyMembersCollection(String familyId) async {
    return firebaseFirestore.collection('/families/$familyId/members');
  }

  Future<DocumentReference> _familyMemberDocument(String familyId, String memberId) async {
    return firebaseFirestore.doc('/families/$familyId/members/$memberId');
  }

  Future<DocumentReference> familyMemberDocument(String familyId, String memberId) async {
    return firebaseFirestore.doc('/families/$familyId/members/$memberId');
  }

  Stream<QuerySnapshot<FamilyMember>> getFamilyMemberList(String familyId) async* {
    final membersCollection = await _familyMembersCollection(familyId);
    yield* membersCollection
        .withConverter<FamilyMember>(
          fromFirestore: (snapshots, _) => FamilyMember.fromJson(snapshots.data()!) ?? FamilyMember(),
          toFirestore: (member, _) => member.toJson(),
        )
        .snapshots();
  }

  Future<QuerySnapshot<FamilyMember>> getFamilyMemberListAsync(String familyId) async {
    final membersCollection = await _familyMembersCollection(familyId);
    return membersCollection
        .withConverter<FamilyMember>(
          fromFirestore: (snapshots, _) => FamilyMember.fromJson(snapshots.data()!) ?? FamilyMember(),
          toFirestore: (member, _) => member.toJson(),
        )
        .get();
  }

  Future<DocumentSnapshot<FamilyMember>> getFamilyMemberAsync(String familyId, String memberId) async {
    final documentReference = await _familyMemberDocument(familyId, memberId);
    return documentReference
        .withConverter<FamilyMember>(
            fromFirestore: (doc, _) => FamilyMember.fromJson(doc.data()!) ?? FamilyMember(),
            toFirestore: (member, _) => member.toJson())
        .get();
  }

  Stream<DocumentSnapshot<FamilyMember>> getFamilyMember(String familyId, String memberId) async* {
    final documentReference = await _familyMemberDocument(familyId, memberId);
    yield* documentReference
        .withConverter<FamilyMember>(
            fromFirestore: (doc, _) => FamilyMember.fromJson(doc.data()!) ?? FamilyMember(),
            toFirestore: (member, _) => member.toJson())
        .snapshots();
  }

  Future<ApiResponse> addFamilyMember(FamilyMember familyMember, String familyId) async {
    try {
      logger(familyMember);
      final membersCollection = await _familyMembersCollection(familyId);
      membersCollection.doc(familyMember.id).set(familyMember.toJson());
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse> updateFamilyMember(FamilyMember familyMember, String familyId) async {
    try {
      logger(familyMember);
      final membersCollection = await _familyMembersCollection(familyId);
      membersCollection.doc(familyMember.id).update(familyMember.toJson());
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
