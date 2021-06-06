import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import 'family_member_tile.dart';
import '../models/family.dart';
import '../models/family_member.dart';
import '../theme/chores_app_text.dart';
import '../view_models/family/family_member_view_model.dart';

class FamilyMemberPicker extends StatelessWidget {
  FamilyMemberPicker({
    Key? key,
    required this.familyId,
    required this.selectedFamilyMember,
  }) : super(key: key);

  final String familyId;
  final ValueChanged<FamilyMember?> selectedFamilyMember;

  final _familyViewModel = getIt.get<FamilyMemberViewModel>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Family>>(
      stream: _familyViewModel.getFamily(familyId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.data()?.familyMembers.isNotEmpty == true) {
            return DropdownButtonFormField<FamilyMember>(
              onChanged: selectedFamilyMember,
              hint: Text('Select a family member?', style: ChoresAppText.body4Style,),
              items: snapshot.data?.data()?.familyMembers.toList().map(_buildFamilyMemberDropDownMenuItem).toList(),
            );
          } else {
            return Text(
              'No Family members with banks, please create one to get started.',
              textAlign: TextAlign.center,
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  DropdownMenuItem<FamilyMember> _buildFamilyMemberDropDownMenuItem(FamilyMember familyMember) {
    return DropdownMenuItem<FamilyMember>(
      value: familyMember,
      onTap: () {
        selectedFamilyMember.call(familyMember);
      },
      child: SizedBox(
        width: 100,
        child: FamilyMemberTile(
          familyMember: familyMember,
        ),
      ),
    );
  }
}
