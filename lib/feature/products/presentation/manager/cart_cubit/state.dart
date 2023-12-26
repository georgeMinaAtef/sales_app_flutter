import 'package:sales_app/core/models/cart_model.dart';

class CartState {
  final List<CartModel> items;
  final double totalPrice;

  CartState(this.items, this.totalPrice);
}

