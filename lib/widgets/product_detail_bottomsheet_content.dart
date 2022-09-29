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
          //todo hyperlink to mail, contact form,
          Text(
            "I know it's dope, but ${_cartCtlr.selectedItem.product.name} is already in cart, if you want more contact me',",
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
              InkWell(
                child: CartButton(
                  text: 'Remove',
                  width: MediaQuery.of(context).size.width * 0.25,
                  key: const Key('cartKey'),
                ),
                onTap: () {
                  _cartCtlr.removeFromCart(_cartCtlr.selectedItem);
                  Navigator.pop(context);
                },
              ),
              const Text('OR'),
              InkWell(
                child: CartButton(
                  text: 'View cart',
                  width: MediaQuery.of(context).size.width * 0.25,
                  key: const Key('cartKey'),
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
