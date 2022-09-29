import 'dart:convert';
import 'dart:io';
import 'package:store/constants/payment.dart';
import 'package:store/controllers/auth_controller.dart';
import 'package:store/controllers/error_controller.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/order.dart';
import 'package:store/models/shipping_details.dart';
import 'package:store/services/order_service.dart';
import 'package:flutter/material.dart';

class OrderController extends ChangeNotifier {
  late final _orderService = OrderService();

  final _authContoller = AuthController();

  var _shippingCost;

  var _tax;
   Order _singleOrder = Order.empty();

  var _orders = <Order>[];

  bool _isLoadingOrders = true;

  bool get isLoadingOrders => _isLoadingOrders;

  List<Order> get orders => _orders;

  Order get singleOrder => _singleOrder;

  get tax => _tax;

  get shippingCost => _shippingCost;

  bool _isProcessingOrder = true;

  get isProcessingOrder => _isProcessingOrder;

  void setShippingCost(String country) async {
    try {
      _shippingCost = await _orderService.getShippingCost(country);
    } catch (e) {
      print('Order controller ${e.toString()}');
    }
  }

  void setTax(String country) async {
    try {
      _tax = await _orderService.getTax(country);
    } catch (e) {
      print('Order controller ${e.toString()}');
    }
  }

  void registerOrderWithStripePayment(
      ShippingDetails shippingDetails,
      String shippingCost,
      String tax,
      String total,
      String totalItemPrice,
      String userId,
      String paymentMethod,
      List<CartItem> cart,
      GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      //todo maybe
      var userType = userId.isNotEmpty ? userTypeRegistered : userTypeGuest;

      var order = Order(
        shippingDetails: shippingDetails,
        shippingCost: shippingCost,
        tax: tax,
        total: total,
        totalItemPrice: totalItemPrice,
        userId: userId,
        paymentMethod: paymentMethod,
        userType: userType,
        dateOrdered: DateTime.now(),
        cartItems: cart,
      );

      var orderToJson = order.toJson();
      var response = await _orderService.saveOrder(json.encode(orderToJson));

      if (response.statusCode == 200) {
        var jsonD = json.decode(response.body);
        _singleOrder = orderFromJson(json.encode(jsonD['data']));
        _isProcessingOrder = false;
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

  void processOrderWithPaypal(
    ShippingDetails shippingDetails,
    String shippingCost,
    String tax,
    String total,
    String totalItemPrice,
    String userId,
    String paymentMethod,
    List<CartItem> cart,
    String nonce,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    try {
      var userType = userId != null ? userTypeRegistered : userTypeGuest;

      var order = Order(
        shippingDetails: shippingDetails,
        shippingCost: shippingCost,
        tax: tax,
        total: total,
        totalItemPrice: totalItemPrice,
        userId: userId,
        paymentMethod: paymentMethod,
        userType: userType,
        dateOrdered: DateTime.now(),
        cartItems: cart,
      );

      var orderToJson = order.toJson();
      var response = await _orderService.sendPayPalRequest(
          json.encode(orderToJson), nonce);

      if (response.statusCode == 200) {
        var jsonD = json.decode(response.body);
        _singleOrder = orderFromJson(json.encode(jsonD['data']));
        _isProcessingOrder = false;
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

  void getOrders(GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      _isLoadingOrders = true;
      var data = await _authContoller.getUserDataAndLoginStatus();
      var response = await _orderService.getOrders(data[0]!, data[2]!);
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        _orders =
            ordersFromJson(json.encode(decodedResponse['data']['orders']));
        _isLoadingOrders = false;
        notifyListeners();
      } else {
        _isLoadingOrders = true;
        notifyListeners();
        ErrorController.showErrorFromApi(scaffoldKey, response);
      }
    } on SocketException catch (_) {
      _isLoadingOrders = true;
      notifyListeners();
      ErrorController.showNoInternetError(scaffoldKey);
    } on HttpException catch (_) {
      _isLoadingOrders = true;
      notifyListeners();
      ErrorController.showNoServerError(scaffoldKey);
    } on FormatException catch (_) {
      _isLoadingOrders = true;
      notifyListeners();
      ErrorController.showFormatExceptionError(scaffoldKey);
    } catch (e) {
      print('error fetching orders ${e.toString()}');
      _isLoadingOrders = true;
      notifyListeners();
      ErrorController.showUnKownError(scaffoldKey);
    }
  }

  void setSingleOrder(Order order) {
    _singleOrder = order;
  }
}
