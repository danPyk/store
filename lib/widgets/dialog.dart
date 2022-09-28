import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class CDialog {
  late ProgressDialog dialog;

  CDialog(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: false,
      showLogs: false,
    );
    pr.style(
      message: 'Please wait...',
    );
    dialog = pr;
  }
}
