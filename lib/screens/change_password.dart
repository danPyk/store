import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/constants/tasks.dart';
import 'package:store/controllers/activity_tracker_controller.dart';
import 'package:store/controllers/auth_controller.dart';
import 'package:store/controllers/error_controller.dart';
import 'package:store/injection.dart';
import 'package:store/screens/order_history.dart';
import 'package:store/screens/profile.dart';
import 'package:store/screens/shipping.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/utils/validator.dart';
import 'package:store/widgets/round_icon_button.dart';
import 'package:store/widgets/underlined_text..dart';

import '../widgets/auth_screen_custom_painter.dart';
import '../widgets/dialog.dart';

//todo later add animation when changing pages, plus buttons
class ChangePassword extends StatefulWidget {
  //used for navigation using named route
  static String id = authScreenId;

  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}
//todo sometimes keyubord is not hiding

enum AuthScreenId { SignIn_Screen, SignUp_Screen, ForgotPassword_Screen, ChangePassword_Screen }

class _ChangePasswordState extends State<ChangePassword> {
  var _screenTitle = signInScreenTitle;
  AuthScreenId _authScreenId = AuthScreenId.ChangePassword_Screen;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _password = '';
  String _passwordConfirm = '';

  late final AuthController _authController;
  late var _progressDialog;

  late var nameController = TextEditingController(text: 'a');
  late var emailController = TextEditingController(text: 'a@a.pl');
  late var passwordController = TextEditingController(text: 'aaaaaa');

  @override
  void initState() {
    super.initState();
    _authController = AuthController(getIt.call<AuthService>());
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = CDialog(context).dialog;

    var size = MediaQuery.of(context).size;
    var leftMargin = size.width / 10;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: ListView(children: [
            Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: size.height / 2.5,
                      child: CustomPaint(
                        painter: AuthScreenCustomPainter(),
                      ),
                    ),
                    Positioned(
                      top: size.height / 5,
                      left: leftMargin,
                      child: Text(
                        _screenTitle,
                        style:
                        const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: leftMargin, right: leftMargin),
                  child: Form(
                    child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              initialValue: 'aaaaaa',
                              decoration: const InputDecoration(
                                labelText: "New password:",
                                hintText: "New password:",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              onSaved: (value) => _password = value!,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!Validator.isEmailValid(value)) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                              key: const ValueKey("sign_up_email_field"),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              initialValue: 'aaaaaa',
                              decoration: const InputDecoration(
                                labelText: "Confirm password",
                                hintText: "Confirm password",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              obscureText: true,
                              onSaved: (value) => _passwordConfirm = value!,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                }

                                return null;
                              },
                              key: const ValueKey("sign_up_password_field"),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: const UnderlinedText(
                                    text: 'Save',
                                    decorationThickness: 3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  onTap: () {
                                    if(_password == _passwordConfirm){
                                      _authController.changePassword( _password, _scaffoldKey);

                                    }else{
                                      ErrorController.showCustomError(_scaffoldKey, 'Password do not matches');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }


}
