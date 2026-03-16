import 'package:flutter/material.dart';
import 'package:go/core/constants/color_manager.dart';
import 'package:go/core/constants/string_manager.dart';

class RememberMeAndForgotPassRow extends StatelessWidget {
  final bool rememberMeValue;
  final Function(bool?) checkBoxOnPressed;
  final Function() forgotPassOnPressed;
  const RememberMeAndForgotPassRow({
    super.key,
    required this.rememberMeValue,
    required this.checkBoxOnPressed,
    required this.forgotPassOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          value: rememberMeValue,
          onChanged: (value) => checkBoxOnPressed(value),
          activeColor: ColorManager.primaryColor,
        ),
        Text(StringManager.rememberMe),
        Spacer(),
        TextButton(
          onPressed: forgotPassOnPressed,
          child: Text('${StringManager.forgotPassword}?'),
        ),
      ],
    );
  }
}

class RegisterRow extends StatelessWidget {
  final VoidCallback? onPressed;
  const RegisterRow({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(StringManager.dontHaveAccount),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
          onPressed: onPressed,
          child: Text(StringManager.signUp),
        ),
      ],
    );
  }
}
