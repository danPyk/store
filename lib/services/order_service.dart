import 'package:injectable/injectable.dart';
import 'package:store/application.properties/app_properties.dart';
import 'package:http/http.dart' as http;

@injectable
class OrderService {
  OrderService({required this.httpClient});

  Map<String, String> headers = {'Content-Type': 'application/json'};

  final http.Client httpClient ;

  Future getShippingCost(String country) async {
    //can be used to fetch shipping cost for a particular place from API.
    return 0;
  }

  Future getTax(String country) async {
    //can be used to fetch tax for a particular place from API.
    return 100;
  }

  //used to save order details after making stripe payment
  Future<http.Response> saveOrder(String order) async {

    return await httpClient.post(Uri.parse(AppProperties.saveOrderUrl),
        body: order, headers: headers);
  }

  //used to send order details along with paypal nonce to process payment and save the order
  Future<http.Response> sendPayPalRequest(String order, String nonce) async {
    return await httpClient.post(
        Uri.parse('${AppProperties.payPalRequestUrl}$nonce'),
        body: order,
        headers: headers);
  }

  Future<http.Response> getOrders(String id, String jwtToken) async {
    //todo auth
   // headers.putIfAbsent('Authorization', () => 'Bearer $jwtToken');
    return await httpClient.get(
        Uri.parse('${AppProperties.getOrdersUrl}$id''/'),
    headers: headers);
  }
}
