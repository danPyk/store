import 'dart:convert';

import 'package:store/application.properties/app_properties.dart';
import 'package:store/models/authdata.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@singleton
class AuthService {

  AuthService({required this.httpClient});
  //todo

     final http.Client httpClient;

  @disposeMethod
  //todo LATER every servic dispos?
  void dispose(){

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

  Future changeName(String name, String userId, String jwtToken) async {
    //todo
  //  headers.putIfAbsent('Authorization', () => 'Bearer $jwtToken');
    var bodyObject = <String, String>{};
  Map<String, dynamic> map = {'name' : name};
    String url = '${AppProperties.changenameUrl}$userId''/';

    return await http.patch(
      Uri.parse(url),
      headers: headers,
      body: json.encode(map),
    );
  }

  Future changeEmail(String email, String userId, String jwtToken) async {
    headers.putIfAbsent('Authorization', () => 'Bearer $jwtToken');
    var bodyObject = <String, String>{};
    bodyObject.putIfAbsent('email', () => email);

    return await http.patch(
      Uri.parse('${AppProperties.changeMailUrl}$userId'),
      headers: headers,
      body: json.encode(bodyObject),
    );
  }

  Future forgotPassword(String email) async {
    var bodyObject = <String, String>{};
    bodyObject.putIfAbsent('email', () => email);
    return await http.post(
      Uri.parse(AppProperties.forgotPasswordUrl),
      headers: headers,
      body: json.encode(bodyObject),
    );
  }
}
