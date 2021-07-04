import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../shared_widgets/rounded_button.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

enum AddOrCreateFamilyMemberDialogNavigationOptions {
  add,
  create,
}

class AddOrCreateFamilyMemberDialog extends StatefulWidget {
  AddOrCreateFamilyMemberDialog({
    Key? key,
    required this.familyId,
    required this.pin,
  }) : super(key: key);

  final String pin;
  final String familyId;

  static Future<AddOrCreateFamilyMemberDialogNavigationOptions?> show(
      BuildContext context, String pin, String familyId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddOrCreateFamilyMemberDialog(
          pin: pin,
          familyId: familyId,
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  @override
  _AddOrCreateFamilyMemberDialogState createState() => _AddOrCreateFamilyMemberDialogState();
}

class _AddOrCreateFamilyMemberDialogState extends State<AddOrCreateFamilyMemberDialog> {
  final _pinInputTextController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool? pinSuccess = false;

  @override
  Widget build(BuildContext context) {
    return _buildAcceptChoreContent(context);
  }

  Widget _buildAcceptChoreContent(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 36,
          ),
          if (pinSuccess != true) _buildAddOrCreateTitle(context),
          if (pinSuccess == true) _buildPinAccepted(),
          SizedBox(
            height: 32,
          ),
          // if (snapshot.data?.status == Status.ERROR) _buildErrorWidget(snapshot.data?.error),
          if (pinSuccess != true) _buildButtonBar(context, false),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildAddOrCreateTitle(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add or Create', style: ChoresAppText.subtitle1Style.copyWith(height: 1)),
            SizedBox(
              height: 16,
            ),
            Text(
              'Would you like to add an existing family member, or create a new one?',
              style: ChoresAppText.body4Style.copyWith(height: 1),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Pin required.',
              style: ChoresAppText.body4Style.copyWith(height: 1),
            ),
            SizedBox(
              height: 16,
            ),
            PinPut(
              fieldsCount: 4,
              focusNode: _pinPutFocusNode,
              controller: _pinInputTextController,
              submittedFieldDecoration: _pinPutDecoration,
              selectedFieldDecoration: _pinPutFilledDecoration,
              followingFieldDecoration: _pinPutDecoration,
              pinAnimationType: PinAnimationType.scale,
              fieldsAlignment: MainAxisAlignment.spaceEvenly,
              textStyle: TextStyle(fontSize: 20.0),
              validator: (value) {
                final length = value?.length ?? 0;
                if (length < 4 || _pinInputTextController.text != widget.pin) {
                  return 'Incorrect pin.';
                }
                return null;
              },
              inputDecoration: _pinInputDecoration(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinAccepted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline_outlined,
          size: 96,
          color: colors(context).positive,
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Pin Accepted',
          style: ChoresAppText.subtitle1Style,
        )
      ],
    );
  }

  Widget _buildButtonBar(BuildContext context, bool isLoading) {
    return Row(
      children: [
        _buildMediumMargin(),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 32),
            child: _buildAddFamilyMemberButton(
              context,
              'Add',
              isLoading,
              () {
                _validatePin(
                  context,
                  AddOrCreateFamilyMemberDialogNavigationOptions.add,
                );
              },
            ),
          ),
        ),
        _buildMediumMargin(),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 32),
            child: _buildDeclineButton(
              context,
              'Create',
              () {
                _validatePin(
                  context,
                  AddOrCreateFamilyMemberDialogNavigationOptions.create,
                );
              },
            ),
          ),
        ),
        _buildMediumMargin(),
      ],
    );
  }

  void _validatePin(
    BuildContext context,
    AddOrCreateFamilyMemberDialogNavigationOptions option,
  ) {
    final _pinSuccess = _formKey.currentState!.validate();
    setState(
      () {
        pinSuccess = _pinSuccess;
      },
    );
    if (_pinSuccess) {
      Future.delayed(Duration(seconds: 1)).then(
        (value) {
          if (mounted) {
            Navigator.of(context).pop(option);
          }
        },
      );
    }
  }

  Widget _buildMediumMargin() {
    return SizedBox(
      width: 16,
    );
  }

  Widget _buildAddFamilyMemberButton(
    BuildContext context,
    String label,
    bool isLoading,
    VoidCallback onPressed,
  ) {
    return RoundedButton(
      label: label,
      textStyle: ChoresAppText.body3Style,
      fillColor: colors(context).secondary,
      isLoading: isLoading,
      isFilled: true,
      onPressed: onPressed,
    );
  }

  Widget _buildDeclineButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
  ) {
    return RoundedButton(
      label: label,
      textStyle: ChoresAppText.body3Style,
      fillColor: colors(context).error,
      isFilled: true,
      onPressed: onPressed,
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
        counterText: '');
  }
}
