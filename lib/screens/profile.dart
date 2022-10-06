import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/constants/tasks.dart';
import 'package:store/controllers/auth_controller.dart';
import 'package:store/screens/products_list.dart';
import 'package:store/utils/validator.dart';
import 'package:store/widgets/dialog.dart';
import 'package:store/widgets/guest_user_drawer_widget.dart';
import 'package:flutter/material.dart';

import '../injection.dart';
import '../services/auth_service.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static String id = profileScreenId;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _authController;
  String _name = '';
  String _email = '';
  final GlobalKey<FormState> _saveNameFormKey = GlobalKey<FormState>();
  var _dialog;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _authController = AuthController(getIt.call<AuthService>());
  }

  Future<bool> _getTokenValidity() async {
    return await _authController.isTokenValid();
  }

  Future<List<String?>?> _getLoginStatus() async {
    final List<String?> result =
        await _authController.getUserDataAndLoginStatus();
    if (result[1] != null) {
      return result;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _dialog = CDialog(context).dialog;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          profileScreenTitle,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            FutureBuilder(
              future: Future.wait([_getTokenValidity(), _getLoginStatus()]),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }
//tODO DEFINIETLY
                bool? isTokenValid = snapshot.data?[0] as bool?;
                String?  isLoggedInFlag = snapshot.data?[1]?[1];
                String? email = snapshot.data?[1]?[3];
                String? name = snapshot.data?[1]?[4];


                //when user is not signed in
                if (isLoggedInFlag == null || isLoggedInFlag == '0') {
                  return const GuestUserDrawerWidget(
                    message: 'Sign in to see profile',
                    currentTask: VIEWING_PROFILE,
                  );
                }

                //when user token has expired
                if (!isTokenValid!) {
                  return const GuestUserDrawerWidget(
                    message: 'Session expired. Sign in to see profile',
                    currentTask: VIEWING_PROFILE,
                  );
                }

                //user is logged in and token is valid
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //avatar
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      child: CircleAvatar(
                        backgroundColor: Colors.orange[100],
                        child: Icon(
                          Icons.person_outline,
                          size: MediaQuery.of(context).size.width / 4,
                          color: Colors.orange,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //personal detail labels and their value
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          //name value
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$name',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    _handleEditIconClick(
                                        context, CHANGING_NAME);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 3,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          //email value
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$email',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    _handleEditIconClick(
                                        context, CHANGING_EMAIL);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 3,
                          ),

                          const SizedBox(height: 10),
                          ///LOGUT BTN
                          OutlinedButton(
                            onPressed: () {
                              _handleSignOutCall();
                            },
                            child: const Text(
                              'Sign out',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _handleEditIconClick(BuildContext context, String task) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: Colors.grey[200],
              //form having either email or name field and save button
              child: Form(
                key: _saveNameFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: task == CHANGING_NAME
                          //name field
                          ? TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Name",
                                hintText: "e.g John Doe",
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
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
                            )
                          //email field
                          : TextFormField(
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
                    ),
                    const SizedBox(height: 10),
                    //save buttton
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: ButtonTheme(
                        minWidth: 100,
                        child: OutlinedButton(
                          onPressed: () async {
                            if (_saveNameFormKey.currentState!.validate()) {
                              _saveNameFormKey.currentState!.save();
                              _dialog.show();

                              if (task == CHANGING_NAME &&
                                  await _authController.changeName(
                                      _name, _scaffoldKey)) {
                                resetProfileScreen();
                              } else if (task == CHANGING_EMAIL &&
                                  await _authController.changeEmail(
                                      _email, _scaffoldKey)) {
                                resetProfileScreen();
                              } else {
                                _dialog.hide();
                              }
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void resetProfileScreen() {
    setState(() {
      _getLoginStatus();
      _getTokenValidity();
    });
    _saveNameFormKey.currentState!.reset();
    Navigator.pop(context);
    _dialog.hide();
  }

  _handleSignOutCall() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          //Confirm sign out button
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: OutlinedButton(
              onPressed: () async {
                _dialog.show();
                await _authController.deleteUserDataAndLoginStatus();
                _dialog.hide();
                Navigator.pushReplacementNamed(context, ProductList.id);
              },
              child: const Text(
                'Confirm sign out',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          );
        });
  }
}
