import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:store/.env.dart';
import 'package:store/controllers/activity_tracker_controller.dart';
import 'package:store/controllers/cart_controller.dart';
import 'package:store/controllers/category_controller.dart';
import 'package:store/controllers/order_controller.dart';
import 'package:store/controllers/product_controller.dart';
import 'package:store/controllers/shipping_controller.dart';
import 'package:store/injection.dart';
import 'package:store/screens/STRIPE_PAYMENT.dart';
import 'package:store/screens/auth_screen.dart';
import 'package:store/screens/change_password.dart';
import 'package:store/screens/order_history.dart';
import 'package:store/screens/payment_method.dart' as pm;
import 'package:store/screens/product_detail.dart';
import 'package:store/screens/products_list.dart';
import 'package:store/screens/profile.dart';
import 'package:store/screens/shipping.dart';
import 'package:store/screens/shopping_cart.dart';
import 'package:store/screens/single_order.dart';
import 'package:store/screens/thank_you.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  //TODO add different orientation
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.grey,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.grey,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductController()),
        ChangeNotifierProvider(create: (context) => CategoryController()),
        ChangeNotifierProvider(create: (context) => CartController()),
        ChangeNotifierProvider(create: (context) => ShippingController()),
        ChangeNotifierProvider(create: (context) => OrderController()),
        ChangeNotifierProvider(create: (context) => ActivityTracker()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sklep',
        theme: exampleAppTheme,
        initialRoute: ProductList.id,
        routes: {
          ProductList.id: (context) => const ProductList(),
          ShoppingCart.id: (context) => const ShoppingCart(),
          ProductDetail.id: (context) => const ProductDetail(),
          Shipping.id: (context) => const Shipping(),
          pm.PaymentMethod.id: (context) => const pm.PaymentMethod(),
          Thanks.id: (context) => Thanks(),
          SingleOrder.id: (context) => const SingleOrder(),
          AuthScreen.id: (context) => const AuthScreen(),
          OrderHistory.id: (context) => const OrderHistory(),
          Profile.id: (context) => const Profile(),
          StripPayment.id: (context) => const StripPayment(),
          ChangePassword.id: (context) => const ChangePassword(),
        },
      ),
    );
  }
}

final exampleAppTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xff6058F7),
    secondary: Color(0xff6058F7),
  ),
  primaryColor: Colors.white,
  appBarTheme: const AppBarTheme(elevation: 1),
);
