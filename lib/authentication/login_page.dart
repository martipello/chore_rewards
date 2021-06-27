import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _authenticationViewModel.authState.listen((user) async {
      if (user != null) {
        await _handleBioMetricsPermission();
      }
    });
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
    return showDialog<bool>(context: context, barrierDismissible: false, builder: _buildUseBiometricsDialog);
  }

  Widget _buildUseBiometricsDialog(BuildContext context) {
    return BiometricRequestDialog();
  }

  @override
  void dispose() {
    _authenticationViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _authenticationViewModel.authState,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
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
            } else {
              return StreamBuilder<DocumentSnapshot<User>>(
                stream: _userViewModel.userDocumentStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.data() != null) {
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
            }
          }),
    );
  }

  ValueChanged<SwitchView> get switchViewCallback => (switchView) {
        setState(() {
          currentView = switchView;
        });
      };
}
