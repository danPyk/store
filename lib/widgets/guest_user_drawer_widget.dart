import 'package:store/controllers/activity_tracker_controller.dart';
import 'package:store/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuestUserDrawerWidget extends StatelessWidget {
  final String message;
  final String currentTask;
  const GuestUserDrawerWidget(
      { Key? key, required this.message, required this.currentTask})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
      child: Column(
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ButtonTheme(
            minWidth: 150,
            child: OutlinedButton(

              onPressed: () {
                Provider.of<ActivityTracker>(context, listen: false)
                    .setTaskCurrentTask(currentTask);
                Navigator.pushReplacementNamed(context, AuthScreen.id);
              },
              child: const Text(
                'SIGN IN',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
