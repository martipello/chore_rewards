
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../utils/log.dart';
import '../view_models/authentication/authentication_view_model.dart';
import '../view_models/family/create_family_member_view_model.dart';

class AddFamilyMemberView extends StatefulWidget {
  AddFamilyMemberView({required this.familyId});

  final String familyId;

  @override
  _AddFamilyMemberViewState createState() => _AddFamilyMemberViewState();
}

class _AddFamilyMemberViewState extends State<AddFamilyMemberView> {
  final _familyMemberViewModel = getIt.get<CreateFamilyMemberViewModel>();
  final _authenticationViewModel = getIt.get<AuthenticationViewModel>();
  final _nameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _familyMemberViewModel.addFamilyMemberResult.listen((value) {
      logger(value);
      if (value.status == Status.COMPLETED) {
        Navigator.of(context).pop();
      }
    });
    _addTextListeners();
  }

  void _addTextListeners() {
    _nameTextController.addListener(() {
      _familyMemberViewModel.setFamilyMemberName(
        _nameTextController.text,
      );
    });
  }

  @override
  void dispose() {
    _authenticationViewModel.dispose();
    _nameTextController.dispose();
    _familyMemberViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Family Member'),
      ),
      body: StreamBuilder<ApiResponse>(
          stream: _familyMemberViewModel.createFamilyMemberResult,
          builder: (context, snapshot) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          _buildValidUserMessage(),
                          SizedBox(
                            height: 16,
                          ),
                          _buildUserName(),
                          SizedBox(
                            height: 72,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (snapshot.hasData && snapshot.data!.status == Status.LOADING)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black12,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          }),
      floatingActionButton: _buildSaveFamilyButton(context),
    );
  }

  Widget _buildSaveFamilyButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
        }
      },
      tooltip: 'Add family member',
      child: Icon(Icons.save),
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      maxLines: 1,
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Name',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
      controller: _nameTextController,
    );
  }

  Widget _buildValidUserMessage() {
    return StreamBuilder<ApiResponse<UserCredential>>(
      stream: _authenticationViewModel.loginStream,
      builder: (context, snapshot) {
        //TODO check the error is the user doesnt exist error
        if (snapshot.hasError) {
          return _buildErrorMessage(
            'User must exist to add them',
          );
        } else {
          return SizedBox();
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
          errorMessage ?? 'Error message',
          style: ChoresAppText.captionStyle.copyWith(color: colors(context).error),
          textAlign: TextAlign.start,
        ),
        // _buildSmallMargin(),
      ],
    );
  }

}
