import 'dart:convert';



List<Product> productFromJson(dynamic responseJsonStr) => List<Product>.from(
    responseJsonStr.map<Product>((dynamic i) => Product.fromJson(i)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.details,
    required this.v,
  });

  String id;
  String name;

  //todo can be null maybe?
  //todo price might need to be changed into double
  int price;
  String imageUrl;
  String category;
  String details;
  int v;

  factory Product.empty() => Product(
      id: '0',
      name: 'name',
      price: 20,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/store-b2244.appspot.com/o/Mosqiuto2.png?alt=media&token=6d6513f5-a3c5-4eaf-a6f5-cd4a856b9f6e',
      category: 'category',
      details: 'details',
      v: 1);
//todo delteted __ from json raw strings
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        imageUrl: json["imageUrl"],
        category: json["category"],
        details: json["details"],
        v: json["v"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "imageUrl": imageUrl,
        "category": category,
        "details": details,
        "v": v,
      };
}
