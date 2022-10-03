import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/constants/screen_ids.dart';

import '../screensStripe/screens.dart';

class StripPayment extends StatefulWidget {
  const StripPayment({Key? key}) : super(key: key);
  static String id = stripPaymentId;

  @override
  State<StripPayment> createState() => _StripPaymentState();
}

class _StripPaymentState extends State<StripPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Examples'),
      ),
      body: ListView(children: [
        ...ListTile.divideTiles(
          context: context,
          tiles: [for (final example in Example.screens) example],
        ),
      ]),
    );
  }
}
