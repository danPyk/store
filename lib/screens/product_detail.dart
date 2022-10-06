import 'package:store/constants/screen_ids.dart';
import 'package:store/screens/shopping_cart.dart';
import 'package:badges/badges.dart';
import 'package:store/controllers/cart_controller.dart';
import 'package:store/skeletons/product_detail_skeleton.dart';
import 'package:store/widgets/cart_button.dart';
import 'package:store/widgets/product_detail_bottomsheet_content.dart';
import 'package:store/widgets/round_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);
  static String id = productDetailScreenId;

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var _cartCtlr;

  @override
  void initState() {
    super.initState();
    _cartCtlr = Provider.of<CartController>(context, listen: false);
  }

  _handleButtonTap(context) {
    if (!_cartCtlr.isItemInCart(_cartCtlr.selectedItem)) {
      _cartCtlr.addToCart(_cartCtlr.selectedItem);
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) =>
            ProductDetailBottomSheetContent(cartCtlr: _cartCtlr),
      );
    }
  }

  _handleQuantityIncrease() {
    _cartCtlr.increaseCartItemAndProductDetailItemQuantity();
  }

  _handleQuantityDecrease() {
    _cartCtlr.decreaseCartItemAndProductDetailItemQuantity();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double leftMargin = 18;
    double rightMargin = 10;

    return Scaffold(
      appBar: AppBar(
        title: Consumer<CartController>(
          builder: (context, cartCtlr, child) {
            if (!cartCtlr.isLoadingProduct) {
              return Text(
                cartCtlr.selectedItem.product.category,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              );
            }
            return const Text('Loading ...');
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, top: rightMargin),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ShoppingCart.id);
              },
              child: Badge(
                padding: const EdgeInsets.all(5),
                badgeContent: Text(
                  '${context.watch<CartController>().cart.length}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Consumer<CartController>(
          builder: (context, cartCtlr, child) {
            if (cartCtlr.isLoadingProduct) {
              return Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[400]!,
                  child: const ProductDetailSkeleton(),
                ),
              );
            }
            return ListView(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: leftMargin, right: rightMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //product image
                      SizedBox(
                        height: size.width / 2 + 100,
                        width: size.width,
                        child: Image.network(
                          cartCtlr.selectedItem.product.imageUrl,
                          fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Center(child: Icon(Icons.error));
                          },
                          loadingBuilder: (BuildContext context, Widget child,
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

                      const SizedBox(
                        height: 30,
                      ),

                      //product name and price
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cartCtlr.selectedItem.product.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              "\$${cartCtlr.selectedItem.product.price}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),

                      const Divider(
                        thickness: 3,
                      ),
                      // increment and decrement buttons, add to cart button
                      Container(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // quantity ,increment,and decrement buttons
                              Row(
                                children: [
                                  //todo 1/2, when product is only one, deleta add/sub btns
                                  //decrement button
                                  RoundCartButton(
                                    icon: Icons.remove,
                                    width: size.width * 0.1,
                                    onTap: () {
                                      _handleQuantityDecrease();
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // quantity
                                    child: Text(
                                      '${context.watch<CartController>().selectedItem.quantity}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // increment button
                                  RoundCartButton(
                                    icon: Icons.add,
                                    width: size.width * 0.1,
                                    onTap: () {
                                      _handleQuantityIncrease();
                                    },
                                  ),
                                ],
                              ),

                              //add to cart button
                              InkWell(
                                onTap: () {
                                  _handleButtonTap(context);
                                },
                                child: CartButton(
                                  text: "ADD",
                                  width: size.width * 0.2,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 3,
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      //Details
                      const Text(
                        "Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        cartCtlr.selectedItem.product.details,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
