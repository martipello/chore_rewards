import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/user.dart';
import '../repositories/image_repository.dart';
import '../repositories/user_repository.dart';
import '../utils/constants.dart';

class UserViewModel {
  UserViewModel(
    this.userRepository,
    this.imageRepository,
    this.sharedPreferences,
  );

  final UserRepository userRepository;
  final SharedPreferences sharedPreferences;
  final ImageRepository imageRepository;

  Stream<DocumentSnapshot<User>> get userDocumentStream => userRepository.getUser();

  Future<DocumentSnapshot<User>> get userDocument => userRepository.getUserDocument();

  BehaviorSubject<User> userStream = BehaviorSubject.seeded(User());

  BehaviorSubject<ApiResponse> createUserStream = BehaviorSubject();

  Future<void> createUser({File? imageFile}) async {
    createUserStream.add(ApiResponse.loading(null));
    final user = userStream.value;
    final userId = sharedPreferences.getString(Constants.USER_ID);
    if (imageFile != null) {
      final uploadResult = await imageRepository.uploadImage(imageFile, '$userId/uploads');
      if (uploadResult.status == Status.ERROR) {
        createUserStream.add(ApiResponse.error('Uploading image failed.'));
      }
      final _userWithImage = user.rebuild((b) => b..image = uploadResult.data);
      await _setUser(_userWithImage);
    } else {
      await _setUser(user);
    }
  }

  Future _setUser(User user) async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    final username = sharedPreferences.getString(Constants.EMAIL_KEY);
    final setUserResult = await userRepository.setUser(user.rebuild((b) => b
      ..id = userId
      ..userName = username));
    createUserStream.add(setUserResult);
  }

  void setUserName(String userName) {
    final user = userStream.value.rebuild((b) => b..name = userName);
    userStream.add(user);
  }

  void setUserLastName(String lastName) {
    final user = userStream.value.rebuild((b) => b..lastName = lastName);
    userStream.add(user);
  }

  void setUserDateOfBirth(DateTime dateOfBirth) {
    final user = userStream.value.rebuild((b) => b..dateOfBirth = dateOfBirth);
    userStream.add(user);
  }

  void dispose() {
    userStream.close();
    createUserStream.close();
  }
}
