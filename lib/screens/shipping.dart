import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/constants/tasks.dart';
import 'package:store/controllers/activity_tracker_controller.dart';
import 'package:store/controllers/order_controller.dart';
import 'package:store/controllers/shipping_controller.dart';
import 'package:store/models/shipping_details.dart';
import 'package:store/screens/payment_method.dart';
import 'package:store/screens/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Shipping extends StatefulWidget {
  const Shipping({Key? key}) : super(key: key);
  static String id = shippingScreenId;

  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  final _shippingDdetailsFormkey = GlobalKey<FormState>();

  //this is to avoid showing bottom sheet again on previous shopping cart screen
  Future<bool> _onBackPressed() {
    Navigator.popUntil(context, ModalRoute.withName(ShoppingCart.id));
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    String phoneContact = '';
    String addressLine = '';
    String city = '';
    String postalCode = '';
    String country = '';
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              shippingDetailScreenTitle,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: Container(
            margin: const EdgeInsets.all(18),
            child: ListView(
              children: [
                Form(
                  key: _shippingDdetailsFormkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: "Enter name *",
                          icon: Icon(
                            Icons.person,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onSaved: (value) => name = value!,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        initialValue:
                            context.watch<ShippingController>().shippingDetails.name,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Enter phone number *",
                          icon: Icon(
                            Icons.phone,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onSaved: (value) => phoneContact = value!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required';
                          }
                          // if (!Validator.isPhoneNumberValid(value)) {
                          //   return "Invalid phone number";
                          // }
                          return null;
                        },
                        initialValue:
                            context.watch<ShippingController>().shippingDetails.phoneContact,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: "Enter address line*",
                          icon: Icon(
                            Icons.place,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onSaved: (value) => addressLine = value!,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        initialValue:
                            context.watch<ShippingController>().shippingDetails.addressLine,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Enter City *",
                          icon: Icon(
                            Icons.location_city,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onSaved: (value) => city = value!,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        initialValue:
                            context.watch<ShippingController>().shippingDetails.city,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Enter Postal Code *",
                          icon: Icon(
                            Icons.local_post_office,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onSaved: (value) => postalCode = value!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required';
                          }
                          // if (!Validator.isPostalCodeValid(value)) {
                          //   return 'Invalid postal code';
                          // }
                          return null;
                        },
                        initialValue:
                            context.watch<ShippingController>().shippingDetails.postalCode,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Enter Country *",
                          icon: Icon(
                            Icons.my_location,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onSaved: (value) => country = value!,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        initialValue:
                            context.watch<ShippingController>().shippingDetails.country,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          if (_shippingDdetailsFormkey.currentState!
                              .validate()) {
                            _shippingDdetailsFormkey.currentState!.save();

                            var shippingDetails = ShippingDetails(
                              //todo
                              id: '0',
                              name: name,
                              phoneContact: phoneContact,
                              city: city,
                              addressLine: addressLine,
                              postalCode: postalCode,
                              country: country,
                            );

                            Provider.of<ActivityTracker>(context, listen: false)
                                .setTaskCurrentTask(
                                    VIEWING_SINGLE_NEW_ORDER_HISTORY);

                            Provider.of<ShippingController>(context,
                                    listen: false)
                                .setShippingDetails(details: shippingDetails);

                            Provider.of<OrderController>(context, listen: false)
                                .setShippingCost(country);

                            Provider.of<OrderController>(context, listen: false)
                                .setTax(country);

                            Navigator.pushNamed(context, PaymentMethod.id);
                          }
                        },
                        child: const Text(
                          "CONTINUE",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
