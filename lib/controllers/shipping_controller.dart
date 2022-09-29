import 'package:store/models/shipping_details.dart';
import 'package:flutter/foundation.dart';

class ShippingController extends ChangeNotifier {
  //todo might added emopty ids x2
  var shippingDetails = ShippingDetails.empty();

  void setShippingDetails({required ShippingDetails details}) {
    shippingDetails = details;
    notifyListeners();
  }

  ShippingDetails getShippingDetails() => shippingDetails;

  void reset() {
    shippingDetails = ShippingDetails(
      name: '',
      phoneContact: '',
      city: '',
      addressLine: '',
      postalCode: '',
      country: '', id: '',
    );
  }
}
