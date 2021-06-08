import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/family_member.dart';
import '../models/transaction.dart' as t;
import '../models/transaction_type.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../view_models/family/family_member_view_model.dart';
import '../view_models/piggy_bank_view_model.dart';

class BankListView extends StatelessWidget {
  BankListView({
    required this.familyId,
  });

  final String familyId;

  final _piggyBankViewModel = getIt.get<PiggyBankViewModel>();
  final _familyMemberViewModel = getIt.get<FamilyMemberViewModel>();
  final sharedPreferences = getIt.get<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16,),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: _buildProfileImageBorder(context),
                  ),
                  height: 120,
                  width: 120,
                  child: Center(
                    child: Icon(
                      Icons.attach_money_rounded,
                      size: 100,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              StreamBuilder<DocumentSnapshot<FamilyMember>>(
                stream: _familyMemberViewModel.getFamilyMember(familyId),
                builder: (context, snapshot) {
                  return Text(
                    'BALANCE : ${snapshot.data?.data()?.piggyBank?.balance ?? 0}',
                    style: ChoresAppText.subtitle1Style,
                    textAlign: TextAlign.center,
                  );
                }
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 64),
          sliver: _buildChoreList(),
        ),
      ],
    );
  }

  Border _buildProfileImageBorder(BuildContext context) {
    return Border(
      top: _buildBorderSide(context),
      bottom: _buildBorderSide(context),
      right: _buildBorderSide(context),
      left: _buildBorderSide(context),
    );
  }

  BorderSide _buildBorderSide(BuildContext context) => BorderSide(
        width: 5,
        color: colors(context).primary,
      );

  Widget _buildChoreList() {
    return StreamBuilder<QuerySnapshot<t.Transaction>>(
      stream: _piggyBankViewModel.getTransactions(familyId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final transactionList = snapshot.data?.docs ?? [];
          if (transactionList.isNotEmpty) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildTransactionListItem(
                    context,
                    index,
                    transactionList[index].data(),
                  );
                },
                childCount: transactionList.length,
              ),
            );
          } else {
            return SliverFillRemaining(
              child: Center(
                child: Text(
                  'No transactions...',
                  style: ChoresAppText.h6Style.copyWith(
                    color: colors(context).textOnForeground,
                  ),
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

  Widget _buildTransactionListItem(
    BuildContext context,
    int index,
    t.Transaction transaction,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {},
          child: ListTile(
            title: Text(transaction.title?.capitalize() ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Icon(
                    Icons.star,
                    size: 18,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '${transaction.reward?.toString() ?? '0'}',
                  style: ChoresAppText.subtitle1Style.copyWith(height: 1),
                ),
                Text(
                  _getTransactionType(transaction),
                  style: ChoresAppText.subtitle1Style.copyWith(height: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTransactionType(t.Transaction? transaction) {
    if (transaction?.transactionType != null) {
      switch(transaction!.transactionType!){
        case TransactionType.addition :
          return ' +';
        case TransactionType.subtraction :
          return ' -';
      }
    }
    return '';
  }
}
