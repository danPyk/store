import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:store/controllers/error_controller.dart';
import 'package:store/injection.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//todo add validation if user exist

@injectable
class AuthController {
  final _storage = const FlutterSecureStorage();
  final AuthService _authService;

  AuthController(this._authService);

  Future<void> saveUserDataAndLoginStatus(
    String userId,
    String isLoggedFlag,
    String jwt,
    String email,
    String name,
  ) async {
    await _storage.write(key: 'UserId', value: userId);
    await _storage.write(key: 'IsLoggedFlag', value: isLoggedFlag);
    await _storage.write(key: 'jwt', value: jwt);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'name', value: name);
  }

  Future<List<String?>> getUserDataAndLoginStatus() async {
    String? userId = await _storage.read(key: 'UserId');
    String? isLoggedFlag = await _storage.read(key: 'IsLoggedFlag');
    String? token = await _storage.read(key: 'jwt');
    String? email = await _storage.read(key: 'email');
    String? name = await _storage.read(key: 'name');
    return [userId, isLoggedFlag, token, email, name];
  }

  Future<void> deleteUserDataAndLoginStatus() async {
    await _storage.deleteAll();
  }

  Future<bool> emailNameAndPasswordSignUp(
    String name,
    String email,
    String password,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    try {
      var response =
          await _authService.emailNameAndPasswordSignUp(name, email, password);
//todo change to 201
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var token = jsonResponse['token'];
        var userId = jsonResponse['user']['id'];
        var email = jsonResponse['user']['email'];
        var name = jsonResponse['user']['name'];

        String userIdParsed = userId;

        await saveUserDataAndLoginStatus(userIdParsed, '1', token, email, name);
        return true;
      } else {
        ErrorController.showErrorFromApi(scaffoldKey, response);
        return false;
      }
    } on SocketException catch (_) {
      ErrorController.showNoInternetError(scaffoldKey);
      return false;
    } on HttpException catch (_) {
      ErrorController.showNoServerError(scaffoldKey);
      return false;
    } on FormatException catch (_) {
      ErrorController.showFormatExceptionError(scaffoldKey);
      return false;
    } catch (e) {
      print("Error ${e.toString()}");
      ErrorController.showUnKownError(scaffoldKey);
      return false;
    }
  }

  Future<bool> emailAndPasswordSignIn(
    String email,
    String password,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    try {
      var response = await _authService.emailAndPasswordSignIn(email, password);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var token = jsonResponse['token'];
        var userId = jsonResponse['user']['id'];
        var email = jsonResponse['user']['email'];
        var name = jsonResponse['user']['name'];

        String userIdParsed = userId;

        await saveUserDataAndLoginStatus(userIdParsed, '1', token, email, name);
        return true;
      } else {
        ErrorController.showErrorFromApi(scaffoldKey, response);
        return false;
      }
    } on SocketException catch (_) {
      ErrorController.showNoInternetError(scaffoldKey);
      return false;
    } on HttpException catch (_) {
      ErrorController.showNoServerError(scaffoldKey);
      return false;
    } on FormatException catch (_) {
      ErrorController.showFormatExceptionError(scaffoldKey);
      return false;
    } catch (e) {
      print("Error ${e.toString()}");
      ErrorController.showUnKownError(scaffoldKey);
      return false;
    }
  }

  Future<bool> isTokenValid() async {
    String? token = await _storage.read(key: 'jwt');

    if (token == null) {
      return false;
    } else {
      return true;
    }

    //todo TOKEN
    // var response = await _authService.checkTokenExpiry(token);
    //
    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Future<bool> changeName(
      String name, GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      var data = await getUserDataAndLoginStatus();

      var response = await _authService.changeName(name, data[0]!, data[2]!);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        await _storage.write(key: 'name', value: responseBody['data']['name']);

        return true;
      } else {
        ErrorController.showErrorFromApi(scaffoldKey, response);
        return false;
      }
    } on SocketException catch (_) {
      ErrorController.showNoInternetError(scaffoldKey);
      return false;
    } on HttpException catch (_) {
      ErrorController.showNoServerError(scaffoldKey);
      return false;
    } on FormatException catch (_) {
      ErrorController.showFormatExceptionError(scaffoldKey);
      return false;
    } catch (e) {
      print("Error ${e.toString()}");
      ErrorController.showUnKownError(scaffoldKey);
      return false;
    }
  }

  Future<bool> changeEmail(
      String email, GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      var data = await getUserDataAndLoginStatus();

      var response = await _authService.changeEmail(email, data[0]!, data[2]!);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        await _storage.write(
            key: 'email', value: responseBody['data']['email']);
        return true;
      } else {
        ErrorController.showErrorFromApi(scaffoldKey, response);
        return false;
      }
    } on SocketException catch (_) {
      ErrorController.showNoInternetError(scaffoldKey);
      return false;
    } on HttpException catch (_) {
      ErrorController.showNoServerError(scaffoldKey);
      return false;
    } on FormatException catch (_) {
      ErrorController.showFormatExceptionError(scaffoldKey);
      return false;
    } catch (e) {
      print("Error ${e.toString()}");
      ErrorController.showUnKownError(scaffoldKey);
      return false;
    }
  }

  Future<bool> forgotPassword(
      String email, GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      var response = await _authService.forgotPassword(email);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        GlobalSnackBar.showSnackbar(
          scaffoldKey,
          responseBody['message'],
          SnackBarType.Success,
        );

        return true;
      } else {
        ErrorController.showErrorFromApi(scaffoldKey, response);
        return false;
      }
    } on SocketException catch (_) {
      ErrorController.showNoInternetError(scaffoldKey);
      return false;
    } on HttpException catch (_) {
      ErrorController.showNoServerError(scaffoldKey);
      return false;
    } on FormatException catch (_) {
      ErrorController.showFormatExceptionError(scaffoldKey);
      return false;
    } catch (e) {
      print("Error ${e.toString()}");
      ErrorController.showUnKownError(scaffoldKey);
      return false;
    }
  }
}
