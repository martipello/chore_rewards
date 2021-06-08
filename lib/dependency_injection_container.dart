import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'repositories/chore_repository.dart';
import 'repositories/family_members_repository.dart';
import 'repositories/family_repository.dart';
import 'repositories/image_repository.dart';
import 'repositories/transaction_repository.dart';
import 'repositories/user_repository.dart';
import 'services/secure_storage.dart';
import 'view_models/authentication/authentication_view_model.dart';
import 'view_models/chore/chore_view_model.dart';
import 'view_models/family/family_member_view_model.dart';
import 'view_models/family/family_view_model.dart';
import 'view_models/piggy_bank_view_model.dart';
import 'view_models/user_view_model.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => FlutterSecureStorage());
  getIt.registerLazySingletonAsync(SharedPreferences.getInstance);
  getIt.registerLazySingleton(() => SecureStorage(getIt()));
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseStorage.instance);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);

  getIt.registerLazySingleton(() => ImageRepository(getIt()));
  getIt.registerLazySingleton(() => ChoreRepository(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => UserRepository(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => FamilyRepository(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => FamilyMembersRepository(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => TransactionRepository(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => UserViewModel(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => AuthenticationViewModel(getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory(() => FamilyViewModel(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => FamilyMemberViewModel(getIt(), getIt()));
  getIt.registerFactory(() => PiggyBankViewModel(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => ChoreViewModel(getIt(), getIt(), getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => ImagePicker());
}
