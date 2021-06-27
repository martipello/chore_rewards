import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dependency_injection_container.dart';
import '../models/family_member.dart';
import '../models/family_member_type.dart';
import '../utils/constants.dart';
import '../view_models/family/create_family_member_view_model.dart';
import 'spend_bank_dialog.dart';

class SpendBankButton extends StatelessWidget {
  SpendBankButton({
    Key? key,
    required this.familyId,
    required this.sharedPreferences,
  }) : super(key: key);

  final String familyId;
  final SharedPreferences sharedPreferences;
  final _familyViewModel = getIt.get<CreateFamilyMemberViewModel>();

  @override
  Widget build(BuildContext context) {
    final familyMemberId = sharedPreferences.getString(Constants.USER_ID) ?? '';
    return StreamBuilder<DocumentSnapshot<FamilyMember>>(
      stream: _familyViewModel.getFamilyMember(familyId, familyMemberId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.data()?.familyMemberType == FamilyMemberType.parent) {
            return FloatingActionButton(
              onPressed: () {
                final familyMember = snapshot.data?.data();
                if (familyMember != null) {
                  SpendBankDialog.show(context, familyMember, familyId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Oops there was a problem...'))
                  );
                }
              },
              child: Icon(Icons.attach_money_rounded),
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
}
