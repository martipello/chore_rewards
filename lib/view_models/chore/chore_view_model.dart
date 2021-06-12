import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/utils/api_response.dart';
import '../../models/allocated_family_member.dart';
import '../../models/allocation.dart';
import '../../models/chore.dart';
import '../../models/family_member.dart';
import '../../models/transaction.dart' as t;
import '../../models/transaction_type.dart';
import '../../repositories/chore_repository.dart';
import '../../repositories/family_members_repository.dart';
import '../../repositories/image_repository.dart';
import '../../repositories/transaction_repository.dart';
import '../../utils/constants.dart';
import '../../utils/log.dart';

class ChoreViewModel {
  ChoreViewModel(
    this.choreRepository,
    this.imageRepository,
    this.familyMemberRepository,
    this.transactionRepository,
  );

  final ChoreRepository choreRepository;
  final TransactionRepository transactionRepository;
  final ImageRepository imageRepository;
  final FamilyMembersRepository familyMemberRepository;

  final BehaviorSubject<ApiResponse> saveChoreResult = BehaviorSubject();

  final BehaviorSubject<ApiResponse> acceptChoreResult = BehaviorSubject();

  final BehaviorSubject<ApiResponse> cancelChoreResult = BehaviorSubject();

  final BehaviorSubject<ApiResponse> completeChoreResult = BehaviorSubject();

  final BehaviorSubject<ApiResponse> rewardChoreResult = BehaviorSubject();

  final BehaviorSubject<Chore> createChoreStream = BehaviorSubject.seeded(Chore());

  Future<String> getFirebaseStorageUrl(String imagePath) {
    return imageRepository.getImageUrlForImagePath(imagePath);
  }

  Stream<QuerySnapshot<Chore>?> getChores(String familyId) {
    return choreRepository.getChores(familyId);
  }

  Stream<DocumentSnapshot<Chore>?> getChore(String? familyId, String? choreId) {
    return choreRepository.getChore(familyId, choreId);
  }

  Future<void> createChore({
    File? imageFile,
    String? imageUrl,
    required String familyId,
  }) async {
    saveChoreResult.add(ApiResponse.loading(null));
    final now = DateTime.now();
    final familyMember = await familyMemberRepository.getFamilyMember(familyId);
    final chore = createChoreStream.value.rebuild((b) => b
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
    final chore = createChoreStream.value.rebuild((b) => b..title = title);
    createChoreStream.add(chore);
  }

  void setChoreDescription(String description) {
    final chore = createChoreStream.value.rebuild((b) => b..description = description);
    createChoreStream.add(chore);
  }

  void setChoreExpiry(DateTime expiry) {
    final chore = createChoreStream.value.rebuild((b) => b..expiryDate = expiry);
    createChoreStream.add(chore);
  }

  void addChoreReward() {
    final chore = createChoreStream.value;
    final reward = chore.reward ?? 0;
    createChoreStream.add(chore.rebuild((b) => b..reward = reward + 1));
  }

  void minusChoreReward() {
    final chore = createChoreStream.value;
    final reward = chore.reward ?? 0;
    if (reward > 0) {
      createChoreStream.add(chore.rebuild((b) => b..reward = reward - 1));
    }
  }

  void setAllocatedFamilyMember(FamilyMember? familyMember) {
    final chore = familyMember?.name == Constants.ALL_FAMILY_MEMBERS
        ? createChoreStream.value.rebuild((b) => b..allocatedToFamilyMember = null)
        : createChoreStream.value
            .rebuild((b) => b..allocatedToFamilyMember = _createdByFamilyMember(familyMember).toBuilder());
    createChoreStream.add(chore);
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
    createChoreStream.close();
    cancelChoreResult.close();
    completeChoreResult.close();
    rewardChoreResult.close();
  }

  void acceptChore(Chore chore, String familyId) async {
    acceptChoreResult.add(ApiResponse.loading(null));
    final familyMember = await familyMemberRepository.getFamilyMember(familyId);
    final acceptedChoreResult = await choreRepository.updateChoreAllocation(
      chore,
      familyMember.data(),
      familyId,
      Allocation.allocated,
    );
    acceptChoreResult.add(acceptedChoreResult);
  }

  void cancelChore(Chore chore, String familyId) async {
    cancelChoreResult.add(ApiResponse.loading(null));
    final familyMember = await familyMemberRepository.getFamilyMember(familyId);
    final cancelledChoreResult = await choreRepository.updateChoreAllocation(
      chore,
      familyMember.data(),
      familyId,
      Allocation.available,
    );
    cancelChoreResult.add(cancelledChoreResult);
  }

  void completeChore(Chore chore, String familyId) async {
    completeChoreResult.add(ApiResponse.loading(null));
    final familyMember = await familyMemberRepository.getFamilyMember(familyId);
    final completedChoreResult = await choreRepository.updateChoreAllocation(
      chore,
      familyMember.data(),
      familyId,
      Allocation.completed,
    );
    completeChoreResult.add(completedChoreResult);
  }

  void rewardChore(Chore chore, String familyId) async {
    rewardChoreResult.add(ApiResponse.loading(null));
    final familyMember = await familyMemberRepository.getFamilyMember(familyId);
    final rewardedChoreResult = await choreRepository.updateChoreAllocation(
      chore,
      familyMember.data(),
      familyId,
      Allocation.completed,
    );
    await transactionRepository.addTransaction(
        t.Transaction(
          (b) => b
            ..title = chore.title
            ..reward = chore.reward
            ..transactionType = TransactionType.addition
            ..date = DateTime.now()
            ..from = chore.createdBy?.toBuilder()
            ..to = chore.allocatedToFamilyMember?.toBuilder(),
        ),
        familyId);
    rewardChoreResult.add(rewardedChoreResult);
  }
}
