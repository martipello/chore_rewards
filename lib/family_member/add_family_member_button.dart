import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dependency_injection_container.dart';
import '../models/family_member.dart';
import '../models/family_member_type.dart';
import '../shared_widgets/chores_app_dialog.dart';
import '../shared_widgets/rounded_button.dart';
import '../utils/constants.dart';
import '../view_models/family/family_member_view_model.dart';
import 'add_family_member_view.dart';

class AddFamilyMemberButton extends StatelessWidget {
  AddFamilyMemberButton({
    Key? key,
    required this.familyId,
    required this.sharedPreferences,
  }) : super(key: key);

  final String familyId;
  final SharedPreferences sharedPreferences;
  final _familyViewModel = getIt.get<FamilyMemberViewModel>();

  @override
  Widget build(BuildContext context) {
    final familyMemberId = sharedPreferences.getString(Constants.USER_ID) ?? '';
    return StreamBuilder<DocumentSnapshot<FamilyMember>>(
      stream: _familyViewModel.getFamilyMember(familyId, familyMemberId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.data()?.familyMemberType == FamilyMemberType.parent) {
            return RoundedButton(
              label: 'Add Family Member',
              onPressed: () {
                _showAddOrCreateFamilyDialog(context);
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

  void _showAddOrCreateFamilyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ChoresAppDialog(
          title: 'Add or Create',
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Would you like to add an existing family member or create a new one',
            ),
          ),
          dialogActions: [
            DialogAction(
              actionText: 'Add',
              actionVoidCallback: () {
                Navigator.of(context).pop();
                _navigateToAddFamilyMemberView(context, familyId);
              },
            ),
            DialogAction(actionText: 'Create', actionVoidCallback: () {}),
          ],
        );
      },
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
