import 'package:store/application.properties/app_properties.dart';
import 'package:http/http.dart' as http;
import 'package:store/constants/error/excpetions.dart';

class ProductService {

  ProductService() ;


  static var httpClient = http.Client();
//todo fullfill status codes
  Future<http.Response> getAllProducts() async {
    http.Response result =  await   http.get(Uri.parse(AppProperties.productUrl));
    if(result.statusCode == 200){

      return result;

    }else{
    throw ServerException();
    }

  }

  Future getProductByCategoryOrName(String value) async {
    return await http.get(Uri.parse('${AppProperties.searchByCategoryOrNameUrl}$value'));
  }

  Future getProductByCategory(String value) async {
    return await http.get(Uri.parse('${AppProperties.searchByCategoryUrl}$value'));
  }

  Future getProductById(String id) async {
    return await http.get(Uri.parse('${AppProperties.productUrl}$id'));
  }
}
