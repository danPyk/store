# Ecommerce App based on Nehemiah Kamolu app: https://github.com/KNehe/Ecommerce_app/blob/master/README.md

- An ecommerce app built using Flutter

- To run open terminal and execute ```flutter run```

## Sample Screenshots

<table>
  <tr>
    <td><img src="/../screenshots/productList.png" width=270 height=480></td>
    <td><img src="/../screenshots/shoppingCart.png" width=270 height=480></td>
  </tr>
 </table>



## Features

- View products
- View product details
- Add to cart
- Increase or decrease item's quantity
- Save cart if user is logged in
- Payment using paypal and stripe
- Prompt user to continue as guest or sign in - if not logged in or when login session has expired
- Ask user to login in if they want to view order history or profile
  and they haven't signed-in or login session has expired
- Can then view single order history
- Product list page reload with refresh indicator
- Log out
- Can view single order history after successful order
- Checkout
- Search by name or category
- View products by category

## Note

- To test payment using stripe(Credit card) You'll have to go to [stripe dashboard](https://dashboard.stripe.com/) and pick your
  ```client secret```.
  Open ``` lib/services/stripe.service.dart ```.
  Include it on line 16 ``` static String secret = 'your-secret'; ```.
  If you don't the payment process will always get cancelled. You don't have to do this for paypal as it is handled fully by the API.
  It has been tested and works fine with secret added. I removed mine for security reasons. I'm working on a way of including it from backend coupled with encryption so that you don't have to insert your on secret inorder to test the feature. As that is in the pipeline please follow the above mentioned steps.

- This app has been developed on windows and tested on only android using ```Flutter 1.22.4 • channel stable``` and ```  Dart 2.10.4 ```
