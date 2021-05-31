import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared_widgets/chores_app_dialog.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

class ForgotPasswordSuccessDialog extends StatelessWidget {
  const ForgotPasswordSuccessDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoresAppDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
          ),
          Icon(
            Icons.check_circle_outline,
            color: colors(context).positive,
            size: 96,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Success',
            style: ChoresAppText.subtitle4Style,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Click the link we sent to reset your password',
            style: ChoresAppText.body3Style,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      dialogActions: [
        DialogAction(
            actionText: 'OK',
            actionVoidCallback: () {
              Navigator.of(context).pop(true);
            })
      ],
    );
  }
}
