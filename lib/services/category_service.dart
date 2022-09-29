import 'package:store/application.properties/app_properties.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  CategoryService();

  static var httpClient = http.Client();

  Future getCategories() async {
    return await httpClient.get(Uri.parse(AppProperties.categoryUrl));
  }
}
