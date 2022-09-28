import 'package:store/constants/payment.dart';
import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/controllers/auth_controller.dart';
import 'package:store/controllers/cart_controller.dart';
import 'package:store/controllers/error_controller.dart';
import 'package:store/controllers/order_controller.dart';
import 'package:store/controllers/shipping_controller.dart';
import 'package:store/screens/thank_you.dart';
import 'package:store/services/paypal_service.dart';
import 'package:store/services/stripe_service.dart';
import 'package:store/widgets/dialog.dart';
import 'package:store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);
  static String id = paymentMethodScreenId;

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  var _authController;
  var _cartController;
  var _shippingController;
  var _orderController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _progressDialog;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _cartController = Provider.of<CartController>(context, listen: false);
    _shippingController =
        Provider.of<ShippingController>(context, listen: false);
    _orderController = Provider.of<OrderController>(context, listen: false);
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var totalItemPrice = _cartController.cart.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.product.price * element.quantity));
    int tax = _orderController.tax;
    int shippingCost = _orderController.shippingCost;

    var total = totalItemPrice + tax + shippingCost;
    String totalToString = '${total}100';

    _progressDialog = CDialog(context).dialog;

    _peformStateReset() {
      _cartController.resetCart();
      _shippingController.reset();
    }

    _handleStripeSucessPayment() async {
      var data = await _authController.getUserDataAndLoginStatus();

      _orderController.registerOrderWithStripePayment(
        _shippingController.getShippingDetails(),
        shippingCost.toString(),
        tax.toString(),
        total.toString(),
        totalItemPrice.toString(),
        data[0],
        stripePayment,
        _cartController.cart,
        _scaffoldKey,
      );

      await _progressDialog.hide();
      _peformStateReset();
      Navigator.pushNamed(context, Thanks.id);
    }

    _handleStripeFailurePayment() async {
      await _progressDialog.hide();

      GlobalSnackBar.showSnackbar(
        _scaffoldKey,
        'Process cancelled',
        SnackBarType.Error,
      );
    }

    _handlePaypalBrainTree(String nonce) async {
      var data = await _authController.getUserDataAndLoginStatus();

      _orderController.processOrderWithPaypal(
        _shippingController.getShippingDetails(),
        shippingCost.toString(),
        tax.toString(),
        total.toString(),
        totalItemPrice.toString(),
        data[0],
        payPall,
        _cartController.cart,
        nonce,
        _scaffoldKey,
      );

      await _progressDialog.hide();
      _peformStateReset();
      Navigator.pushNamed(context, Thanks.id);
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title:  const Text(
            paymentScreenTitle,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 1,
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: const EdgeInsets.only(
            left: 18,
            top: 18,
            right: 18,
          ),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //title
                  const Text(
                    "Order summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Table(
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        width: .5,
                      ),
                      bottom: BorderSide(
                        width: .5,
                      ),
                      top: BorderSide(
                        width: .5,
                      ),
                    ),
                    children: [
                      //item
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              'Items',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              '\$ $totalItemPrice',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //shipping
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              'Shipping',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              '\$ $shippingCost',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //tax
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Text(
                              'Tax',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              '\$ $tax',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //total
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              '\$ $total',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                  // Payment
                  const Text(
                    "Choose Payment method",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //paypal
                  ButtonTheme(
                    minWidth: size.width,
                    child: OutlinedButton (

                      onPressed: () async {
                        await _progressDialog.show();
                        var nonce = await PayPalService.processPayment(
                            total.toString());
                        if (nonce != null) {
                          _handlePaypalBrainTree(nonce);
                        } else {
                          await _progressDialog.hide();
                          ErrorController.showCustomError(
                              _scaffoldKey, 'An error occurred');
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Pay",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "Pal",
                              style: TextStyle(
                                color: Colors.blue[100],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Text(
                    "or",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  //credit or debit button
                  OutlinedButton(

                    onPressed: () async {
                      await _progressDialog.show();

                      var result = await StripeService.processPayment(
                          totalToString, 'usd');

                      if (result.success) {
                        _handleStripeSucessPayment();
                      } else {
                        _handleStripeFailurePayment();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.credit_card,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Credit or Debit card",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
