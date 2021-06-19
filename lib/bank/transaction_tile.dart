import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../extensions/string_extension.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../theme/chores_app_text.dart';
import 'transaction_detail_view.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({Key? key, required this.transaction}) : super(key: key);
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            _navigateToTransactionDetailView(context, transaction);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(transaction.title?.capitalize() ?? ''),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(transactionDateTime(transaction.date)),
              ),
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
      ),
    );
  }

  String transactionDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      final dayOfMonthSuffix = getDayOfMonthSuffix(dateTime.day);
      return DateFormat("EEEE d'$dayOfMonthSuffix' MMMM yyyy").format(dateTime);
    }
    return '';
  }

  String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
  String _getTransactionType(Transaction? transaction) {
    if (transaction?.transactionType != null) {
      switch (transaction!.transactionType!) {
        case TransactionType.addition:
          return ' +';
        case TransactionType.subtraction:
          return ' -';
      }
    }
    return '';
  }

  void _navigateToTransactionDetailView(
      BuildContext context,
      Transaction transaction,
      ) {
    Navigator.of(context).pushNamed(
      TransactionDetailView.routeName,
      arguments: TransactionDetailViewArguments(
        transaction: transaction,
      ),
    );
  }
}
