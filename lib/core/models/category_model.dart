import 'dart:convert';

import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String? uId;
  late String title;
  late String description;
  final String? image;


   CategoryModel({
    this.uId,
    required this.title,
    required this.description,
    this.image,

  });

  factory CategoryModel.fromMap(Map<String, dynamic> data) => CategoryModel(
    uId: data['uId'] as String?,
    title: data['title'] as String,
    description: data['description'] as String,
    image: data['image'] as String,

  );


  Map<String, dynamic> toMap() => {
    'uId': uId,
    'title': title,
    'description': description,
    'image': image,

  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserModel].
  factory CategoryModel.fromJson(String data) {
    return CategoryModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
    uId,
    title,
    description,
    image,

  ];

  // to string
  @override
  String toString() {
    return 'UserModel{uId: $uId, title: $title,description: $description, image: $image,}';
  }
}
