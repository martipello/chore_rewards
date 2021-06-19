import 'package:flutter/material.dart';

import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

class ChoresAppDialog extends StatelessWidget {
  const ChoresAppDialog({
    this.title,
    required this.content,
    required this.dialogActions,
  });

  final String? title;
  final Widget content;
  final List<DialogAction> dialogActions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: colors(context).primary,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          title!,
                          style: ChoresAppText.subtitle1Style.copyWith(
                            color: colors(context).textOnPrimary,
                          ),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 4,
                  ),
                  child: IconButton(
                    splashRadius: 12,
                    icon: Icon(
                      Icons.close,
                      color: colors(context).textOnPrimary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: content,
          ),
          SizedBox(
            height: 24,
          ),
          _buildPickerButtons(context),
        ],
      ),
    );
  }

  Widget _buildPickerButtons(BuildContext context) {
    final actions = _getActions(context);
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, bottom: 4.0),
        child: Wrap(
          spacing: actions.length > 2 ? 0 : 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.end,
          alignment: WrapAlignment.end,
          direction: actions.length > 2 ? Axis.vertical : Axis.horizontal,
          verticalDirection: VerticalDirection.up,
          children: actions,
        ),
      ),
    );
  }

  List<Widget> _getActions(BuildContext context) {
    return dialogActions.map((action) => _buildDialogAction(action, context)).toList();
  }

  Widget _buildDialogAction(DialogAction action, BuildContext context) {
    return TextButton(
      onPressed: action.actionVoidCallback,
      child: Text(
        action.actionText,
        style: ChoresAppText.body3Style.copyWith(
          color: colors(context).primary,
        ),
        textAlign: TextAlign.end,
      ),
    );
  }
}

class DialogAction {
  DialogAction({
    required this.actionText,
    required this.actionVoidCallback,
  });

  final String actionText;
  final VoidCallback actionVoidCallback;
}
