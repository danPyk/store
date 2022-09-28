import 'package:store/application.properties/app_properties.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  static late CategoryService? _categoryService;

  CategoryService._internal() {
    _categoryService = this;
  }

  factory CategoryService() => _categoryService ?? CategoryService._internal();

  static var httpClient = http.Client();

  Future getCategories() async {
    return await httpClient.get(Uri.parse(AppProperties.categoryUrl
    ));
  }
}
