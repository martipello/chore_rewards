import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dependency_injection_container.dart';
import '../models/family_member.dart';
import '../models/family_member_type.dart';
import '../shared_widgets/rounded_button.dart';
import '../utils/constants.dart';
import '../view_models/family/create_family_member_view_model.dart';
import 'add_family_member_view.dart';
import 'add_or_create_family_member_dialog.dart';
import 'create_family_member_view.dart';

class AddOrCreateFamilyMemberButton extends StatelessWidget {
  AddOrCreateFamilyMemberButton({
    Key? key,
    required this.familyId,
    required this.pin,
    required this.sharedPreferences,
  }) : super(key: key);

  final String familyId;
  final String pin;
  final SharedPreferences sharedPreferences;
  final _familyViewModel = getIt.get<CreateFamilyMemberViewModel>();

  @override
  Widget build(BuildContext context) {
    final familyMemberId = sharedPreferences.getString(Constants.USER_ID) ?? '';
    return StreamBuilder<DocumentSnapshot<FamilyMember>>(
      stream: _familyViewModel.getFamilyMember(
        familyId,
        familyMemberId,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.data()?.familyMemberType == FamilyMemberType.parent) {
            return RoundedButton(
              label: 'Add Family Member',
              onPressed: () {
                _showAddOrCreateFamilyDialog(context, pin);
              },
              leadingIcon: Icons.add_circle_outline_rounded,
            );
          } else {
            return SizedBox();
          }
        } else if (snapshot.hasError) {
          return SizedBox();
        } else {
          return SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void _showAddOrCreateFamilyDialog(BuildContext context, String pin) async {
    final isNavigate = await AddOrCreateFamilyMemberDialog.show(context, pin, familyId);
    if (isNavigate == AddOrCreateFamilyMemberDialogNavigationOptions.create) {
      _navigateToCreateFamilyMemberView(context, familyId);
    } else if (isNavigate == AddOrCreateFamilyMemberDialogNavigationOptions.add) {
      _navigateToAddFamilyMemberView(context, familyId);
    }
  }

  void _navigateToCreateFamilyMemberView(BuildContext context, String familyId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CreateFamilyMemberView(
            familyId: familyId,
          );
        },
      ),
    );
  }

  void _navigateToAddFamilyMemberView(BuildContext context, String familyId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddFamilyMemberView(
            familyId: familyId,
          );
        },
      ),
    );
  }
}
