import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../dependency_injection_container.dart';
import '../models/family_member.dart';
import '../models/transaction.dart' as t;
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../utils/constants.dart';
import '../view_models/family/family_member_view_model.dart';
import '../view_models/piggy_bank_view_model.dart';
import 'balance_tile.dart';
import 'transaction_tile.dart';

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
        SliverPadding(
          padding: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 64),
          sliver: _buildChoreList(),
        ),
      ],
    );
  }

  Widget _buildChoreList() {
    final familyMemberId = sharedPreferences.getString(Constants.USER_ID) ?? '';
    return StreamBuilder<DocumentSnapshot<FamilyMember>>(
      stream: _familyMemberViewModel.getFamilyMember(familyId, familyMemberId),
      builder: (context, balanceSnapshot) {
        return StreamBuilder<QuerySnapshot<t.Transaction>>(
          stream: _piggyBankViewModel.getTransactions(familyId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final transactionList = snapshot.data?.docs ?? [];
              final familyMember = balanceSnapshot.data?.data();
              if (transactionList.isNotEmpty) {
                transactionList.sort((doc, doc2) {
                  final date1 = doc.data().date ?? DateTime.now();
                  final date2 = doc2.data().date ?? DateTime.now();
                  return date2.compareTo(date1);
                });
                return MultiSliver(
                  children: [
                    if (familyMember != null) _buildBalanceItem(familyMember),
                    SliverList(
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
                    ),
                  ],
                );
              } else {
                return MultiSliver(
                  children: [
                    if (familyMember != null) _buildBalanceItem(familyMember),
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No transactions...',
                          style: ChoresAppText.h6Style.copyWith(
                            color: colors(context).textOnForeground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
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
      },
    );
  }

  Widget _buildBalanceItem(FamilyMember familyMember) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 4.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return BalanceTile(familyMember: familyMember);
          },
          childCount: 1,
        ),
      ),
    );
  }

  Widget _buildTransactionListItem(
    BuildContext context,
    int index,
    t.Transaction transaction,
  ) {
    return TransactionTile(transaction: transaction);
  }
}
