// import 'dart:convert';
//
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_stripe/flutter_stripe.dart';
// //todo
// class StripeTransactionResponse {
//   String message;
//   bool success;
//   StripeTransactionResponse({required this.message, required this.success});
// }
//
// class StripeService {
//   static String apiBase = 'https://api.stripe.com/v1';
//   static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
//   static String secret = '';
//   static String publishableKey = 'pk_test_nGOzznmrg37WxxREAMw8jNHj00ukQ2wSgi';
//   static Map<String, String> headers = {
//     'Authorization': 'Bearer ${StripeService.secret}',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//
//   static init() {
//     StripePayment.setOptions(
//       StripeOptions(
//           publishableKey: publishableKey,
//           merchantId: "Test",
//           androidPayMode: "test"),
//     );
//   }
//
//   static Future<StripeTransactionResponse> processPayment(
//       String amount, currency) async {
//     try {
//       var paymentMethod = await StripePayment.paymentRequestWithCardForm(
//           CardFormPaymentRequest());
//       var paymentIntent = await StripeService.createPaymentIntent(
//         amount,
//         currency,
//       );
//
//       var response = await StripePayment.confirmPaymentIntent(
//         PaymentIntent(
//           clientSecret: paymentIntent['client_secret'],
//           paymentMethodId: paymentMethod.id,
//         ),
//       );
//
//       if (response.status == 'succeeded') {
//         return StripeTransactionResponse(
//           message: 'Transaction successful',
//           success: true,
//         );
//       } else {
//         return StripeTransactionResponse(
//           message: 'Transaction  failed',
//           success: false,
//         );
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (e) {
//       return StripeTransactionResponse(
//         message: 'Transaction  failed: ${e.toString()}',
//         success: false,
//       );
//     }
//   }
//
//   static getPlatformExceptionErrorResult(err) {
//     String message = 'Something went wrong';
//     if (err.code == 'cancelled') {
//       message = 'Transaction cancelled';
//     }
//
//     return StripeTransactionResponse(message: message, success: false);
//   }
//
//   static Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//
//       var response = await http.post(
//         StripeService.paymentApiUrl,
//         body: body,
//         headers: StripeService.headers,
//       );
//
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('error charging user: ${err.toString()}');
//     }
//     return null;
//   }
//
//   Future<void> onGooglePayResult(paymentResult) async {
//     final response = await fetchPaymentIntentClientSecret();
//     final clientSecret = response['clientSecret'];
//     final token = paymentResult['paymentMethodData']['tokenizationData']['token'];
//     final tokenJson = Map.castFrom(json.decode(token));
//
//     final params = PaymentMethodParams.cardFromToken(
//       token: tokenJson['id'], paymentMethodData: null,
//     );
//     // Confirm Google pay payment method
//     await Stripe.instance.confirmPayment(
//       clientSecret,
//       params,
//     );
//   }
// }
