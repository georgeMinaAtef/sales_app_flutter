import 'package:equatable/equatable.dart';
import 'package:sales_app/core/models/category_model.dart';

import '../../../../../core/models/product_model.dart';

class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];

}


final class ProductsInitial extends ProductsState {}

class ProductImagePickedSuccessState extends ProductsState {}

class ProductAddingLoading extends ProductsState {}

class ProductAddingSuccess extends ProductsState {}

class ProductAddingError extends ProductsState {
  final String error;

  const ProductAddingError(this.error);
}



class CategoryLoadedSuccess extends ProductsState {
  final List<CategoryModel> categories;


  const CategoryLoadedSuccess(this.categories);

  @override
  List<Object> get props => [categories];
}





class ProductLoading extends ProductsState {}



class ProductError extends ProductsState {
  final String errorMessage;

  const ProductError(this.errorMessage);
}


class ProductLoadedSuccess extends ProductsState {
  final List<ProductModel> products;
  const ProductLoadedSuccess(this.products);
  @override
  List<Object> get props => [products];
}


// Products
class SearchInitialState extends ProductsState {}

class SearchLoadingStates extends ProductsState {}

class SearchNotFoundStates extends ProductsState {}

class SearchSuccessStates extends ProductsState {
  final List<ProductModel> products;

  const SearchSuccessStates(this.products);
}

class SearchErrorStates extends ProductsState {}


class UpdateLoadingStates extends ProductsState {}

class UpdateSuccessStates extends ProductsState {}


class UpdateErrorStates extends ProductsState {
  final String error;
  const UpdateErrorStates({required this.error});
}




class DeleteSuccessStates extends ProductsState {}


class DeleteErrorStates extends ProductsState {
  final String error;
  const DeleteErrorStates({required this.error});
}


