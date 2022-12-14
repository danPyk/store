import 'dart:convert';

import 'package:store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';

class ErrorController {
  static showErrorFromApi(GlobalKey<ScaffoldState> scaffoldKey, var response) {
    var resBody = json.decode(response.body);
    String message = ErrorController()._formatErrorFromApi(resBody['message']);
    ErrorController()._showErrorSnackbar(scaffoldKey, message);
  }

  static showNoInternetError(GlobalKey<ScaffoldState> scaffoldKey) {
    ErrorController()._showErrorSnackbar(scaffoldKey, 'No internet connection');
  }

  static showNoServerError(GlobalKey<ScaffoldState> scaffoldKey) {
    ErrorController()._showErrorSnackbar(scaffoldKey, 'Failed to reach server');
  }

  static showFormatExceptionError(
    GlobalKey<ScaffoldState> scaffoldKey,
  ) {
    ErrorController()._showErrorSnackbar(scaffoldKey, 'Bad format error');
  }

  static showUnKownError(GlobalKey<ScaffoldState> scaffoldKey) {
    ErrorController()._showErrorSnackbar(scaffoldKey, 'Unknown error');
  }

  static showCustomError(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    ErrorController()._showErrorSnackbar(scaffoldKey, message);
  }

  _showErrorSnackbar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    GlobalSnackBar.showSnackbar(scaffoldKey, message, SnackBarType.Error);
  }

  _formatErrorFromApi(String message) {
    switch (message) {
      case 'Jwt token is invalid':
        return message = 'Authentication failed';
        break;
      default:
        return message;
    }
  }
}
