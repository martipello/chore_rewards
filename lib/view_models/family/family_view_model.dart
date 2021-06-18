import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/utils/api_response.dart';
import '../../models/family.dart';
import '../../models/family_member.dart';
import '../../repositories/family_members_repository.dart';
import '../../repositories/family_repository.dart';
import '../../repositories/image_repository.dart';
import '../../utils/log.dart';

class FamilyViewModel {
  FamilyViewModel(
    this.familyRepository,
    this.imageRepository,
    this.familyMemberRepository,
  );

  final FamilyRepository familyRepository;
  final FamilyMembersRepository familyMemberRepository;
  final ImageRepository imageRepository;

  Stream<QuerySnapshot<Family>> getFamilies() {
    return familyRepository.getFamilies();
  }

  Future<String> getFirebaseStorageUrl(String imagePath) {
    return imageRepository.getImageUrlForImagePath(imagePath);
  }

  final BehaviorSubject<ApiResponse> saveFamilyResult = BehaviorSubject();

  Future<void> createFamily(
    String familyName,
    String familyPin, {
    File? imageFile,
    String? imageUrl,
    required FamilyMember familyMember,
  }) async {
    final family = _createFamilyModel(
      familyName,
      familyMember,
      familyPin,
    );
    saveFamilyResult.add(ApiResponse.loading(null));
    if (imageFile != null) {
      final uploadResult = await imageRepository.uploadImage(
        imageFile,
        '${familyMember.id}/${family.id}/uploads',
      );
      logger('uploadResult $uploadResult');
      if (uploadResult.status == Status.ERROR) {
        saveFamilyResult.add(ApiResponse.error('Uploading image failed.'));
      }
      logger('family before rebuild  $family');
      final _familyWithImage = family.rebuild((b) => b..image = uploadResult.data);
      logger('family after rebuild  $_familyWithImage');
      await _addFamily(_familyWithImage, familyMember);
    } else {
      await _addFamily(family, familyMember);
    }
  }

  Family _createFamilyModel(
    String name,
    FamilyMember familyMember,
    String pin,
  ) {
    final familyId = DateFormat('yMdhmms').format(DateTime.now());
    return Family((b) => b
      ..id = familyId
      ..pin = pin
      ..name = name);
  }

  Future<void> _addFamily(Family family, FamilyMember familyMember) async {
    final addFamilyResult = await familyRepository.addFamily(family);
    await familyMemberRepository.addFamilyMember(familyMember, family.id ?? '');
    saveFamilyResult.add(addFamilyResult);
  }

  Stream<DocumentSnapshot<Family>> getFamily(String familyId) {
    return familyRepository.getFamily(familyId);
  }

  void dispose() {
    saveFamilyResult.close();
  }
}
