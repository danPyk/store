import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:store/controllers/auth_controller.dart';
import 'package:store/controllers/error_controller.dart';
import 'package:store/injection.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/product.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/services/cart_service.dart';
import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  final _cart = <CartItem>[];

  bool _isLoadingProduct = true;

  CartItem _selectedItem = CartItem.empty();

  final _authController = AuthController(getIt.call<AuthService>());

  final _cartService = CartService();

  List<CartItem> get cart => _cart;

  bool get isLoadingProduct => _isLoadingProduct;

  CartItem get selectedItem => _selectedItem;

  void setCurrentItem(Product product) async {
    _isLoadingProduct = true;

    var item = CartItem(product: product, quantity: 1);

    if (isItemInCart(item)) {
      var foundItem = getCartItem(item);
      _selectedItem = foundItem;
      _isLoadingProduct = false;
      notifyListeners();
    } else {
      _selectedItem = CartItem(product: product, quantity: 1);
      _isLoadingProduct = false;
      notifyListeners();
    }
  }

  void addToCart(CartItem cartItem) {
    cart.add(cartItem);
    notifyListeners();
  }

  bool isItemInCart(CartItem cartItem) {
    bool isFound = false;
    if (cart.isNotEmpty) {
      for (CartItem item in cart) {
        if (item.product.id == cartItem.product.id) {
          isFound = true;
        }
      }
      return isFound;
    }
    return isFound;
  }

  void removeFromCart(CartItem cartItem) {
    CartItem foundItem = CartItem.empty();
    if (cart.isNotEmpty) {
      for (CartItem item in cart) {
        if (item.product.id == cartItem.product.id) {
          foundItem = item;
        }
      }
      cart.remove(foundItem);
      notifyListeners();
    }
  }

  increaseCartItemAndProductDetailItemQuantity() {
    if (isItemInCart(_selectedItem)) {
      var foundItem = getCartItem(_selectedItem);
      foundItem.quantity++;
      notifyListeners();
    } else {
      _selectedItem.quantity++;
      notifyListeners();
    }
  }

  decreaseCartItemAndProductDetailItemQuantity() {
    if (isItemInCart(_selectedItem)) {
      var foundItem = getCartItem(_selectedItem);
      if (foundItem.quantity > 1) {
        //this affects both selected item and item in cart's quantity
        foundItem.quantity--;
        notifyListeners();
      }
    } else {
      if (_selectedItem.quantity > 1) {
        _selectedItem.quantity--;
        notifyListeners();
      }
    }
  }

  CartItem getCartItem(CartItem cartItem) {
    CartItem foundItem = CartItem.empty();
    for (CartItem item in cart) {
      if (item.product.id == cartItem.product.id) {
        foundItem = item;
      }
    }
    return foundItem;
  }

  singleCartItemIncrease(CartItem cartItem) {
    var foundItem = getCartItem(cartItem);
    foundItem.quantity++;
    notifyListeners();
  }

  singleCartItemDecrease(CartItem cartItem) {
    var foundItem = getCartItem(cartItem);
    if (foundItem.quantity > 1) {
      //this affects both selected item and item in cart's quantity
      foundItem.quantity--;
      notifyListeners();
    }
  }

  resetCart() {
    cart.clear();
    deleteSavedCart();
  }

  saveCart(List<CartItem> cart, GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      for (var cartItem in cart) {
        var productId = cartItem.product.id;
        var quantity = cartItem.quantity.toString();
        var authData = await _authController.getUserDataAndLoginStatus();
        await _cartService.saveCart(
            productId, authData[0]!, quantity, authData[2]!);
      }
    } on SocketException catch (_) {
      ErrorController.showNoInternetError(scaffoldKey);
    } on HttpException catch (_) {
      ErrorController.showNoServerError(scaffoldKey);
    } on FormatException catch (_) {
      ErrorController.showFormatExceptionError(scaffoldKey);
    } catch (e) {
      ErrorController.showUnKownError(scaffoldKey);
    }
  }

  //get cart from db if it was saved at check out stage
  //can only be saved if user logged in
  //can only be loaded if jwt token didn't expire
  getSavedCart() async {
    try {
      List<String?> authData =
          await _authController.getUserDataAndLoginStatus();
      String? userId = authData[0];
      String? jwtToken = authData[2];

      var  response;
      if (userId != null) {
        response = await _cartService.getCart(userId, jwtToken!);
      }

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var cartObj = jsonResponse['data']['cart'];
        cart.addAll(cartItemFromJson(json.encode(cartObj)));

        notifyListeners();
      } else {
        //cart isn't updated because it wasn't saved,or jwt expired
        //that is okay. User can proceed with using the app
        //will be prompted to either login or continue as guest at checkout stage
        //else block included for future implementation when required
      }
    } catch (e) {
      print('Get saved cart err ${e.toString()}');
    }
  }

  deleteSavedCart() async {
    try {
      var authData = await _authController.getUserDataAndLoginStatus();
      var userId = authData[0];

      var response = await _cartService.deleteCart(userId!);

      if (response.statusCode == 204) {
        //cart is deleted on check out completion
        //no need to inform user
        print('cart deleted');
      } else {
        print('cart not deleted');
      }
    } catch (e) {
      print('Delete saved cart err ${e.toString()}');
    }
  }
//todo later
//REQUIRED IF YOU NEED TO FETCH PRODUCT BY ID  FROM API AND SET SELECTED ITEM

// void setCurrentItem(
//     String productId, GlobalKey<ScaffoldState> scaffoldKey) async {
//   try {
//     _isLoadingProduct = true;

//     var response = await _productService.getProductById(productId);

//     if (response.statusCode == 200) {
//       var responseJsonStr = json.decode(response.body);
//       var jsonProd = responseJsonStr['data']['product'];
//       var product = Product.fromJson(jsonProd);
//       var item = CartItem(product: product, quantity: 1);
//       if (isItemInCart(item)) {
//         var foundItem = getCartItem(item);
//         _selectedItem = foundItem;
//         _isLoadingProduct = false;
//         notifyListeners();
//       } else {
//         _selectedItem = CartItem(product: product, quantity: 1);
//         _isLoadingProduct = false;
//         notifyListeners();
//       }
//     } else {
//       ErrorController.showErrorFromApi(scaffoldKey, response);
//     }
//   } on SocketException catch (_) {
//     ErrorController.showNoInternetError(scaffoldKey);
//   } on HttpException catch (_) {
//     ErrorController.showNoServerError(scaffoldKey);
//   } on FormatException catch (_) {
//     ErrorController.showFormatExceptionError(scaffoldKey);
//   } catch (e) {
//     print("Error ${e.toString()}");
//     ErrorController.showUnKownError(scaffoldKey);
//   }
// }

}
