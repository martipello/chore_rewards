import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dependency_injection_container.dart';
import '../extensions/chore_extension.dart';
import '../models/allocation.dart';
import '../models/chore.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../utils/constants.dart';
import '../view_models/chore/chore_view_model.dart';
import 'chore_tile.dart';

class ChoreListView extends StatelessWidget {
  ChoreListView({
    required this.familyId,
    required this.allocation,
  });

  final String familyId;
  final Allocation allocation;

  final _choreViewModel = getIt.get<ChoreViewModel>();
  final sharedPreferences = getIt.get<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 64),
          sliver: _buildChoreList(),
        ),
      ],
    );
  }

  Widget _buildChoreList() {
    return StreamBuilder<QuerySnapshot<Chore>?>(
      stream: _choreViewModel.getChores(familyId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final choreList = _getChoreList(snapshot.data?.docs);
          if (choreList.isNotEmpty) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildChoreListItem(
                    context,
                    index,
                    choreList[index],
                    allocation,
                  );
                },
                childCount: choreList.length,
              ),
            );
          } else {
            return SliverFillRemaining(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/chores_app.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                      color: colors(context).textOnForeground,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'No chores...',
                      style: ChoresAppText.h6Style.copyWith(
                        color: colors(context).textOnForeground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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

  List<Chore> _getChoreList(List<QueryDocumentSnapshot<Chore>>? snapshot) {
    final userId = sharedPreferences.getString(Constants.USER_ID) ?? '';
    if (snapshot == null) {
      return [];
    }
    if (allocation == Allocation.available) {
      return snapshot
          .where(
            (chore) =>
                chore.data().allocation == Allocation.available &&
                !chore.data().isExpired() &&
                chore.data().isChoreAvailableToFamilyMember(userId),
          )
          .map(
            (e) => e.data(),
          )
          .toList();
    } else if (allocation == Allocation.none) {
      return snapshot
          .where((chore) => chore.data().createdBy?.id == userId)
          .map(
            (e) => e.data(),
          )
          .toList();
    } else {
      return snapshot
          .where((chore) => chore.data().allocation == allocation && !chore.data().isExpired())
          .map(
            (e) => e.data(),
          )
          .toList();
    }
  }

  Widget _buildChoreListItem(
    BuildContext context,
    int index,
    Chore chore,
    Allocation allocation,
  ) {
    return ChoreTile(
      chore: chore,
      familyId: familyId,
      allocation: allocation,
    );
  }
}
