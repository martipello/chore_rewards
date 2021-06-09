import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../view_models/chore/chore_view_model.dart';

class TransactionDetailViewArguments {
  TransactionDetailViewArguments({
    required this.transaction,
  });

  final Transaction transaction;
}

class TransactionDetailView extends StatefulWidget {
  static const routeName = '/families/transactions/details';

  @override
  _TransactionDetailViewState createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  final _choreViewModel = getIt.get<ChoreViewModel>();

  @override
  void dispose() {
    _choreViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as TransactionDetailViewArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments.transaction.title?.capitalize() ?? 'Family Member'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: _buildWave(context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(arguments.transaction),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: _buildTransactionInformationTable(context, arguments.transaction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Transaction transaction) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 36,
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors(context).textOnPrimary,
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
        SizedBox(
          height: 24,
        ),
      ],
    );
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

  Widget _buildTransactionInformationTable(BuildContext context, Transaction transaction) {
    final id = transaction.id?.capitalize() ?? '';
    final title = transaction.title?.capitalize() ?? '';
    final addedDate = _buildDateTime(transaction.date);
    final reward = '${_getTransactionType(transaction)} ${transaction.reward?.toString()}';
    final from = transaction.from?.name ?? '';
    final to = transaction.to?.name ?? '';

    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: FlexColumnWidth(1),
      },
      children: [
        if (id.isNotEmpty)
          _buildTableRow(
            context,
            title,
            'ID :',
            Icons.title,
          ),
        if (title.isNotEmpty)
          _buildTableRow(
            context,
            title,
            'Title :',
            Icons.title,
          ),
        if (from.isNotEmpty)
          _buildTableRow(
            context,
            from,
            'From :',
            Icons.person,
          ),
        if (to.isNotEmpty)
          _buildTableRow(
            context,
            to,
            'To :',
            Icons.person,
          ),
        if (reward.isNotEmpty)
          _buildTableRow(
            context,
            '$reward',
            'Reward :',
            Icons.star,
          ),
        if (addedDate.isNotEmpty)
          _buildTableRow(
            context,
            addedDate,
            'Added :',
            Icons.today,
          ),
      ],
    );
  }

  TableRow _buildTableRow(
    BuildContext context,
    String label,
    String? iconLabel,
    IconData icon, {
    VoidCallback? onPressed,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 21.0, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: colors(context).textOnForeground,
                size: 20,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 8),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  iconLabel?.trim() ?? '',
                  style: ChoresAppText.body1Style,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onPressed,
                  child: Text(
                    label,
                    style: onPressed != null
                        ? ChoresAppText.body1Style.copyWith(
                            color: colors(context).link,
                          )
                        : ChoresAppText.body1Style,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buildDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return '';
  }

  Widget _buildWave(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        colors: [
          Colors.white70,
          Colors.white54,
          Colors.white30,
          Colors.white24,
        ],
        durations: [32000, 21000, 18000, 5000],
        heightPercentages: [0.52, 0.53, 0.55, 0.58],
        // blur: _blurs[3],
      ),
      backgroundColor: colors(context).primary,
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 0,
    );
  }
}
