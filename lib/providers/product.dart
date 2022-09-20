import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';


class Product with ChangeNotifier {
  dynamic id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  static Product fromMap (dynamic id,Map<String,dynamic> prod){
    return Product(id: id,
                  title: prod["title"], 
                  description: prod["description"],
                  price: prod["price"],
                  imageUrl: prod["imageUrl"],
                  isFavorite: prod['isFavorite']);

  }

}
