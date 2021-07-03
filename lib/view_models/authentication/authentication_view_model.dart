import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/utils/api_response.dart';
import '../../dependency_injection_container.dart';
import '../../models/authentication_request.dart';
import '../../repositories/family_repository.dart';
import '../../services/secure_storage.dart';
import '../../utils/constants.dart';

class AuthenticationViewModel {
  AuthenticationViewModel(
    this.firebaseAuth,
    this.secureStorage,
    this.familyRepository,
    this.sharedPreferences,
  );

  final FirebaseAuth firebaseAuth;
  final SecureStorage secureStorage;
  final SharedPreferences sharedPreferences;
  final FamilyRepository familyRepository;

  String _email = '';

  String get email => _email;

  String _password = '';

  String get password => _password;

  final BehaviorSubject<bool> isPasswordValid = BehaviorSubject();

  final BehaviorSubject<ApiResponse<UserCredential>> loginStream = BehaviorSubject();

  final BehaviorSubject<ApiResponse<UserCredential>> registerStream = BehaviorSubject();

  final BehaviorSubject<ApiResponse<UserCredential>> forgotPassword = BehaviorSubject();

  Stream<User?> get authState => firebaseAuth.authStateChanges();

  Future<void> signIn({bool autoAuthenticate = false}) async {
    loginStream.add(ApiResponse.loading(''));
    try {
      final authenticateRequest = await _createAuthenticationRequest(autoAuthenticate: autoAuthenticate);
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: authenticateRequest.email ?? '', password: authenticateRequest.password ?? '');
      if (!autoAuthenticate) {
        await _saveUserInformation(userCredential);
      }
      loginStream.add(ApiResponse.completed(userCredential));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        loginStream.add(ApiResponse.error('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        loginStream.add(ApiResponse.error('Invalid password.'));
      } else {
        loginStream.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void signOut(){
    firebaseAuth.signOut();
  }

  void registerUser() async {
    registerStream.add(ApiResponse.loading(''));
    try {
      final authenticateRequest = await _createAuthenticationRequest(autoAuthenticate: false);
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: authenticateRequest.email ?? '',
        password: authenticateRequest.password ?? '',
      );
      await _saveUserInformation(userCredential);
      registerStream.add(ApiResponse.completed(userCredential));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        registerStream.add(ApiResponse.error('Password is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        registerStream.add(ApiResponse.error('An account already exists for this username.'));
      }
    } catch (e) {
      registerStream.add(ApiResponse.error(e.toString()));
    }
  }

  Future<AuthenticationRequest> _createAuthenticationRequest({bool autoAuthenticate = false}) async {
    final sharedPreferences = await getIt.getAsync<SharedPreferences>();
    final _securePassword = await secureStorage.getValue(Constants.PASSWORD_KEY);
    return AuthenticationRequest(
      (b) => b
        ..email = autoAuthenticate ? sharedPreferences.getString(Constants.EMAIL_KEY) : _email.toLowerCase()
        ..password = autoAuthenticate ? _securePassword : _password,
    );
  }

  Future<void> saveUserId(String userId) async {
    sharedPreferences.setString(Constants.USER_ID, userId);
  }

  // ignore: use_setters_to_change_properties
  void setEmail(String email) {
    _email = email;
  }

  // ignore: use_setters_to_change_properties
  void setPassword(String password) {
    _password = password;
  }

  Future<void> logout() async {
    await _deleteUserInformation();
    firebaseAuth.signOut();
  }

  Future<void> _deleteUserInformation() async {
    sharedPreferences.setString(Constants.EMAIL_KEY, '');
    secureStorage.deleteValue(Constants.PASSWORD_KEY);
    sharedPreferences.setString(Constants.USER_ID, '');
  }

  Future<void> _saveUserInformation(UserCredential userCredential) async {
    sharedPreferences.setString(Constants.EMAIL_KEY, _email);
    secureStorage.writeValue(Constants.PASSWORD_KEY, _password);
    final id = userCredential.user?.uid;
    if (id != null) {
      saveUserId(id);
    }
  }

  void dispose() {
    registerStream.close();
    loginStream.close();
    forgotPassword.close();
    isPasswordValid.close();
  }
}
