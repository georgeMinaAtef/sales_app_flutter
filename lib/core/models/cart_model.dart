import 'dart:convert';

import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  final String? id;
  late String title;
  late String category;
  late double price;
  late  int quantity;
  late int allQuantity;
  late String description;
  late String? image;


   CartModel({
    this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.allQuantity,
    required this.quantity,
    required this.description,
    this.image,

  });

  factory CartModel.fromMap(Map<String, dynamic> data) => CartModel(
    id: data['id'] as String?,
    title: data['title'] as String,
    category: data['category'] as String,
    price: data['price'] as double,
    quantity: data['quantity'] as int,
    allQuantity: data['allQuantity'] as int,
    description: data['description'] as String,
    image: data['image'] as String?,

  );


  Map<String, dynamic> toMap() => {
    'uId': id,
    'title': title,
    'category': category,
    'price': price,
    'quantity': quantity,
    'allQuantity': allQuantity,
    'description': description,
    'image': image,

  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserModel].
  factory CartModel.fromJson(String data) {
    return CartModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    price,
    quantity,
    allQuantity,
    description,
    image,

  ];

  // to string
  @override
  String toString() {
    return 'UserModel{uId: $id, title: $title, category: $category, price: $price, quantity: $quantity, allQuantity: $allQuantity, image: $image,}';
  }
}
