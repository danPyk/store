import 'dart:io';

import 'package:http/http.dart';
import 'package:store/controllers/error_controller.dart';
import 'package:store/injection.dart';
import 'package:store/models/product.dart';
import 'package:store/services/product_service.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class ProductController extends ChangeNotifier {
  final _productService = getIt.call<ProductService>();

  List<Product> _productList = [];

  bool _isLoadingAllProducts = true;

  bool get isLoadingAllProducts => _isLoadingAllProducts;

  setIsLoadingAllProducts(bool value) {
    _isLoadingAllProducts = value;
    notifyListeners();
  }

//todo buildcontext is passed i guess
  void getAllProducts(GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      _isLoadingAllProducts = true;

      //important when refresh indicator is called
      //to avoid add same items
      _productList.clear();

      var response = await _productService.getAllProducts();

      if (response.statusCode == 200) {
        var responseJsonStr = json.decode(response.body);

        _productList = productFromJson(responseJsonStr);
        _isLoadingAllProducts = false;

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

  List<Product> get productList => _productList;

  void getProductByCategory(
      String value, GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      _isLoadingAllProducts = true;

      Response response = await _productService.getProductByCategory(value);

      if (response.statusCode == 200) {
        var responseJsonStr = json.decode(response.body);

        _productList.clear();
        _productList = (productFromJson(responseJsonStr));
        _isLoadingAllProducts = false;

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

//todo LATER efery digit type makes below func call
//   Future<void> getProductByCategoryOrName(String value) async {
//     var finalSearchValue = value.trim();
//     try {
//       _isLoadingAllProducts = true;
//
//       var response = finalSearchValue == ''
//           ? await _productService.getAllProducts()
//           : await _productService.getProductByCategoryOrName(finalSearchValue);
//
//       if (response.statusCode == 200) {
//         var responseJsonStr = json.decode(response.body);
//         var jsonProd = finalSearchValue == ''
//             ? responseJsonStr['data']['products']
//             : responseJsonStr['data']['result'];
//
//         _productList.clear();
//         //todo LATER
//         // _productList.addAll(productFromJson(json.encode(jsonProd)));
//         _isLoadingAllProducts = false;
//         notifyListeners();
//         //todo LATER put out those notifyListners outside curly braces
//       } else {
//         _isLoadingAllProducts = true;
//         notifyListeners();
//       }
//     } on SocketException catch (_) {
//       _isLoadingAllProducts = true;
//       notifyListeners();
//     } on HttpException catch (_) {
//       _isLoadingAllProducts = true;
//       notifyListeners();
//     } catch (e) {
//       print("Error ${e.toString()}");
//       _isLoadingAllProducts = true;
//       notifyListeners();
//     }
//   }
}
