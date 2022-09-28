import 'package:store/screens/shopping_cart.dart';
import 'package:store/widgets/cart_button.dart';
import 'package:flutter/material.dart';

class ProductDetailBottomSheetContent extends StatelessWidget {
  const ProductDetailBottomSheetContent({
     Key? key,
    required cartCtlr,
  })  : _cartCtlr = cartCtlr,
        super(key: key);

  final _cartCtlr;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.grey[200],
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            '${_cartCtlr.selectedItem.product.name} already in cart',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(

                onPressed: () {
                  _cartCtlr.removeFromCart(_cartCtlr.selectedItem);
                  Navigator.pop(context);
                },
                child: const Text(
                  'REMOVE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const Text('OR'),
              InkWell(
                child: CartButton(
                  text: 'View cart',
                  width: MediaQuery.of(context).size.width * 0.25, key: const Key('cartKey'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ShoppingCart.id);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
