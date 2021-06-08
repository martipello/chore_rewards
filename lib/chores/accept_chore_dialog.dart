import 'package:flutter/material.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../models/chore.dart';
import '../shared_widgets/rounded_button.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../view_models/chore/chore_view_model.dart';

class AcceptChoreDialog extends StatefulWidget {
  AcceptChoreDialog({
    Key? key,
    required this.chore,
    required this.familyId,
  }) : super(key: key);

  final Chore chore;
  final String familyId;

  static Future<bool?> show(BuildContext context, Chore chore, String familyId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return AcceptChoreDialog(
          chore: chore,
          familyId: familyId,
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  @override
  _AcceptChoreDialogState createState() => _AcceptChoreDialogState();
}

class _AcceptChoreDialogState extends State<AcceptChoreDialog> {
  final _choreViewModel = getIt.get<ChoreViewModel>();

  @override
  void initState() {
    super.initState();
    _choreViewModel.acceptChoreResult.listen(
      (value) {
        if (value.status == Status.COMPLETED) {
          Future.delayed(Duration(seconds: 1)).then(
            (value) {
              if (mounted) {
                Navigator.of(context).pop(true);
              }
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _choreViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAcceptBookingContent(context);
  }

  Widget _buildAcceptBookingContent(BuildContext context) {
    return StreamBuilder<ApiResponse>(
        stream: _choreViewModel.acceptChoreResult,
        builder: (context, snapshot) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 36,
                ),
                if (snapshot.data?.status != Status.COMPLETED) _buildAcceptedChoreTitle(context),
                if (snapshot.data?.status == Status.COMPLETED) _buildAcceptedChore(),
                if (snapshot.data?.status != Status.COMPLETED) _buildConfirmChoreText(context),
                SizedBox(
                  height: 32,
                ),
                // if (snapshot.data?.status == Status.ERROR) _buildErrorWidget(snapshot.data?.error),
                if (snapshot.data?.status != Status.COMPLETED)
                  _buildButtonBar(context, snapshot.data?.status == Status.LOADING),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          );
        });
  }

  Padding _buildConfirmChoreText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        'Are you sure you want to accept this chore?',
        style: ChoresAppText.body4Style.copyWith(height: 1),
      ),
    );
  }

  Column _buildAcceptedChoreTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text('Accept Chore', style: ChoresAppText.subtitle1Style.copyWith(height: 1)),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Widget _buildAcceptedChore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline_outlined,
          size: 96,
          color: colors(context).positive,
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Chore Accepted',
          style: ChoresAppText.subtitle1Style,
        )
      ],
    );
  }

  Widget _buildButtonBar(BuildContext context, bool isLoading) {
    return Row(
      children: [
        _buildMediumMargin(),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 32),
            child: _buildConfirmButton(
              context,
              'ACCEPT',
              isLoading,
              () {
                _choreViewModel.acceptChore(widget.chore, widget.familyId);
              },
            ),
          ),
        ),
        _buildMediumMargin(),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 32),
            child: _buildDeclineButton(
              context,
              'CANCEL',
              () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
        ),
        _buildMediumMargin(),
      ],
    );
  }

  Widget _buildMediumMargin() {
    return SizedBox(
      width: 16,
    );
  }

  Widget _buildConfirmButton(
    BuildContext context,
    String label,
    bool isLoading,
    VoidCallback onPressed,
  ) {
    return RoundedButton(
      label: label,
      textStyle: ChoresAppText.body3Style,
      fillColor: colors(context).primary,
      isLoading: isLoading,
      isFilled: true,
      onPressed: onPressed,
    );
  }

  Widget _buildDeclineButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
  ) {
    return RoundedButton(
      label: label,
      textStyle: ChoresAppText.body3Style,
      fillColor: colors(context).chrome,
      isFilled: true,
      onPressed: onPressed,
    );
  }
}
