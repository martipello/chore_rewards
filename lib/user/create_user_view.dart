import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../families/family_list_view.dart';
import '../models/user.dart';
import '../shared_widgets/image_picker_bottom_sheet.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../utils/log.dart';
import '../view_models/user_view_model.dart';

class CreateUserView extends StatefulWidget {
  @override
  _CreateUserViewState createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  final _userViewModel = getIt.get<UserViewModel>();
  final _nameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = getIt.get<ImagePicker>();
  final _profileImageHeight = 150.0;
  File? _imageFile;
  dynamic _pickImageError;

  @override
  void initState() {
    super.initState();
    _userViewModel.createUserStream.listen((value) {
      logger(value);
      if (value.status == Status.COMPLETED) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            FamilyListView.routeName,
          );
        }
      }
    });
    _addTextListeners();
  }

  void _addTextListeners() {
    _nameTextController.addListener(() {
      _userViewModel.setUserName(
        _nameTextController.text,
      );
    });

    _lastNameTextController.addListener(() {
      _userViewModel.setUserLastName(
        _lastNameTextController.text,
      );
    });
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _lastNameTextController.dispose();
    _userViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ApiResponse>(
        stream: _userViewModel.createUserStream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: StreamBuilder<User>(
                    stream: _userViewModel.userStream,
                    builder: (context, userSnapshot) {
                      return Stack(
                        children: [
                          SizedBox(
                            height: 370,
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
                                    height: kToolbarHeight + 16,
                                  ),
                                  _buildProfileHeader(context),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _buildName(context),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _buildLastName(context),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  _buildDateOfBirth(),
                                  SizedBox(
                                    height: 72,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              if (snapshot.hasData && snapshot.data!.status != Status.LOADING)
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
        },
      ),
      floatingActionButton: _buildSaveUserButton(context),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCreateProfileHeader(context),
        SizedBox(
          height: 24,
        ),
        Center(
          child: _buildProfileImage(context),
        ),
      ],
    );
  }

  Widget _buildCreateProfileHeader(BuildContext context) {
    return Center(
      child: Text(
        'Create a Profile',
        style: ChoresAppText.h3Style.copyWith(
          color: colors(context).textOnPrimary,
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return DecoratedBox(
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

  Widget _buildSaveUserButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _userViewModel.createUser(imageFile: _imageFile);
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
        labelText: 'Your name...',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter your name';
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
        labelText: 'Your Surname...',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter your surname';
        }
        return null;
      },
      controller: _lastNameTextController,
    );
  }

  Widget _buildDateOfBirth() {
    return DateTimeField(
      format: DateFormat('MMMM d, yyyy'),
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Your Date of Birth',
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select your date of birth.';
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
          _userViewModel.setUserDateOfBirth(date);
        }
        return date;
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
