import 'package:flutter/material.dart';

import '../shared_widgets/chores_app_dialog.dart';
import '../shared_widgets/rounded_button.dart';
import 'add_family_member_view.dart';

class AddFamilyMemberButton extends StatelessWidget {
  const AddFamilyMemberButton({Key? key, required this.familyId}) : super(key: key);

  final String familyId;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      label: 'Add Family Member',
      onPressed: () {
        _showAddOrCreateFamilyDialog(context);
      },
      leadingIcon: Icons.add_circle_outline_rounded,
    );
  }

  void _showAddOrCreateFamilyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ChoresAppDialog(
          title: 'Add or Create',
          content: Text(
            'Would you like to add an existing family member or create a new one',
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
