import 'dart:convert';

import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String? uId;
  late String title;
  late String category;
  late double price;
  late int quantity;
  late String description;
  final String? image;


   ProductModel({
    this.uId,
    required this.title,
    required this.category,
    required this.price,
    required this.quantity,
    required this.description,
    this.image,

  });

  factory ProductModel.fromMap(Map<String, dynamic> data) => ProductModel(
    uId: data['uId'] as String?,
    title: data['title'] as String,
    category: data['category'] as String,
    price: data['price'] as double,
    quantity: data['quantity'] as int,
    description: data['description'] as String,
    image: data['image'] as String?,

  );


  Map<String, dynamic> toMap() => {
    'uId': uId,
    'title': title,
    'category': category,
    'price': price,
    'quantity': quantity,
    'description': description,
    'image': image,

  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserModel].
  factory ProductModel.fromJson(String data) {
    return ProductModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
    uId,
    title,
    category,
    price,
    quantity,
    description,
    image,

  ];

  // to string
  @override
  String toString() {
    return 'UserModel{uId: $uId, title: $title, category: $category, price: $price, quantity: $quantity, description: $description, image: $image,}';
  }
}
