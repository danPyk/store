import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/constants/tasks.dart';
import 'package:store/controllers/auth_controller.dart';
import 'package:store/controllers/order_controller.dart';
import 'package:store/injection.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/widgets/guest_user_drawer_widget.dart';
import 'package:store/widgets/no_order_history_content.dart';
import 'package:store/widgets/order_history_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);
  static String id = orderHistoryScreenId;

  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory> {
  var _authController;
  var _orderController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _authController = AuthController(getIt.call<AuthService>());
    _orderController = Provider.of<OrderController>(context, listen: false);
  }

  Future<bool> getTokenValidity() async {
    return await _authController.isTokenValid();
  }

  Future<List<String>> getLoginStatus() async {
    return await _authController.getUserDataAndLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          orderHistoryScreenTitle,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            FutureBuilder(
              future: Future.wait([getTokenValidity(), getLoginStatus()]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }
//todo might
                String isLoggedInFlag = snapshot.data![1] as String;
                bool isTokenValid = snapshot.data![0] as bool;

                //when user is not signed in
                if (isLoggedInFlag.isNotEmpty || isLoggedInFlag == '0') {
                  return const GuestUserDrawerWidget(
                    message: 'Sign in to see order history',
                    currentTask: VIEWING_ORDER_HISTORY,
                  );
                }

                //when user token has expired
                if (!isTokenValid) {
                  return const GuestUserDrawerWidget(
                    message: 'Session expired. Sign in to see order history',
                    currentTask: VIEWING_ORDER_HISTORY,
                  );
                }

                _orderController.getOrders(_scaffoldKey);

                //user is logged in and token is valid
                return Consumer<OrderController>(
                    builder: (context, orderController, child) {
                  if (orderController.isLoadingOrders) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 3),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (orderController.orders.isEmpty) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 3),
                        child: const NoOrderHistoryFoundContent(),
                      ),
                    );
                  }
                  return Column(children: [
                    ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderController.orders.length,
                        itemBuilder: (context, index) {
                          return OrderHistoryItem(
                            order: orderController.orders[index],
                          );
                        })
                  ]);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
