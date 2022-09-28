import 'package:flutter/material.dart';

enum SnackBarType { Error, Success }

class GlobalSnackBar {
  static showSnackbar(
      ///todo
      GlobalKey<ScaffoldState> scaffoldKey, String message, SnackBarType type) {
    scaffoldKey.currentState?.showBottomSheet((context) => const Text('poor bar') );
  }
}
