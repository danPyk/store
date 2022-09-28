import 'package:store/constants/tasks.dart';
import 'package:store/controllers/activity_tracker_controller.dart';
import 'package:store/controllers/order_controller.dart';
import 'package:store/models/order.dart';
import 'package:store/screens/single_order.dart';
import 'package:store/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderHistoryItem extends StatelessWidget {
  final Order order;
  const OrderHistoryItem({
     Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: const Icon(Icons.info),
        trailing: const Icon(Icons.info_outlined),
        title: Text(
          'Order ${order.id}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          //todo
          'Made on ${getFormattedDate(order.dateOrdered.toString())}',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        tileColor: Colors.grey[200],
        contentPadding: const EdgeInsets.all(10.0),
        onTap: () {
          Provider.of<ActivityTracker>(context, listen: false)
              .setTaskCurrentTask(VIEWING_SINGLE_OLD_ORDER_HISTORY);

          Provider.of<OrderController>(context, listen: false)
              .setSingleOrder(order);

          Navigator.pushNamed(context, SingleOrder.id);
        },
      ),
    );
  }
}
