import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../families/family_list_view.dart';
import '../models/user.dart';
import '../shared_widgets/biometric_request_dialog.dart';
import '../user/create_user_view.dart';
import '../utils/constants.dart';
import '../view_models/authentication/authentication_view_model.dart';
import '../view_models/user_view_model.dart';
import 'forgot_password_view.dart';
import 'login_view.dart';
import 'sign_up_view.dart';

enum SwitchView { loginView, forgotPasswordView, signUp }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SwitchView currentView = SwitchView.loginView;
  final _authenticationViewModel = getIt.get<AuthenticationViewModel>();
  final _userViewModel = getIt.get<UserViewModel>();

  @override
  void initState() {
    super.initState();
    _checkForBiometrics();
    _authenticationViewModel.authState.listen((user) async {
      if (user != null) {
        await _handleBioMetricsPermission();
      }
    });
  }

  Future<void> _checkForBiometrics() async {
    final sharedPreferences = await getIt.getAsync<SharedPreferences>();
    if (sharedPreferences.containsKey(Constants.USE_BIOMETRICS)) {
      if (sharedPreferences.getBool(Constants.USE_BIOMETRICS) == true) {
        _authenticateUsingBiometrics();
      }
    }
  }

  Future<void> _handleBioMetricsPermission() async {
    final sharedPreferences = await getIt.getAsync<SharedPreferences>();
    if (!sharedPreferences.containsKey(Constants.USE_BIOMETRICS)) {
      final useBiometrics = await _showUseBiometricDialog();
      if (useBiometrics == true) {
        sharedPreferences.setBool(Constants.USE_BIOMETRICS, true);
      } else {
        sharedPreferences.setBool(Constants.USE_BIOMETRICS, false);
      }
      return;
    }
  }

  Future<bool?> _showUseBiometricDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BiometricRequestDialog(),
    );
  }

  @override
  void dispose() {
    _authenticationViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<ApiResponse<auth.UserCredential>>(
      stream: _authenticationViewModel.registerStream,
      builder: (context, registerSnapshot) {
        return StreamBuilder<ApiResponse<auth.UserCredential>>(
          stream: _authenticationViewModel.loginStream,
          builder: (context, signInSnapshot) {
            if (signInSnapshot.data?.status == Status.COMPLETED || registerSnapshot.data?.status == Status.COMPLETED) {
              return StreamBuilder<DocumentSnapshot<User?>>(
                stream: _userViewModel.userDocumentStream,
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData) {
                    if (userSnapshot.data?.data() != null) {
                      return FamilyListView();
                    } else {
                      return CreateUserView();
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return _showAuthScreen();
            }
          },
        );
      },
    ));
  }

  Widget _showAuthScreen() {
    switch (currentView) {
      case SwitchView.loginView:
        return LoginView(
          switchViewCallback: switchViewCallback,
          authenticationViewModel: _authenticationViewModel,
        );
      case SwitchView.forgotPasswordView:
        return ForgotPasswordView(switchViewCallback: switchViewCallback);
      case SwitchView.signUp:
        return SignUpView(
          switchViewCallback: switchViewCallback,
          authenticationViewModel: _authenticationViewModel,
        );
    }
  }

  ValueChanged<SwitchView> get switchViewCallback => (switchView) {
        setState(() {
          currentView = switchView;
        });
      };

  Future<void> _authenticateUsingBiometrics() async {
    try {
      final auth = LocalAuthentication();
      final onAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to sign in.',
      );
      if (onAuthenticated) {
        _authenticationViewModel.signIn(autoAuthenticate: true);
      } else {
        _authenticationViewModel.signOut();
      }
    } on PlatformException catch (e) {
      print('There was an error $e');
    }
  }
}
