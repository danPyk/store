import 'package:store/screens/order_history.dart';
import 'package:store/screens/profile.dart';
import 'package:flutter/material.dart';

class CDrawer extends StatefulWidget {
  const CDrawer({Key? key}) : super(key: key);

  @override
  _CDrawerState createState() => _CDrawerState();
}

class _CDrawerState extends State<CDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Image(
              image: AssetImage("assets/images/logo.png"),
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: ListTile(
              tileColor: Colors.grey[200],
              leading: const Icon(Icons.person),
              trailing: const Icon(Icons.people),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Profile.id);
              },
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: ListTile(
              tileColor: Colors.grey[200],
              leading: const Icon(Icons.history),
              trailing: const Icon(Icons.history_edu),
              title: const Text(
                'Order history',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, OrderHistory.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
