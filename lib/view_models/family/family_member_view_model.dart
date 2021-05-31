import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/utils/api_response.dart';
import '../../models/family.dart';
import '../../models/family_member.dart';
import '../../models/family_member_type.dart';
import '../../models/piggy_bank.dart';
import '../../repositories/family_repository.dart';
import '../../repositories/image_repository.dart';
import '../../utils/log.dart';

class FamilyMemberViewModel {
  FamilyMemberViewModel(this.familyRepository, this.imageRepository);

  final FamilyRepository familyRepository;
  final ImageRepository imageRepository;

  final BehaviorSubject<ApiResponse> saveFamilyMemberResult = BehaviorSubject();

  final BehaviorSubject<FamilyMember> familyMemberStream = BehaviorSubject.seeded(FamilyMember((b) => b
    ..familyMemberType = FamilyMemberType.child
    ..piggyBank = PiggyBank((b) => b..balance = 0).toBuilder()));

  Stream<DocumentSnapshot<Family>> getFamily(String familyId) {
    return familyRepository.getFamily(familyId);
  }

  Future<String> getFirebaseStorageUrl(String imagePath) {
    return imageRepository.getImageUrlForImagePath(imagePath);
  }

  Future<void> createFamilyMember({
    File? imageFile,
    String? imageUrl,
    required String familyId,
  }) async {
    saveFamilyMemberResult.add(ApiResponse.loading(null));
    final now = DateTime.now();
    final familyMember = familyMemberStream.value
        .rebuild((b) => b..id = '${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}');
    if (imageFile != null) {
      final uploadResult = await imageRepository.uploadImage(imageFile, '${familyMember.id}/$familyId/uploads');
      if (uploadResult.status == Status.ERROR) {
        saveFamilyMemberResult.add(ApiResponse.error('Uploading image failed.'));
      }
      logger('family before rebuild  $familyId');
      final _familyMemberWithImage = familyMember.rebuild((b) => b..image = uploadResult.data);
      await _addFamilyMember(_familyMemberWithImage, familyId);
    } else {
      await _addFamilyMember(familyMember, familyId);
    }
  }

  Future<void> _addFamilyMember(FamilyMember familyMember, String familyId) async {
    final addFamilyResult = await familyRepository.addFamilyMember(familyMember, familyId);
    saveFamilyMemberResult.add(addFamilyResult);
  }

  void setFamilyMemberName(String userName) {
    final familyMember = familyMemberStream.value.rebuild((b) => b..name = userName);
    familyMemberStream.add(familyMember);
  }

  void setFamilyMemberLastName(String lastName) {
    final familyMember = familyMemberStream.value.rebuild((b) => b..lastName = lastName);
    familyMemberStream.add(familyMember);
  }

  void setFamilyMemberDateOfBirth(DateTime dateOfBirth) {
    final familyMember = familyMemberStream.value.rebuild((b) => b..dateOfBirth = dateOfBirth);
    familyMemberStream.add(familyMember);
  }

  void setFamilyMemberType(FamilyMemberType familyMemberType) {
    final familyMember = familyMemberStream.value.rebuild((b) => b..familyMemberType = familyMemberType);
    familyMemberStream.add(familyMember);
  }

  void dispose() {
    saveFamilyMemberResult.close();
    familyMemberStream.close();
  }
}
