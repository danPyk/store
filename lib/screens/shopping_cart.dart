import 'package:badges/badges.dart';
import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/controllers/auth_controller.dart';
import 'package:store/controllers/cart_controller.dart';
import 'package:store/injection.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/screens/products_list.dart';
import 'package:store/screens/shipping.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/widgets/cart_button.dart';
import 'package:store/widgets/round_cart_button.dart';
import 'package:store/widgets/shopping_cart_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  static String id = shoppingCartScreenId;

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final double _rightMargin = 10;
  var _cartController;
  var _authController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isProcessingCheckout = false;

  @override
  void initState() {
    super.initState();
    _cartController = Provider.of<CartController>(context, listen: false);
    _authController = AuthController(getIt.call<AuthService>());
  }

  _handleItemQuantityIncrease(CartItem cartItem) {
    _cartController.singleCartItemIncrease(cartItem);
  }

  _handleItemQuantityDecrease(CartItem cartItem) {
    _cartController.singleCartItemDecrease(cartItem);
  }

  _handleRemoveCartItem(CartItem cartItem) {
    _cartController.removeFromCart(cartItem);
  }

  _checkoutButtonHandler(BuildContext context) async {
    _toggleIsProcessingCheckout();

    var data = await _authController.getUserDataAndLoginStatus();
    //user is not logged in
    if (data[1] == null || data[1] == '0') {
      //provide option to continue as guest or log in
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => const ShoppingCartBottomSheet(message: 'Create accounte'),
      );

      _toggleIsProcessingCheckout();
    } else {
      var isValid = await _authController.isTokenValid();

      //check if jwt has expired
      if (!isValid) {
        //provide option to continue as guest or log in
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) =>
              const ShoppingCartBottomSheet(message: 'Login session expired'),
        );
        _toggleIsProcessingCheckout();
      } else {
        //save cart and contnue
        _cartController.saveCart(_cartController.cart, _scaffoldKey);
        await Navigator.pushNamed(context, Shipping.id);
        _toggleIsProcessingCheckout();
      }
    }
  }

  _toggleIsProcessingCheckout() {
    setState(() {
      isProcessingCheckout = !isProcessingCheckout;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          shoppingCartScreenTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, top: _rightMargin),
            child: Badge(
              padding: const EdgeInsets.all(5),
              badgeContent: Text(
                '${context.watch<CartController>().cart.length}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.orange,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 18, right: 18, top: 20),
          //list of items and checkout button
          child: ListView(
            children: [
              //Contine shopping button
              OutlinedButton(

                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.settings.name == ProductList.id,
                  );
                },
                child: const Text(
                  'CONTINUE SHOPPING',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              //list of items
              Consumer<CartController>(
                builder: (context, cartCtlr, child) {
                  if (cartCtlr.cart.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 100,
                          bottom: 10,
                        ),
                        child: Text(
                          'Cart is clean and empty',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: cartCtlr.cart.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const Divider(
                              thickness: 2.0,
                              height: 2,
                            ),
                            //particular item
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Product image
                                Container(
                                  height: 150,
                                  width: size.width * 0.4,
                                  margin: const EdgeInsets.only(
                                    right: 18,
                                    bottom: 18,
                                    top: 10,
                                  ),
                                  child: Image.network(
                                    cartCtlr.cart[index].product.imageUrl,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return const Center(child: Icon(Icons.error));
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                //increment/decrement buttons, name,price
                                Expanded(
                                  child: Container(
                                    height: 150,
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // product name
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Text(
                                            cartCtlr.cart[index].product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        //product price
                                        Text(
                                          "\$ ${cartCtlr.cart[index].product.price}",
                                        ),

                                        //increment/decrement buttons,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            RoundCartButton(
                                              icon: Icons.remove,
                                              width: size.width * 0.1,
                                              onTap: () {
                                                _handleItemQuantityDecrease(
                                                    cartCtlr.cart[index]);
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                              ),
                                              child: Text(
                                                '${cartCtlr.cart[index].quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            //todo 2/2, when product is only one, deleta add/sub btns

                                            RoundCartButton(
                                              icon: Icons.add,
                                              width: size.width * 0.1,
                                              onTap: () {
                                                _handleItemQuantityIncrease(
                                                    cartCtlr.cart[index]);
                                              },
                                            ),
                                          ],
                                        ),

                                        //remove from cart button
                                        GestureDetector(
                                          onTap: () {
                                            _handleRemoveCartItem(
                                                cartCtlr.cart[index]);
                                          },
                                          child: CartButton(
                                            text: "REMOVE",
                                            width: size.width * 0.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                },
              ),

              const Divider(
                thickness: 2.0,
                height: 2,
              ),

              const SizedBox(
                height: 25.0,
              ),

              //total and checkout button
              Consumer<CartController>(
                builder: (context, cartCtlr, child) {
                  if (cartCtlr.cart.isEmpty) {
                    return const Visibility(
                      visible: false,
                      child: Text('empty cart'),
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //total
                      RichText(
                        text: TextSpan(
                          text: 'Sub Total: ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '\$ ${context.watch<CartController>().cart.fold(0, (previousValue, element) => previousValue + (element.product.price * element.quantity))}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 15,
                      ),

                      ///Checkout button
                      GestureDetector(
                        onTap: () {
                          if (!isProcessingCheckout) {
                            _checkoutButtonHandler(context);
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red[900],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            child: isProcessingCheckout
                                ? const CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Row(
                                    children: const [
                                      Text(
                                        "CHECKOUT",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
