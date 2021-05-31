import 'package:flutter/material.dart';

import '../shared_widgets/rounded_button.dart';
import 'add_chore_view.dart';

class AddChoreButton extends StatelessWidget {
  const AddChoreButton({Key? key, required this.familyId}) : super(key: key);

  final String familyId;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      label: 'Add Chore',
      onPressed: () {
        _navigateToAddChoreView(context, familyId);
      },
      leadingIcon: Icons.add_circle_outline_rounded,
    );
  }

  void _navigateToAddChoreView(BuildContext context, String familyId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddChoreView(familyId: familyId);
        },
      ),
    );
  }
}
