import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/family_member.dart';
import '../models/family_member_type.dart';
import '../shared_widgets/image_picker_bottom_sheet.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../utils/log.dart';
import '../view_models/authentication/authentication_view_model.dart';
import '../view_models/family/create_family_member_view_model.dart';

class CreateFamilyMemberView extends StatefulWidget {
  CreateFamilyMemberView({required this.familyId});

  final String familyId;

  @override
  _CreateFamilyMemberViewState createState() => _CreateFamilyMemberViewState();
}

class _CreateFamilyMemberViewState extends State<CreateFamilyMemberView> {
  final _familyMemberViewModel = getIt.get<CreateFamilyMemberViewModel>();
  final _authenticationViewModel = getIt.get<AuthenticationViewModel>();
  final _nameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = getIt.get<ImagePicker>();
  final _profileImageHeight = 150.0;
  File? _imageFile;
  dynamic _pickImageError;

  @override
  void initState() {
    super.initState();
    _familyMemberViewModel.createFamilyMemberResult.listen((value) {
      logger(value);
      if (value.status == Status.COMPLETED) {
        Navigator.of(context).pop();
      }
    });
    _addTextListeners();
  }

  void _addTextListeners() {
    _userNameTextController.addListener(() {
      _authenticationViewModel.setEmail(_userNameTextController.text);
    });
    _passwordTextController.addListener(() {
      _authenticationViewModel.setPassword(_passwordTextController.text);
      if (_authenticationViewModel.password.isValidPassword()) {
        _authenticationViewModel.isPasswordValid.add(true);
      }
    });
    _nameTextController.addListener(() {
      _familyMemberViewModel.setFamilyMemberName(
        _nameTextController.text,
      );
    });
    _lastNameTextController.addListener(() {
      _familyMemberViewModel.setFamilyMemberLastName(
        _lastNameTextController.text,
      );
    });
  }

  @override
  void dispose() {
    _authenticationViewModel.dispose();
    _userNameTextController.dispose();
    _passwordTextController.dispose();
    _nameTextController.dispose();
    _lastNameTextController.dispose();
    _familyMemberViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Family Member'),
      ),
      body: StreamBuilder<ApiResponse>(
          stream: _familyMemberViewModel.createFamilyMemberResult,
          builder: (context, snapshot) {
            return Stack(
              children: [
                StreamBuilder<FamilyMember>(
                    stream: _familyMemberViewModel.familyMemberStream,
                    builder: (context, snapshot) {
                      final familyMember = snapshot.data;
                      return Positioned.fill(
                        child: SingleChildScrollView(
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 140,
                                width: double.infinity,
                                child: _buildWave(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      _buildProfileImage(context),
                                      SizedBox(
                                        height: 36,
                                      ),
                                      _buildValidPasswordMessage(),
                                      _buildUserName(context),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      _buildPasswordInput(),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      _buildName(context),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      _buildLastName(context),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      _buildDateOfBirth(),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      _buildFamilyMemberTypePicker(familyMember),
                                      SizedBox(
                                        height: 72,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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

  Widget _buildProfileImage(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: _buildProfileImageBorder(context),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(180),
            onTap: () async {
              final imageSource = await ImagePickerBottomSheet.showImagePicker(context);
              if (imageSource != null) {
                _getImageForImageSource(imageSource);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(180),
              child: _imageFile?.path != null
                  ? Stack(
                      children: [
                        Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                          height: _profileImageHeight,
                          width: _profileImageHeight,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: _buildProfileImageBorder(context),
                          ),
                          height: _profileImageHeight,
                          width: _profileImageHeight,
                        )
                      ],
                    )
                  : _buildAddImageIcon(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddImageIcon() {
    return SizedBox(
      height: _profileImageHeight,
      width: _profileImageHeight,
      child: Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: colors(context).primary,
          size: _profileImageHeight - 75,
        ),
      ),
    );
  }

  Border _buildProfileImageBorder(BuildContext context) {
    return Border(
      top: _buildBorderSide(context),
      bottom: _buildBorderSide(context),
      right: _buildBorderSide(context),
      left: _buildBorderSide(context),
    );
  }

  BorderSide _buildBorderSide(BuildContext context) => BorderSide(
        width: 5,
        color: colors(context).primary,
      );

  Widget _buildSaveFamilyButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          String? profileImageUrl;
          _familyMemberViewModel.createFamilyMember(
              imageFile: _imageFile,
              familyId: widget.familyId,
              imageUrl: profileImageUrl,
              username: _userNameTextController.text,
              password: _passwordTextController.text);
        }
      },
      tooltip: 'Save family',
      child: Icon(Icons.save),
    );
  }

  Widget _buildName(BuildContext context) {
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

  Widget _buildLastName(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Surname',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter a surname';
        }
        return null;
      },
      controller: _lastNameTextController,
    );
  }

  Widget _buildUserName(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Username',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
      controller: _userNameTextController,
    );
  }

  Widget _buildPasswordInput() {
    return StreamBuilder<bool>(
        stream: _authenticationViewModel.isPasswordValid,
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
                _authenticationViewModel.isPasswordValid.add(false);
                return 'Please enter a valid password.';
              }
              return null;
            },
            controller: _passwordTextController,
          );
        });
  }

  Widget _buildValidPasswordMessage() {
    return StreamBuilder<bool>(
        stream: _authenticationViewModel.isPasswordValid,
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

  Widget _buildDateOfBirth() {
    return DateTimeField(
      format: DateFormat('MMMM d, yyyy'),
      decoration: InputDecoration(
        labelStyle: ChoresAppText.body4Style,
        hintStyle: ChoresAppText.body4Style,
        contentPadding: EdgeInsets.zero,
        labelText: 'Date of Birth',
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select their date of birth.';
        }
        return null;
      },
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime.now().add(
            Duration(days: 36500),
          ),
        );
        if (date != null) {
          _familyMemberViewModel.setFamilyMemberDateOfBirth(date);
        }
        return date;
      },
    );
  }

  Widget _buildFamilyMemberTypePicker(FamilyMember? familyMember) {
    return SwitchListTile.adaptive(
      title: Padding(
        padding: const EdgeInsets.only(
          bottom: 8.0,
        ),
        child: Text(
          'Family Member is a child?',
          style: ChoresAppText.body1Style,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      value: familyMember?.familyMemberType == FamilyMemberType.child,
      onChanged: (value) {
        if (value) {
          _familyMemberViewModel.setFamilyMemberType(FamilyMemberType.child);
        } else {
          _familyMemberViewModel.setFamilyMemberType(FamilyMemberType.parent);
        }
      },
    );
  }

  Future<void> _getImageForImageSource(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.getImage(
        source: source,
        maxWidth: 200,
        maxHeight: 200,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _buildWave() {
    return WaveWidget(
      config: CustomConfig(
        colors: [
          Colors.white70,
          Colors.white54,
          Colors.white30,
          Colors.white24,
        ],
        durations: [32000, 21000, 18000, 5000],
        heightPercentages: [0.52, 0.53, 0.55, 0.58],
        // blur: _blurs[3],
      ),
      backgroundColor: colors(context).primary,
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 0,
    );
  }
}
