import 'package:flutter/material.dart';

enum SnackBarType { Error, Success }

class GlobalSnackBar {
  static showSnackbar(
      ///todo IS THIS GOOD>? ITS STATIC. DELETE SOME OTHER STATIC VARS
      GlobalKey<ScaffoldState> scaffoldKey, String message, SnackBarType type) {
    scaffoldKey.currentState?.showBottomSheet((context) => const Text('poor bar') );
  }
}
