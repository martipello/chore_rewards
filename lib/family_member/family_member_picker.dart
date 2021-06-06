import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/family.dart';
import '../models/family_member.dart';
import '../shared_widgets/circle_image.dart';
import '../theme/chores_app_text.dart';
import '../utils/constants.dart';
import '../view_models/family/family_member_view_model.dart';

class FamilyMemberPicker extends StatelessWidget {
  FamilyMemberPicker({
    Key? key,
    required this.familyId,
    required this.formKey,
    required this.selectedFamilyMember,
  }) : super(key: key);

  final String familyId;
  final GlobalKey<FormState> formKey;
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
              onChanged: (familyMember){
                selectedFamilyMember.call(familyMember);
                formKey.currentState!.validate();
              },
              hint: Text(
                'Select a family member...',
                style: ChoresAppText.body4Style,
              ),
              iconSize: 50,
              icon: Icon(
                Icons.arrow_drop_down,
                size: 24,
              ),
              validator: (familyMember){
                if (familyMember == null) {
                  return 'Please select family members';
                }
                return null;
              },
              items: [
                FamilyMember((b) => b..name = Constants.ALL_FAMILY_MEMBERS..image = snapshot.data?.data()?.image),
                ...snapshot.data?.data()?.familyMembers.toList() ?? <FamilyMember>[]
              ].map(_buildFamilyMemberDropDownMenuItem).toList(),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleImage(imagePath: familyMember.image ?? '', height: 34),
            SizedBox(
              width: 16,
            ),
            Text(
              familyMember.name?.capitalize() ?? '',
              style: ChoresAppText.subtitle2Style,
            ),
          ],
        ),
      ),
    );
  }
}
