import 'package:flutter/material.dart';

class ProductListSkeleton extends StatelessWidget {
  const ProductListSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey,
            child: const Text(''),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 10,
                width: 80,
                color: Colors.grey,
                child: const Text(''),
              ),
              Container(
                height: 10,
                width: 50,
                color: Colors.grey,
                child: const Text(''),
              ),
            ],
          ),
        ]);
      },
    );
  }
}
