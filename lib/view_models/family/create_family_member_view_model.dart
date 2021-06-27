import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/utils/api_response.dart';
import '../../models/family.dart';
import '../../models/family_member.dart';
import '../../models/family_member_type.dart';
import '../../models/piggy_bank.dart';
import '../../models/user.dart' as user;
import '../../repositories/family_members_repository.dart';
import '../../repositories/family_repository.dart';
import '../../repositories/image_repository.dart';
import '../../repositories/user_repository.dart';

class CreateFamilyMemberViewModel {
  CreateFamilyMemberViewModel(
    this.familyMembersRepository,
    this.imageRepository,
    this.firebaseAuth,
    this.familyRepository,
    this.userRepository,
  );

  final FamilyMembersRepository familyMembersRepository;
  final FamilyRepository familyRepository;
  final ImageRepository imageRepository;
  final FirebaseAuth firebaseAuth;
  final UserRepository userRepository;

  final BehaviorSubject<ApiResponse> createFamilyMemberResult = BehaviorSubject();

  // final BehaviorSubject<ApiResponse> addFamilyMemberResult = BehaviorSubject();

  final BehaviorSubject<FamilyMember> familyMemberStream = BehaviorSubject.seeded(FamilyMember((b) => b
    ..familyMemberType = FamilyMemberType.child
    ..piggyBank = PiggyBank((b) => b..balance = 0).toBuilder()));

  Future<String> getFirebaseStorageUrl(String imagePath) {
    return imageRepository.getImageUrlForImagePath(imagePath);
  }

  Future<void> createFamilyMember({
    File? imageFile,
    String? imageUrl,
    required String familyId,
    required String username,
    required String password,
  }) async {
    // DOESNT HANDLE SUCCESS OR FAILURE FROM ALL METHODS THAT COULD SUCCEED OR FAIL
    // REGISTERS THE USER AN ACCOUNT IN FIREBASE
    createFamilyMemberResult.add(ApiResponse.loading(null));
    final userCredential = await _registerUser(username, password);
    if (userCredential != null) {
      final familyMember = familyMemberStream.value.rebuild((b) => b..id = userCredential.user?.uid);
      final _user = user.User((b) => b
        ..id = familyMember.id
        ..name = familyMember.name
        ..dateOfBirth = familyMember.dateOfBirth
        ..lastName = familyMember.lastName
        ..userName = username);
      if (imageFile != null) {
        final uploadResult = await imageRepository.uploadImage(imageFile, '${familyMember.id}/$familyId/uploads');
        if (uploadResult.status == Status.ERROR) {
          createFamilyMemberResult.add(ApiResponse.error('Uploading image failed.'));
        }
        final _familyMemberWithImage = familyMember.rebuild((b) => b..image = uploadResult.data);
        final _userWithImage = _user.rebuild((b) => b.image = uploadResult.data);
        await userRepository.setUserForId(_userWithImage);
        await _addFamilyToFamilyMember(familyId, _familyMemberWithImage.id ?? '');
        await _addFamilyMemberToFamily(_familyMemberWithImage, familyId);
      } else {
        await userRepository.setUserForId(_user);
        await _addFamilyToFamilyMember(familyId, familyMember.id ?? '');
        await _addFamilyMemberToFamily(familyMember, familyId);
      }
    }
  }

  Future<UserCredential?> _registerUser(
    String username,
    String password,
  ) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        createFamilyMemberResult.add(ApiResponse.error('Password is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        createFamilyMemberResult.add(ApiResponse.error('An account already exists for this username.'));
      }
    } catch (e) {
      createFamilyMemberResult.add(ApiResponse.error(e.toString()));
    }
    return Future.value(null);
  }

  Future<void> _addFamilyMemberToFamily(FamilyMember familyMember, String familyId) async {
    final _createFamilyResult = await familyMembersRepository.addFamilyMember(familyMember, familyId);
    createFamilyMemberResult.add(_createFamilyResult);
  }

  Future<void> _addFamilyToFamilyMember(String familyId, String familyMemberId) async {
    final _family = await getFamilyAsync(familyId);
    if (_family.data() != null) {
      familyRepository.addFamilyToFamilyMember(_family.data()!, familyMemberId);
    }
  }

  Stream<DocumentSnapshot<FamilyMember>> getFamilyMember(String familyId, String familyMemberId) {
    return familyMembersRepository.getFamilyMember(familyId, familyMemberId);
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

  Stream<QuerySnapshot<FamilyMember>> getFamilyMemberList(String familyId) {
    return familyMembersRepository.getFamilyMemberList(familyId);
  }

  Future<DocumentSnapshot<Family>> getFamilyAsync(String familyId) {
    return familyRepository.getFamilyAsync(familyId);
  }

  void dispose() {
    // addFamilyMemberResult.close();
    createFamilyMemberResult.close();
    familyMemberStream.close();
  }
}
