import 'package:flutter/material.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../family_member/family_member_picker.dart';
import '../models/family_member.dart';
import '../models/transaction.dart' as t;
import '../shared_widgets/rounded_button.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../view_models/piggy_bank_view_model.dart';

class SpendBankDialog extends StatefulWidget {
  SpendBankDialog({
    Key? key,
    required this.familyMember,
    required this.familyId,
  }) : super(key: key);

  final FamilyMember familyMember;
  final String familyId;

  static Future<bool?> show(
    BuildContext context,
    FamilyMember familyMember,
    String familyId,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SpendBankDialog(
          familyMember: familyMember,
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
  _SpendBankDialogState createState() => _SpendBankDialogState();
}

class _SpendBankDialogState extends State<SpendBankDialog> {
  final _piggyBankViewModel = getIt.get<PiggyBankViewModel>();
  final _titleTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _piggyBankViewModel.rewardResult.listen(
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
    _titleTextController.addListener(() {
      _piggyBankViewModel.setTitle(_titleTextController.text);
    });
  }

  @override
  void dispose() {
    _piggyBankViewModel.dispose();
    _titleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAcceptChoreContent(context);
  }

  Widget _buildAcceptChoreContent(BuildContext context) {
    return StreamBuilder<ApiResponse>(
      stream: _piggyBankViewModel.rewardResult,
      builder: (context, snapshot) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 36,
              ),
              if (snapshot.data?.status != Status.COMPLETED) _buildGiveRewardTitle(context),
              if (snapshot.data?.status == Status.COMPLETED) _buildRewardSent(),
              if (snapshot.data?.status != Status.COMPLETED)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'hint: this will deduct reward points from your chosen family member.',
                          style: ChoresAppText.captionStyle,
                        ),
                        _buildRewardEditTitle(context),
                        SizedBox(
                          height: 16,
                        ),
                        FamilyMemberPicker(
                          familyId: widget.familyId,
                          formKey: _formKey,
                          selectedFamilyMember: _piggyBankViewModel.setPayee,
                          canSelectAllMembers: false,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        _buildRewardCounter(),
                        if (snapshot.data?.status != Status.COMPLETED)
                          _buildButtonBar(context, snapshot.data?.status == Status.LOADING),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardEditTitle(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Title',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
      controller: _titleTextController,
    );
  }

  Widget _buildRewardCounter() {
    return StreamBuilder<t.Transaction>(
      stream: _piggyBankViewModel.createTransactionStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Spend reward amount',
              style: ChoresAppText.body1Style,
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _piggyBankViewModel.minusChoreReward,
                  backgroundColor: colors(context).primary,
                  child: Icon(
                    Icons.remove,
                    color: colors(context).textOnPrimary,
                  ),
                ),
                Text(
                  '${snapshot.data?.reward?.toInt() ?? 0}',
                  style: ChoresAppText.subtitle2Style,
                ),
                FloatingActionButton(
                  onPressed: _piggyBankViewModel.addChoreReward,
                  backgroundColor: colors(context).primary,
                  child: Icon(
                    Icons.add,
                    color: colors(context).textOnPrimary,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Column _buildGiveRewardTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Spend Reward',
            style: ChoresAppText.subtitle1Style.copyWith(height: 1),
          ),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Widget _buildRewardSent() {
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
          'Reward Sent',
          style: ChoresAppText.subtitle1Style,
        )
      ],
    );
  }

  Widget _buildButtonBar(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Row(
        children: [
          _buildMediumMargin(),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 32),
              child: _buildConfirmButton(
                context,
                'SPEND',
                isLoading,
                () {
                  if (_formKey.currentState!.validate()) {
                    _piggyBankViewModel.addSpendTransaction(widget.familyId, widget.familyMember);
                  }
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
                'BACK',
                () {
                  Navigator.of(context).pop(false);
                },
              ),
            ),
          ),
          _buildMediumMargin(),
        ],
      ),
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
      fillColor: colors(context).secondary,
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
      fillColor: colors(context).error,
      isFilled: true,
      onPressed: onPressed,
    );
  }
}
