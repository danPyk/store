import 'package:store/constants/api_config.dart';

class AppProperties {
  static const String _baseApiUrl = ApiConfig.host;

  ///PRODUCT

  static String productUrl = '$_baseApiUrl/product/';

  static String categoryUrl = '$_baseApiUrl/product/category/';

  static String searchByCategoryOrNameUrl = '$_baseApiUrl/products/search/';

  static String searchByCategoryUrl = '$_baseApiUrl/product/category/';

  ///ORDER

  static String saveOrderUrl = '$_baseApiUrl/order/stripepayment/';

  static String payPalRequestUrl = '$_baseApiUrl/order//paypalpayment/';

  static String getOrdersUrl = '$_baseApiUrl/order/';

  static String checkTokenExpiryUrl = '$_baseApiUrl/people/checktokenexpiry';

  static String cartUrl = '$_baseApiUrl/order/';

  ///PEOPLE

  static String signUpUrl = '$_baseApiUrl/people/';

  static String signInUrl = '$_baseApiUrl/people/signin/';

  static String changenameUrl = '$_baseApiUrl/people/updatename/';

  static String changeMailUrl = '$_baseApiUrl/people/updateemail/';

  static String changePasswordUrl = '$_baseApiUrl/people/changepassword/';

  static String forgotPasswordUrl = '$_baseApiUrl/people/forgotpassword/';

  static String resetPasswordUrl = '$_baseApiUrl/people/resetpassword/';
}
