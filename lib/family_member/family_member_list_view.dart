import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../models/family_member.dart';
import '../view_models/family/family_member_view_model.dart';
import 'family_member_tile.dart';

class FamilyMemberListView extends StatelessWidget {
  FamilyMemberListView({required this.familyId});

  final String familyId;

  final _familyMemberViewModel = getIt.get<FamilyMemberViewModel>();

  @override
  Widget build(BuildContext context) {
    return _buildFamilyList(context);
  }

  Widget _buildFamilyList(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: EdgeInsets.all(8),
          sliver: StreamBuilder<QuerySnapshot<FamilyMember>>(
            stream: _familyMemberViewModel.getFamilyMemberList(familyId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.docs.isNotEmpty == true) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildFamilyListItem(context, index, snapshot.data!.docs[index].data());
                      },
                      childCount: snapshot.data?.docs.length ?? 0,
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
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyListItem(BuildContext context, int index, FamilyMember familyMember) {
    return FamilyMemberTile(familyMember: familyMember);
  }
}
