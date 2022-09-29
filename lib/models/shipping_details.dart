class ShippingDetails {
  ShippingDetails({
    required this.id,
    required this.name,
    required this.phoneContact,
    required this.addressLine,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  String id;
  String name;
  String phoneContact;
  String addressLine;
  String city;
  String postalCode;
  String country;

  factory ShippingDetails.empty() =>
      ShippingDetails(id: '',
          name: 'name',
          phoneContact: 'phoneContact',
          addressLine: 'addressLine',
          city: 'city',
          postalCode: 'postalCode',
          country: 'country');

  factory ShippingDetails.fromJson(Map<String, dynamic> json) =>
      ShippingDetails(
        id: json["id"],
        name: json["name"],
        phoneContact: json["phoneContact"],
        addressLine: json["addressLine"],
        city: json["city"],
        postalCode: json["postalCode"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "phoneContact": phoneContact,
        "addressLine": addressLine,
        "city": city,
        "postalCode": postalCode,
        "country": country,
      };
}
