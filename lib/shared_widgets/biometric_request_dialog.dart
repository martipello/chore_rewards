import 'package:flutter/material.dart';

import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import 'chores_app_dialog.dart';

class BiometricRequestDialog extends StatelessWidget {
  const BiometricRequestDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoresAppDialog(
      title: 'Welcome',
      content: Column(
        children: [
          SizedBox(
            height: 24,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: colors(context).positive),
              borderRadius: BorderRadius.circular(90.0),
            ),
            child: Icon(
              Icons.fingerprint_rounded,
              color: colors(context).positive,
              size: 96,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Use biometrics for fast login?',
              style: ChoresAppText.body3Style,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      dialogActions: [
        DialogAction(
          actionVoidCallback: () => Navigator.of(context).pop(true),
          actionText: 'No Thanks.',
        ),
        DialogAction(
          actionVoidCallback: () => Navigator.of(context).pop(true),
          actionText: 'OK',
        ),
      ],
    );
  }
}
