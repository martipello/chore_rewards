import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../models/chore.dart';
import '../theme/chores_app_text.dart';
import '../view_models/chore/chore_view_model.dart';
import 'chore_tile.dart';

class ChoreListView extends StatelessWidget {
  ChoreListView({required this.familyId});

  final String familyId;

  final _choreViewModel = getIt.get<ChoreViewModel>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: EdgeInsets.all(8),
          sliver: _buildChoreList(),
        ),
      ],
    );
  }

  Widget _buildChoreList() {
    return StreamBuilder<BuiltList<Chore>?>(
        stream: _choreViewModel.getChores(familyId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.isNotEmpty == true) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildChoreListItem(context, index, snapshot.data![index]);
                  },
                  childCount: snapshot.data?.length ?? 0,
                ),
              );
            } else {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No chores...',
                    style: ChoresAppText.body1Style,
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
        });
  }

  Widget _buildChoreListItem(BuildContext context, int index, Chore chore) {
    return ChoreTile(chore: chore);
  }
}
