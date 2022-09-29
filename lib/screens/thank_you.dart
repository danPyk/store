import 'package:http/http.dart' as http;
import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/screens/products_list.dart';
import 'package:store/screens/single_order.dart';
import 'package:flutter/material.dart';

import '../constants/api_config.dart';
import '../services/product_service.dart';

class Thanks extends StatelessWidget {
   Thanks({Key? key}) : super(key: key);
  static String id = thankYouScreenId;
  ProductService productService = ProductService();

  Future<void> response()async{
    final response =
    await http.get(Uri.parse('${ApiConfig.host}/product/id/1/'));
    print(response.statusCode);
    print(response.body);
    print('loggggggggggggggggggggggggggggggggggggggggg');
  }
//todo timeout handle
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      Navigator.pushNamedAndRemoveUntil(
          context, ProductList.id, (route) => false);
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              thanksScreenTitle,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 1,
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    size: 40,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Payment made successfully',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SingleOrder.id);
                    },
                    child: const Text(
                      "VIEW ORDER",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),

                  ),           OutlinedButton(
                    onPressed: () async {
                     await response();
                    },
                    child: const Text(
                      "TEST BUTTONNNN",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
