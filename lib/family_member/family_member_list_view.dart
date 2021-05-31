import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../models/family.dart';
import '../models/family_member.dart';
import '../view_models/family/family_member_view_model.dart';
import 'family_member_tile.dart';

class FamilyMemberListView extends StatelessWidget {
  FamilyMemberListView({required this.familyId});

  final String familyId;

  final _familyViewModel = getIt.get<FamilyMemberViewModel>();

  @override
  Widget build(BuildContext context) {
    return _buildFamilyList();
  }

  Widget _buildFamilyList() {
    return StreamBuilder<DocumentSnapshot<Family>>(
      stream: _familyViewModel.getFamily(familyId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.data()?.familyMembers.isNotEmpty == true) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildFamilyListItem(context, index, snapshot.data!.data()!.familyMembers[index]);
                },
                childCount: snapshot.data?.data()?.familyMembers.length ?? 0,
              ),
            );
          } else {
            return SliverFillRemaining(
              child: Center(
                child: Text(
                  'No Family members with banks, please create one to get started.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        } else {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildFamilyListItem(BuildContext context, int index, FamilyMember familyMember) {
    return FamilyMemberTile(familyMember: familyMember);
  }
}
