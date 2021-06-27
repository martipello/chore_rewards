import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../shared_widgets/rounded_button.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../utils/constants.dart';
import '../view_models/authentication/authentication_view_model.dart';
import 'email_input.dart';
import 'login_page.dart';
import 'login_view_header.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
    required this.switchViewCallback,
    required this.authenticationViewModel,
  }) : super(key: key);

  static const routeName = '/login';
  final AuthenticationViewModel authenticationViewModel;
  final ValueChanged<SwitchView> switchViewCallback;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkForBiometrics();
    _addEmailEditTextListener();
    _addPasswordEditTextListener();
    _emailEditingController.text = widget.authenticationViewModel.email;
    _passwordEditingController.text = widget.authenticationViewModel.password;
  }

  Future<void> _checkForBiometrics() async {
    final sharedPreferences = await getIt.getAsync<SharedPreferences>();
    if (sharedPreferences.containsKey(Constants.USE_BIOMETRICS)) {
      if (sharedPreferences.getBool(Constants.USE_BIOMETRICS) == true) {
        _authenticateUsingBiometrics();
      }
    }
  }

  void _addEmailEditTextListener() {
    _emailEditingController.addListener(() {
      widget.authenticationViewModel.setEmail(_emailEditingController.text);
    });
  }

  void _addPasswordEditTextListener() {
    _passwordEditingController.addListener(() {
      widget.authenticationViewModel.setPassword(_passwordEditingController.text);
      if (widget.authenticationViewModel.password.isValidPassword()) {
        widget.authenticationViewModel.isPasswordValid.add(true);
      }
    });
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLoginView(),
    );
  }

  Widget _buildLoginView() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoginViewHeader(),
            SizedBox(height: 36),
            _buildFormContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: StreamBuilder<ApiResponse<UserCredential>>(
            stream: widget.authenticationViewModel.loginStream,
            builder: (context, snapshot) {
              final hasResponseError = snapshot.data?.status == Status.ERROR;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (hasResponseError) _buildErrorMessage(snapshot.data?.message),
                  _buildValidPasswordMessage(),
                  EmailInput(emailEditingController: _emailEditingController),
                  _buildSmallMargin(),
                  _buildPasswordInput(),
                  _buildMediumMargin(),
                  _buildSubmitButton(isLoading: snapshot.data?.status == Status.LOADING),
                  _buildMediumMargin(),
                  _buildSignUpButton(),
                  _buildMediumMargin(),
                  _buildForgotPasswordButton(),
                  _buildMediumMargin(),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildValidPasswordMessage() {
    return StreamBuilder<bool>(
        stream: widget.authenticationViewModel.isPasswordValid,
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return _buildErrorMessage(
              'Password must contain a minimum of 8 characters, and include at least 3 of the following: \n1) Must contain a lowercase letter (a-z).\n2) Must contain an uppercase letter (A-Z).\n3) Must contain a number (0-9).\n4) Must contain a special character (\$@!%*#?&).',
            );
          } else {
            return SizedBox();
          }
        });
  }

  Widget _buildSmallMargin() {
    return SizedBox(
      height: 16,
    );
  }

  Widget _buildMediumMargin() {
    return SizedBox(
      height: 32,
    );
  }

  Widget _buildPasswordInput() {
    return StreamBuilder<bool>(
        stream: widget.authenticationViewModel.isPasswordValid,
        builder: (context, snapshot) {
          return TextFormField(
            obscureText: true,
            maxLines: 1,
            style: ChoresAppText.body4Style,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              labelText: 'Password',
              suffixIcon: Icon(
                Icons.lock_outline,
                color: colors(context).textOnForeground,
              ),
            ),
            autovalidateMode: snapshot.data == true ? AutovalidateMode.onUserInteraction : null,
            validator: (value) {
              if (!value.isValidPassword()) {
                widget.authenticationViewModel.isPasswordValid.add(false);
                return 'Please enter a valid password.';
              }
              return null;
            },
            controller: _passwordEditingController,
          );
        });
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.switchViewCallback(SwitchView.signUp);
        });
      },
      child: Text(
        'Sign up here.',
        textAlign: TextAlign.center,
        style: ChoresAppText.body4Style,
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.switchViewCallback(SwitchView.forgotPasswordView);
        });
      },
      child: Text(
        'Forgot password',
        textAlign: TextAlign.center,
        style: ChoresAppText.body4Style,
      ),
    );
  }

  Widget _buildSubmitButton({bool isLoading = false}) {
    return RoundedButton(
      label: 'LOGIN',
      isLoading: isLoading,
      onPressed: () async {
        widget.authenticationViewModel.isPasswordValid.add(_passwordEditingController.text.isValidPassword());
        if (_formKey.currentState!.validate()) {
          widget.authenticationViewModel.signIn();
        }
      },
    );
  }

  Widget _buildErrorMessage(String? errorMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          errorMessage ?? 'Oops that\'s an error.',
          style: ChoresAppText.captionStyle.copyWith(color: colors(context).error),
          textAlign: TextAlign.start,
        ),
        _buildSmallMargin(),
      ],
    );
  }

  Future<void> _authenticateUsingBiometrics() async {
    try {
      final auth = LocalAuthentication();
      final onAuthenticated = await auth.authenticate(localizedReason: 'Please authenticate to sign in.');
      if (onAuthenticated) {
        widget.authenticationViewModel.signIn(autoAuthenticate: true);
      } else {
        widget.authenticationViewModel.signOut();
      }
    } on PlatformException catch (e) {
      print('There was an error $e');
    }
  }
}
