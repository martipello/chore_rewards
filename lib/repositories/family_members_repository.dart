import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/family_member.dart';
import '../utils/constants.dart';
import '../utils/log.dart';

class FamilyMembersRepository {
  FamilyMembersRepository(this.firebaseFirestore,
      this.firebaseStorage,
      this.sharedPreferences,);

  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final SharedPreferences sharedPreferences;

  Future<CollectionReference> _familyMembersCollection(String familyId) async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.collection('/users/$userId/families/$familyId/members');
  }

  Future<DocumentReference> _familyMemberDocument(String familyId, String memberId) async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.doc('/users/$userId/families/$familyId/members/$memberId');
  }

  Future<DocumentReference> familyMemberDocument(String familyId, String memberId) async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.doc('/users/$userId/families/$familyId/members/$memberId');
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

  Future<DocumentSnapshot<FamilyMember>> getFamilyMember(String familyId, String memberId) async {
    final documentReference = await _familyMemberDocument(familyId, memberId);
    return documentReference.withConverter<FamilyMember>(
        fromFirestore: (doc, _) => FamilyMember.fromJson(doc.data()!) ?? FamilyMember(),
        toFirestore: (member, _) => member.toJson()).get();
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
