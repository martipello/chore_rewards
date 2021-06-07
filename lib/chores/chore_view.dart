import 'package:flutter/material.dart';

import 'chore_list_view.dart';

class ChoreView extends StatelessWidget {
  const ChoreView({
    Key? key,
    required this.tabController,
    required this.familyId,
  }) : super(key: key);
  final TabController tabController;
  final String familyId;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        ChoreListView(familyId: familyId),
        ChoreListView(familyId: familyId),
        ChoreListView(familyId: familyId),
      ],
    );
  }

}
