import 'package:store/constants/api_config.dart';

class AppProperties {
  static const String _baseApiUrl = ApiConfig.host;

  static String productUrl = '$_baseApiUrl/product/';

  static String categoryUrl = '$_baseApiUrl/product/category/';

  static String searchByCategoryOrNameUrl = '$_baseApiUrl/products/search/';

  static String searchByCategoryUrl = '$_baseApiUrl/product/category/';

  static String saveOrderUrl = '$_baseApiUrl/cart/flutter/stripepayment';

  static String payPalRequestUrl = '$_baseApiUrl/cart/braintree/paypalpayment/';

  static String getOrdersUrl = '$_baseApiUrl/cart/orders/user/';

  static String checkTokenExpiryUrl = '$_baseApiUrl/people/checktokenexpiry';

  static String cartUrl = '$_baseApiUrl/cart/';

  ///PEOPLE

  static String signUpUrl = '$_baseApiUrl/people/';

  static String signInUrl = '$_baseApiUrl/people/signin';

  static String changenameUrl = '$_baseApiUrl/people/updatename/';

  static String changeMailUrl = '$_baseApiUrl/people/updatemail/';

  static String forgotPasswordUrl = '$_baseApiUrl/people/forgotpassword';
}
