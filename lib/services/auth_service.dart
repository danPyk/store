import 'dart:convert';

import 'package:store/application.properties/app_properties.dart';
import 'package:store/models/authdata.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@singleton
class AuthService {
  AuthService({required this.httpClient});

  final http.Client httpClient;

  @disposeMethod
  //todo LATER every servic dispos?
  void dispose() {
    // logic to dispose instance
  }

  Map<String, String> headers = {'Content-Type': 'application/json'};

  Future emailNameAndPasswordSignUp(
    String name,
    String email,
    String password,
  ) async {
    var authData = AuthData(name: name, email: email, password: password);
    Uri uri = Uri.parse(AppProperties.signUpUrl);
    return await http.post(
      uri,
      body: json.encode(authData.toJson()),
      headers: headers,
    );
  }

  Future emailAndPasswordSignIn(
    String email,
    String password,
  ) async {
    var authData = AuthData(name: '', email: email, password: password);
    Uri uri = Uri.parse(AppProperties.signInUrl);

    return await http.post(
      uri,
      body: json.encode(authData.toJson()),
      headers: headers,
    );
  }

  Future checkTokenExpiry(String token) async {
    var tokenObject = <String, String>{};
    tokenObject.putIfAbsent('token', () => token);

    return await http.post(
      Uri.parse(AppProperties.checkTokenExpiryUrl),
      body: json.encode(tokenObject),
      headers: headers,
    );
  }
//todo TOKEN deleted parameter
  Future changeName(String newName, String oldName) async {
    //todo
    //  headers.putIfAbsent('Authorization', () => 'Bearer $jwtToken');
    Map<String, String> map = {'name': newName};
    String url = '${AppProperties.changenameUrl}$oldName';

    return await http.patch(
      Uri.parse(url),
      headers: headers,
      body: json.encode(map),
    );
  }
//todo token deleted
  Future changeEmail(String newEmail, String oldEmail) async {
    //TODO TOKEN
    //headers.putIfAbsent('Authorization', () => 'Bearer $jwtToken');
    Map<String, String> bodyObject  = {'email' : newEmail};

    return await http.patch(
      Uri.parse('${AppProperties.changeMailUrl}$oldEmail'),
      headers: headers,
      body: json.encode(bodyObject),
    );
  }

  Future forgotPassword(String email) async {
    Map<String, String> bodyObject  = {'email' : email};
    return await http.patch(
      Uri.parse(AppProperties.forgotPasswordUrl),
      headers: headers,
      body: json.encode(bodyObject),
    );
  }

  Future changePassword(String token, String email) async {
    //TODO TOKEN
    //headers.putIfAbsent('Authorization', () => 'Bearer $jwtToken');
    final bodyObject  = {'token': token, 'email' : email};



    return await http.patch(
      Uri.parse(AppProperties.resetPasswordUrl),
      headers: headers,
      body: json.encode(bodyObject),
    );
  }

}
