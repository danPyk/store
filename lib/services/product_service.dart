import 'package:store/application.properties/app_properties.dart';
import 'package:http/http.dart' as http;
import 'package:store/constants/error/excpetions.dart';

class ProductService {
  ProductService();

  static var httpClient = http.Client();

//todo fullfill status codes
  Future<http.Response> getAllProducts() async {
    http.Response result = await http.get(Uri.parse(AppProperties.productUrl));
    if (result.statusCode == 200) {
      return result;
    } else {
      throw ServerException();
    }
  }

  Future<http.Response> getProductByCategoryOrName(String value) async {
    return await http
        .get(Uri.parse('${AppProperties.searchByCategoryOrNameUrl}$value'));
  }

  Future<http.Response> getProductByCategory(String value) async {
    if(value.contains(' ')){
      value = value.replaceAll(' ', '+');
    }
    var result = value.trim();
    return await http
        .get(  Uri.parse('${AppProperties.searchByCategoryUrl}$result/'));
  }

  Future<http.Response> getProductById(String id) async {
    return await http.get(Uri.parse('${AppProperties.productUrl}$id'));
  }
}
