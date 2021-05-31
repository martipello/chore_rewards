import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/utils/api_response.dart';
import '../shared_widgets/rounded_button.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import 'email_input.dart';
import 'forgot_password_success_dialog.dart';
import 'login_page.dart';
import 'login_view_header.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({
    Key? key,
    required this.switchViewCallback,
  }) : super(key: key);

  final ValueChanged<SwitchView> switchViewCallback;

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool?> _showSuccessDialog() {
    return showDialog(
      context: context,
      builder: _buildSuccessDialog,
    );
  }

  Widget _buildSuccessDialog(BuildContext context) {
    return ForgotPasswordSuccessDialog();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
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
      ),
    );
  }

  Widget _buildFormContent() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildErrorMessage(hasError: false),
            EmailInput(emailEditingController: _emailEditingController),
            _buildMediumMargin(),
            _buildResetButton(isLoading: false),
            _buildMediumMargin(),
            _buildSignInButton(),
            _buildMediumMargin(),
          ],
        ),
      ),
    );
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

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: () {
        widget.switchViewCallback(SwitchView.loginView);
      },
      child: Text(
        'Sign In',
        textAlign: TextAlign.center,
        style: ChoresAppText.body4Style,
      ),
    );
  }

  Widget _buildResetButton({bool isLoading = false}) {
    return RoundedButton(
      label: 'RESET',
      isLoading: isLoading,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState?.save();
        }
      },
    );
  }

  Widget _buildErrorMessage({bool hasError = false, ApiResponse? errorResponse}) {
    if (hasError && errorResponse?.message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            errorResponse?.message ?? '',
            style: ChoresAppText.captionStyle.copyWith(color: colors(context).error),
            textAlign: TextAlign.start,
          ),
          _buildSmallMargin(),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
