import 'package:flutter/material.dart';

import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.onPressed,
    this.fillColor,
    this.isLoading = false,
    this.isFilled = true,
    this.disableShadow = false,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.outlineColor,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Color? fillColor;
  final Color? outlineColor;
  final bool isLoading;
  final bool isFilled;
  final bool disableShadow;
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: TextButton(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(ChoresAppText.body4Style),
            elevation: MaterialStateProperty.all(onPressed != null && !disableShadow ? 2 : 0),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
            backgroundColor: MaterialStateProperty.all(_getFillColor(context)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color: _getOutlineColor(context),
              ),
            ),
          ),
          onPressed: _handleOnPressed(),
          child: Builder(
            builder: (context) {
              if (isLoading) return _buildLoading(context);
              return _buildButtonContent(context);
            },
          )),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    final textStyle = _getTextStyle(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null)
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                leadingIcon,
                color: textStyle.color,
                size: textStyle.fontSize! + 4,
              ),
            ),
          Flexible(
            child: Text(
              label,
              style: textStyle,
            ),
          ),
          if (trailingIcon != null)
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                trailingIcon,
                color: textStyle.color,
                size: textStyle.fontSize! + 2,
              ),
            ),
        ],
      ),
    );
  }

  Color _getFillColor(BuildContext context) {
    if (isFilled && onPressed != null) {
      return fillColor ?? colors(context).secondary;
    } else if (!isFilled && onPressed == null) {
      return Colors.white;
    } else if (!isFilled && onPressed != null) {
      return Colors.white;
    } else {
      return colors(context).foreground;
    }
  }

  Color _getOutlineColor(BuildContext context) {
    if (onPressed != null) {
      return outlineColor ?? colors(context).secondary;
    } else {
      return colors(context).foreground;
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (isFilled && onPressed != null) {
      return ChoresAppText.subtitle4Style.copyWith(color: colors(context).textOnSecondary);
    } else if (!isFilled && onPressed != null) {
      return ChoresAppText.subtitle4Style.copyWith(color: colors(context).secondary);
    } else if (isFilled && onPressed == null) {
      return ChoresAppText.subtitle4Style.copyWith(color: colors(context).chromeDark);
    } else {
      return ChoresAppText.subtitle4Style.copyWith(color: colors(context).foreground);
    }
  }

  Widget _buildLoading(BuildContext context) {
    return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(isFilled ? colors(context).textOnSecondary : colors(context).secondary),
        ));
  }

  VoidCallback? _handleOnPressed() {
    if (!isLoading) {
      return onPressed;
    } else {
      return null;
    }
  }
}
