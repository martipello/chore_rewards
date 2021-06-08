import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/allocated_family_member.dart';
import '../models/allocation.dart';
import '../models/chore.dart';
import '../models/family_member.dart';
import '../utils/constants.dart';
import '../utils/log.dart';
import 'family_repository.dart';

class ChoreRepository {
  ChoreRepository(
    this.familyRepository,
    this.sharedPreferences,
    this.firebaseFirestore,
  );

  final FamilyRepository familyRepository;
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firebaseFirestore;

  Future<CollectionReference> _choresCollection(String familyId) async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.collection('/users/$userId/families/$familyId/chores');
  }

  Stream<QuerySnapshot<Chore>> getChores(String familyId) async* {
    final choresCollection = await _choresCollection(familyId);
    yield* choresCollection
        .withConverter<Chore>(
          fromFirestore: (snapshots, _) => Chore.fromJson(snapshots.data()!) ?? Chore(),
          toFirestore: (chore, _) => chore.toJson(),
        )
        .snapshots();
  }

  Future<ApiResponse> addChore(Chore chore, String familyId) async {
    try {
      logger(chore);
      final choresCollection = await _choresCollection(familyId);
      choresCollection.doc(chore.id).set(chore.toJson());
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse> updateChoreAllocation(
    Chore chore,
    FamilyMember? familyMember,
    String familyId,
    Allocation allocation,
  ) async {
    try {
      final choresCollection = await _choresCollection(familyId);
      final allocatedToFamilyMember = allocation == Allocation.allocated
          ? _createdAllocationFamilyMemberForFamilyMember(familyMember)
          : AllocatedFamilyMember();
      choresCollection.doc(chore.id).update(chore
          .rebuild(
            (b) => b
              ..allocation = allocation
              ..allocatedToFamilyMember = allocatedToFamilyMember.toBuilder(),
          )
          .toJson());
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  AllocatedFamilyMember _createdAllocationFamilyMemberForFamilyMember(FamilyMember? familyMember) {
    return AllocatedFamilyMember((b) => b
      ..id = familyMember?.id
      ..name = familyMember?.name
      ..lastName = familyMember?.lastName
      ..image = familyMember?.image);
  }
}
