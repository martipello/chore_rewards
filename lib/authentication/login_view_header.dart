import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

class LoginViewHeader extends StatelessWidget {
  LoginViewHeader({this.addTopMargin = true});
  final bool addTopMargin;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (addTopMargin) SizedBox(height: 120),
        Image.asset(
          'assets/images/chores_app.png',
          height: 160,
          width: 160,
        ),
        SizedBox(height: 16),
        Text(
          'ChoreRewards',
          textAlign: TextAlign.center,
          style: ChoresAppText.h4Style.copyWith(color: colors(context).primary),
        ),
      ],
    );
  }
}
