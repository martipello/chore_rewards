import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
    required TextEditingController emailEditingController,
  })   : _emailEditingController = emailEditingController,
        super(key: key);

  final TextEditingController _emailEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      style: ChoresAppText.body4Style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: 'Email',
        suffixIcon: Icon(
          Icons.email_outlined,
          color: colors(context).textOnForeground,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid email...';
        }
        return null;
      },
      controller: _emailEditingController,
    );
  }
}
