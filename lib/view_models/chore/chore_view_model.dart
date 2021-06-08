import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/utils/api_response.dart';
import '../../models/allocated_family_member.dart';
import '../../models/allocation.dart';
import '../../models/chore.dart';
import '../../models/family_member.dart';
import '../../repositories/chore_repository.dart';
import '../../repositories/family_members_repository.dart';
import '../../repositories/image_repository.dart';
import '../../utils/constants.dart';
import '../../utils/log.dart';

class ChoreViewModel {
  ChoreViewModel(
    this.choreRepository,
    this.imageRepository,
    this.familyRepository,
    this.sharedPreferences,
  );

  final ChoreRepository choreRepository;
  final ImageRepository imageRepository;
  final FamilyMembersRepository familyRepository;
  final SharedPreferences sharedPreferences;

  final BehaviorSubject<ApiResponse> saveChoreResult = BehaviorSubject();

  final BehaviorSubject<ApiResponse> acceptChoreResult = BehaviorSubject();

  final BehaviorSubject<Chore> choreStream = BehaviorSubject.seeded(Chore());

  Future<String> getFirebaseStorageUrl(String imagePath) {
    return imageRepository.getImageUrlForImagePath(imagePath);
  }

  Stream<QuerySnapshot<Chore>?> getChores(String familyId) {
    return choreRepository.getChores(familyId);
  }

  Future<void> createChore({
    File? imageFile,
    String? imageUrl,
    required String familyId,
  }) async {
    saveChoreResult.add(ApiResponse.loading(null));
    final now = DateTime.now();
    final familyMember = await familyRepository.getFamilyMember(familyId);
    final chore = choreStream.value.rebuild((b) => b
      ..id = '${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}'
      ..addedDate = DateTime.now()
      ..allocation = Allocation.available
      ..createdBy = _createdByFamilyMember(familyMember.data()).toBuilder());
    if (imageFile != null) {
      final uploadResult = await imageRepository.uploadImage(imageFile, '$familyId/chores/${chore.id}/uploads');
      logger('uploadResult $uploadResult');
      if (uploadResult.status == Status.ERROR) {
        saveChoreResult.add(
          ApiResponse.error('Uploading image failed.'),
        );
      }
      logger('family before rebuild  $familyId');
      final _choreWithImage = chore.rebuild((b) => b..image = uploadResult.data);
      await _addChore(_choreWithImage, familyId);
    } else {
      await _addChore(chore, familyId);
    }
  }

  Future<void> _addChore(Chore chore, String familyId) async {
    final addChoreResult = await choreRepository.addChore(chore, familyId);
    saveChoreResult.add(addChoreResult);
  }

  void setChoreTitle(String title) {
    final chore = choreStream.value.rebuild((b) => b..title = title);
    choreStream.add(chore);
  }

  void setChoreDescription(String description) {
    final chore = choreStream.value.rebuild((b) => b..description = description);
    choreStream.add(chore);
  }

  void setChoreExpiry(DateTime expiry) {
    final chore = choreStream.value.rebuild((b) => b..expiryDate = expiry);
    choreStream.add(chore);
  }

  void addChoreReward() {
    final chore = choreStream.value;
    final reward = chore.reward ?? 0;
    choreStream.add(chore.rebuild((b) => b..reward = reward + 1));
  }

  void minusChoreReward() {
    final chore = choreStream.value;
    final reward = chore.reward ?? 0;
    if (reward > 0) {
      choreStream.add(chore.rebuild((b) => b..reward = reward - 1));
    }
  }

  void setAllocatedFamilyMember(FamilyMember? familyMember) {
    final chore = familyMember?.name == Constants.ALL_FAMILY_MEMBERS
        ? choreStream.value.rebuild((b) => b..allocatedToFamilyMember = null)
        : choreStream.value
            .rebuild((b) => b..allocatedToFamilyMember = _createdByFamilyMember(familyMember).toBuilder());
    choreStream.add(chore);
  }

  AllocatedFamilyMember _createdByFamilyMember(FamilyMember? familyMember) {
    return AllocatedFamilyMember((b) => b
      ..id = familyMember?.id
      ..name = familyMember?.name
      ..lastName = familyMember?.lastName
      ..image = familyMember?.image);
  }

  void dispose() {
    saveChoreResult.close();
    acceptChoreResult.close();
    choreStream.close();
  }

  void acceptChore(Chore chore, String familyId) async {
    acceptChoreResult.add(ApiResponse.loading(null));
    final familyMember = await familyRepository.getFamilyMember(familyId);
    final acceptedChoreResult = await choreRepository.acceptChore(chore, familyMember.data(), familyId);
    acceptChoreResult.add(acceptedChoreResult);
  }
}
