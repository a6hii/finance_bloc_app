import 'package:flutter/material.dart';
import 'package:finance_management/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Reset Password",
    content:
        "A link for resetting your password has been sent to your email account.",
    optionsBuilder: () => {
      "Ok": null,
    },
  );
}
