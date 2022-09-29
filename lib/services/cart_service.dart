import 'dart:convert';

import 'package:store/application.properties/app_properties.dart';
import 'package:http/http.dart' as http;
//todo make static with getit?
class CartService {
  //todo might

  CartService();



   Map<String, String> headers = {'Content-Type': 'application/json'};

  Future saveCart(
    String productId,
    String userId,
    String quantity,
    String jwtToken,
  ) async {
    var bodyObject = <String, String>{};
    bodyObject.putIfAbsent('productId', () => productId);
    bodyObject.putIfAbsent('userId', () => userId);
    bodyObject.putIfAbsent('quantity', () => quantity);

    headers.putIfAbsent('Authorization', () => 'Bearer $jwtToken');

    return await http.post(
      Uri.parse(AppProperties.cartUrl),
      body: json.encode(bodyObject),
      headers: headers,
    );
  }

  Future getCart(
    String userId,
    String jwtToken,
  ) async {
    headers.putIfAbsent('Authorization', () => 'Bearer $jwtToken');
    return await http.get(
      Uri.parse('${AppProperties.cartUrl}/$userId'),
      headers: headers,
    );
  }

  Future deleteCart(
    String userId,
  ) async {
    return await http.delete(Uri.parse('${AppProperties.cartUrl}/$userId'));
  }
}
