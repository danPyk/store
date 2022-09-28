import 'package:store/screens/auth_screen.dart';
import 'package:store/screens/shipping.dart';
import 'package:flutter/material.dart';

class ShoppingCartBottomSheet extends StatelessWidget {
  final String? message;
  const ShoppingCartBottomSheet({
     this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            message!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          OutlinedButton(
    //color red
            onPressed: () {
              Navigator.pushNamed(context, AuthScreen.id);
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'OR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          OutlinedButton(

            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Shipping.id);
            },
            child: const Text(
              'Continue as Guest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
