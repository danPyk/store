import 'package:injectable/injectable.dart';
import 'package:store/application.properties/app_properties.dart';
import 'package:http/http.dart' as http;

@injectable
class CategoryService {

  CategoryService({required this.httpClient});

  //todo http
  final http.Client httpClient ;

  Future<http.Response> getCategories() async {
    return await httpClient.get(Uri.parse(AppProperties.categoryUrl));
  }
}
