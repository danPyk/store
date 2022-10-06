import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/constants/tasks.dart';
import 'package:store/controllers/activity_tracker_controller.dart';
import 'package:store/controllers/order_controller.dart';
import 'package:store/screens/products_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleOrder extends StatefulWidget {
  const SingleOrder({Key? key}) : super(key: key);
  static String id = singleOrderScreenId;

  @override
  _SingleOrderState createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  Future<bool> _onBackPressed() {
    var currentTask =
        Provider.of<ActivityTracker>(context, listen: false).currentTask;
    if (currentTask == VIEWING_SINGLE_OLD_ORDER_HISTORY) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, ProductList.id, (route) => false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                '$singleOrderScreenTitle ${context.watch<OrderController>().singleOrder.id ?? ''}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 1,
              backgroundColor: Colors.white,
            ),
            body: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //order details
                      const SizedBox(height: 20.0),
                      const Text(
                        'SHIPPING DETAILS',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Date and time ordered:  ${context.watch<OrderController>().singleOrder.dateOrdered ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Payment method:  ${context.watch<OrderController>().singleOrder.paymentMethod ?? ''} ',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Shipping cost: \$ ${context.watch<OrderController>().singleOrder.shippingCost ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Tax: \$ ${context.watch<OrderController>().singleOrder.tax ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Total item price: \$ ${context.watch<OrderController>().singleOrder.totalItemPrice ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Total: \$  ${context.watch<OrderController>().singleOrder.total ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),

                      //shipping details
                      const SizedBox(height: 20.0),
                      const Text(
                        'ORDER DETAILS',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Name: ${context.watch<OrderController>().singleOrder.shippingDetails.name ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Phone Contact:  ${context.watch<OrderController>().singleOrder.shippingDetails.phoneContact ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Address Line:  ${context.watch<OrderController>().singleOrder.shippingDetails.addressLine ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'City: ${context.watch<OrderController>().singleOrder.shippingDetails.city ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Postal code: ${context.watch<OrderController>().singleOrder.shippingDetails.postalCode ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Country:  ${context.watch<OrderController>().singleOrder.shippingDetails.country ?? ''}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      //items
                      const Text(
                        'ITEMS',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Consumer<OrderController>(
                          builder: (context, ctlr, chidl) {
                        if (ctlr.isProcessingOrder &&
                            ctlr.singleOrder.cartItems == null) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: ctlr.singleOrder.cartItems.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name: ${ctlr.singleOrder.cartItems[index].product.name}",
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Price: ${ctlr.singleOrder.cartItems[index].product.price}",
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Quantity: ${ctlr.singleOrder.cartItems[index].quantity}",
                                  ),
                                  const Divider(
                                    thickness: 5,
                                    color: Colors.grey,
                                  ),
                                ],
                              );
                            });
                      }),

                      const SizedBox(height: 10.0),
                      Center(
                        child: OutlinedButton(

                          onPressed: () {},
                          child: Text(
                            context.watch<ActivityTracker>().currentTask == VIEWING_SINGLE_OLD_ORDER_HISTORY ? 'Thank you for the support' : "WE'LL CONTACT YOU SHORTLY",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),

                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
