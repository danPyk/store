import 'dart:io';

import 'package:http/http.dart';
import 'package:store/controllers/error_controller.dart';
import 'package:store/services/category_service.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';


class CategoryController extends ChangeNotifier {
  final _categoryService = CategoryService();

  var _isLoadingCategories = true;

  List<CategoryModel> _categoryList = [];

  List<CategoryModel> get categoryList => _categoryList;

  bool get isLoadingCategories => _isLoadingCategories;

  setIsLoadingCategories(bool value) {
    _isLoadingCategories = value;
    notifyListeners();
  }

  void getAllCategories(GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      _isLoadingCategories = true;
      //important when refresh indicator is called
      //to avoid add same items
      _categoryList.clear();

      Response response = await _categoryService.getCategories();

      print(response.body);
      if (response.statusCode == 200) {
        List<String> splitedResponse = response.body.split(',') ;
        _categoryList =  createList(splitedResponse);

        _isLoadingCategories = false;
        notifyListeners();
      } else {
        ErrorController.showErrorFromApi(scaffoldKey, response);
      }
    } on SocketException catch (_) {
      ErrorController.showNoInternetError(scaffoldKey);
    } on HttpException catch (_) {
      ErrorController.showNoServerError(scaffoldKey);
    } on FormatException catch (_) {
      ErrorController.showFormatExceptionError(scaffoldKey);
    } catch (e) {
      print("Error ${e.toString()}");
      ErrorController.showUnKownError(scaffoldKey);
    }
  }
}
