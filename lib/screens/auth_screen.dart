import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/constants/tasks.dart';
import 'package:store/controllers/activity_tracker_controller.dart';
import 'package:store/controllers/auth_controller.dart';
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
class AuthScreen extends StatefulWidget {
  //used for navigation using named route
  static String id = authScreenId;

  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}
//todo sometimes keyubord is not hiding

enum AuthScreenId { SignIn_Screen, SignUp_Screen, ForgotPassword_Screen }

class _AuthScreenState extends State<AuthScreen> {
  var _formKey = GlobalKey<FormState>();
  var _screenTitle = signInScreenTitle;
  AuthScreenId _authScreenId = AuthScreenId.SignIn_Screen;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email = '';
  String _password = '';
  String _name = '';

  late final AuthController _authController;

  var _progressDialog;

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
        key: _scaffoldKey,
        body: SafeArea(
          child: ListView(children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height / 2.5,
                      child: CustomPaint(
                        painter: AuthScreenCustomPainter(),
                      ),
                    ),
                    Positioned(
                      child: Text(
                        "$_screenTitle",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                      top: size.height / 5,
                      left: leftMargin,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: leftMargin, right: leftMargin),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: formTextFields() + formButtons(size),
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

  List<Widget> formTextFields() {
    if (_authScreenId == AuthScreenId.SignIn_Screen) {
      return [
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          initialValue: 'a@a.pl',
          decoration: const InputDecoration(
            labelText: "Email",
            hintText: "e.g johndoe@gmail.com",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          onSaved: (value) => _email = value!,
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
            labelText: "aaaaaa",
            hintText: "e.g secret",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          obscureText: true,
          onSaved: (value) => _password = value!,
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
      ];
    } else if (_authScreenId == AuthScreenId.SignUp_Screen) {
      return [
        TextFormField(
          initialValue: 'name',
          decoration: const InputDecoration(
            labelText: "Name",
            hintText: "e.g John Doe",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          onSaved: (value) => _name = value!,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Name is required';
            }

            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          initialValue: 'a@a.pl',
          decoration: const InputDecoration(
            labelText: "Email",
            hintText: "e.g johndoe@gmail.com",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) => _email = value!,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Email is required';
            }
            if (!Validator.isEmailValid(value)) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          initialValue: 'aaaaaa',
          decoration: const InputDecoration(
            labelText: "Password",
            hintText: "e.g secret",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          obscureText: true,
          onSaved: (value) => _password = value!,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return "Too short";
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ];
    }

    ///forogt password input field
    return [
      TextFormField(
        initialValue: 'a@a.pl',
        decoration: const InputDecoration(
          labelText: "Email",
          hintText: "e.g johndoe@gmail.com",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => _email = value!,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email is required';
          }
          if (!Validator.isEmailValid(value)) {
            return 'Invalid email';
          }
          return null;
        },
      ),
    ];
  }

  List<Widget> formButtons(size) {
    if (_authScreenId == AuthScreenId.SignIn_Screen) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sign in",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            RoundIconButton(
              width: size.width / 5,
              height: size.width / 5,
              backgroundColor: const Color(0xff4b515a),
              iconData: Icons.arrow_forward,
              iconColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();

                  await _progressDialog.show();

                  if (await _authController.emailAndPasswordSignIn(
                    _email,
                    _password,
                    _scaffoldKey,
                  )) {
                    await _progressDialog.hide();
                    chooseNextScreen();
                  } else {
                    await _progressDialog.hide();
                  }
                }
              },
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        //row with sign up and forgot password link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // sign up link
            GestureDetector(
              child: const UnderlinedText(
                text: 'Sign up',
                decorationThickness: 3,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              onTap: () {
                setState(() {
                  _screenTitle = signUpScreenTitle;
                  _authScreenId = AuthScreenId.SignUp_Screen;
                });
              },
            ),
            // forgot password link
            GestureDetector(
              onTap: () {
                setState(() {
                  _screenTitle = forgotPasswordScreenTtile;
                  _authScreenId = AuthScreenId.ForgotPassword_Screen;
                });
              },
              child: const UnderlinedText(
                text: 'Forgot password',
                decorationThickness: 3,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ];
    }

    if (_authScreenId == AuthScreenId.SignUp_Screen) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            RoundIconButton(
              width: size.width / 5.5,
              height: size.width / 5.5,
              backgroundColor: const Color(0xff4b515a),
              iconData: Icons.arrow_forward,
              iconColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();

                  await _progressDialog.show();

                  if (await _authController.emailNameAndPasswordSignUp(
                    _name,
                    _email,
                    _password,
                    _scaffoldKey,
                  )) {
                    await _progressDialog.hide();
                    chooseNextScreen();
                  } else {
                    await _progressDialog.hide();
                  }
                }
              },
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        //row with sign in link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: const UnderlinedText(
                text: 'Sign in',
                decorationThickness: 3,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              onTap: () {
                setState(() {
                  _screenTitle = signInScreenTitle;
                  _authScreenId = AuthScreenId.SignIn_Screen;
                });
              },
            ),
          ],
        ),
      ];
    }

    //forgot password button
    return [
      const SizedBox(
        height: 40,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Forgot password",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          RoundIconButton(
            width: size.width / 5.5,
            height: size.width / 5.5,
            backgroundColor: const Color(0xff4b515a),
            iconData: Icons.arrow_forward,
            iconColor: Colors.white,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                await _progressDialog.show();
                if (await _authController.forgotPassword(
                    _email, _scaffoldKey)) {
                  await _progressDialog.hide();
                  _formKey.currentState?.reset();
                } else {
                  await _progressDialog.hide();
                }
              }
            },
          ),
        ],
      ),
      const SizedBox(
        height: 40,
      ),
      //back to signin link
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: const UnderlinedText(
              text: 'Sign in',
              decorationThickness: 3,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            onTap: () {
              setState(() {
                _screenTitle = signInScreenTitle;
                _authScreenId = AuthScreenId.SignIn_Screen;
              });
            },
          ),
        ],
      ),
    ];
  }

  void chooseNextScreen() async {
    String currentTask =
        Provider.of<ActivityTracker>(context, listen: false).currentTask;

    switch (currentTask) {
      case VIEWING_ORDER_HISTORY:
        Navigator.pushReplacementNamed(context, OrderHistory.id);
        break;
      case VIEWING_PROFILE:
        Navigator.pushReplacementNamed(context, Profile.id);
        break;
      default:
        Navigator.pushReplacementNamed(context, Shipping.id);
        break;
    }
  }
}
