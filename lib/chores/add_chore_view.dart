import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../family_member/family_member_picker.dart';
import '../models/chore.dart';
import '../shared_widgets/image_picker_bottom_sheet.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../utils/log.dart';
import '../view_models/chore/chore_view_model.dart';

class AddChoreView extends StatefulWidget {
  AddChoreView({required this.familyId});

  final String familyId;

  @override
  _AddChoreViewState createState() => _AddChoreViewState();
}

class _AddChoreViewState extends State<AddChoreView> {
  final _choreViewModel = getIt.get<ChoreViewModel>();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = getIt.get<ImagePicker>();
  final _profileImageHeight = 150.0;
  File? _imageFile;
  dynamic _pickImageError;

  @override
  void initState() {
    super.initState();
    _choreViewModel.saveChoreResult.listen((value) {
      logger(value);
      if (value.status == Status.COMPLETED) {
        Navigator.of(context).pop();
      }
    });
    _addTextListeners();
  }

  void _addTextListeners() {
    _titleTextController.addListener(() {
      _choreViewModel.setChoreTitle(_titleTextController.text);
    });

    _descriptionTextController.addListener(() {
      _choreViewModel.setChoreDescription(_descriptionTextController.text);
    });
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    _choreViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Chore'),
      ),
      body: StreamBuilder<ApiResponse>(
          stream: _choreViewModel.saveChoreResult,
          builder: (context, snapshot) {
            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: StreamBuilder<Chore>(
                      stream: _choreViewModel.createChoreStream,
                      builder: (context, userSnapshot) {
                        return Stack(
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
                                    Center(
                                      child: _buildProfileImage(context),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    _buildTitle(context),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    _buildDescription(context),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    _buildExpiryDate(),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    _buildRewardCounter(),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    _buildFamilyMemberPicker(),
                                    SizedBox(
                                      height: 72,
                                    ),
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
                      ),
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

  Widget _buildSaveFamilyButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          String? profileImageUrl;
          _choreViewModel.createChore(
            imageFile: _imageFile,
            familyId: widget.familyId,
            imageUrl: profileImageUrl,
          );
        }
      },
      tooltip: 'Save chore',
      child: Icon(
        Icons.save,
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

  Widget _buildTitle(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Title',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
      controller: _titleTextController,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Description',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
      controller: _descriptionTextController,
    );
  }

  Widget _buildExpiryDate() {
    return DateTimeField(
      format: DateFormat('MMMM d, yyyy'),
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Expiry date',
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select an expiry date.';
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
          _choreViewModel.setChoreExpiry(date);
        }
        return date;
      },
    );
  }

  Widget _buildRewardCounter() {
    return StreamBuilder<Chore>(
      stream: _choreViewModel.createChoreStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set reward',
              style: ChoresAppText.body1Style,
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _choreViewModel.minusChoreReward,
                  backgroundColor: colors(context).primary,
                  child: Icon(
                    Icons.remove,
                    color: colors(context).textOnPrimary,
                  ),
                ),
                Text(
                  '${snapshot.data?.reward?.toInt() ?? 0}',
                  style: ChoresAppText.subtitle2Style,
                ),
                FloatingActionButton(
                  onPressed: _choreViewModel.addChoreReward,
                  backgroundColor: colors(context).primary,
                  child: Icon(
                    Icons.add,
                    color: colors(context).textOnPrimary,
                  ),
                ),
              ],
            ),
          ],
        );
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

  Widget _buildFamilyMemberPicker() {
    return FamilyMemberPicker(
      familyId: widget.familyId,
      formKey: _formKey,
      selectedFamilyMember: _choreViewModel.setAllocatedFamilyMember,
    );
  }
}
