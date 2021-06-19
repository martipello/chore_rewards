import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../models/family_member.dart';
import '../models/family_member_type.dart';
import '../shared_widgets/image_picker_bottom_sheet.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../utils/log.dart';
import '../view_models/family/family_view_model.dart';
import '../view_models/user_view_model.dart';

class AddFamilyView extends StatefulWidget {
  @override
  _AddFamilyViewState createState() => _AddFamilyViewState();
}

class _AddFamilyViewState extends State<AddFamilyView> {
  final _familyViewModel = getIt.get<FamilyViewModel>();
  final _userViewModel = getIt.get<UserViewModel>();
  final _textController = TextEditingController();
  final _pinInputTextController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = getIt.get<ImagePicker>();
  File? _imageFile;
  dynamic _pickImageError;

  @override
  void initState() {
    super.initState();
    _familyViewModel.saveFamilyResult.listen((value) {
      logger(value);
      if (value.status == Status.COMPLETED) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Family'),
      ),
      body: StreamBuilder<ApiResponse>(
          stream: _familyViewModel.saveFamilyResult,
          builder: (context, snapshot) {
            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 240,
                          width: double.infinity,
                          child: _buildWave(),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildProfileHeader(),
                              SizedBox(
                                height: 36,
                              ),
                              _buildName(context),
                              SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 64.0, right: 64),
                                child: Text(
                                  'As its creator you will be added as the head parent of this family.',
                                  style: ChoresAppText.body4Style,
                                ),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                                child: PinPut(
                                  fieldsCount: 4,
                                  focusNode: _pinPutFocusNode,
                                  controller: _pinInputTextController,
                                  submittedFieldDecoration: _pinPutDecoration,
                                  selectedFieldDecoration: _pinPutFilledDecoration,
                                  followingFieldDecoration: _pinPutDecoration,
                                  pinAnimationType: PinAnimationType.scale,
                                  textStyle: TextStyle(fontSize: 20.0),
                                  validator: (value){
                                    final length = value?.length ?? 0;
                                    if (length < 4) {
                                      return 'Please enter a 4 digit pin.';
                                    }
                                  },
                                  inputDecoration: _pinInputDecoration(),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                                child: Text(
                                  'This pin is required for adding new family members.',
                                  style: ChoresAppText.body4Style,
                                ),
                              ),
                              SizedBox(
                                height: 36,
                              ),
                            ],
                          ),
                        ),
                      ],
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

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(90)),
      border: Border.all(color: colors(context).secondary),
    );
  }

  BoxDecoration get _pinPutFilledDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(90)),
      color: colors(context).secondary,
    );
  }

  InputDecoration _pinInputDecoration() {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      counterText: ''
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        Center(
          child: _buildProfileImage(context),
        ),
        SizedBox(
          height: 32,
        ),
      ],
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
                        height: 200,
                        width: 200,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: _buildProfileImageBorder(context),
                        ),
                        height: 200,
                        width: 200,
                      )
                    ],
                  )
                : _buildAddImageIcon(),
          ),
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

  Widget _buildAddImageIcon() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 100,
        ),
      ),
    );
  }

  Widget _buildSaveFamilyButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final user = await _userViewModel.userDocument;
        if (_formKey.currentState!.validate()) {
          String? profileImageUrl;
          _familyViewModel.createFamily(
            _textController.text,
            _pinInputTextController.text,
            imageUrl: profileImageUrl,
            imageFile: _imageFile,
            familyMember: FamilyMember((b) => b
              ..id = user.data()?.id
              ..name = user.data()?.name
              ..image = user.data()?.image
              ..dateOfBirth = user.data()?.dateOfBirth
              ..familyMemberType = FamilyMemberType.parent),
          );
        }
      },
      tooltip: 'Save family',
      child: Icon(Icons.save),
    );
  }

  Widget _buildName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: TextFormField(
        maxLines: 1,
        style: ChoresAppText.body4Style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'Family name...',
        ),
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Please enter a family name';
          }
          return null;
        },
        controller: _textController,
      ),
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
