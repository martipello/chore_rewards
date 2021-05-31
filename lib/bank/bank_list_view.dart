import 'package:flutter/material.dart';

class BankListView extends StatelessWidget {
  final familyMembers = ['Child 1', 'Child 2', 'Child 3'];

  @override
  Widget build(BuildContext context) {
    return _buildFamilyList();
  }

  Widget _buildFamilyList() {
    return familyMembers.isNotEmpty
        ? ListView.builder(itemCount: familyMembers.length, itemBuilder: _buildFamilyListItem)
        : Center(
            child: Text(
              'No Family members with banks, please create one to get started.',
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget _buildFamilyListItem(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.only(top: index == 0 ? 8 : 0, right: 8, bottom: 8, left: 8),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            // _navigateToFamilyDetailView(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  familyMembers[index],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
