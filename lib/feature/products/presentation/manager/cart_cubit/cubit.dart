

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Core/utils/functions/show_snack_bar.dart';
import 'package:sales_app/Core/utils/my_colors.dart';
import 'package:sales_app/core/models/cart_model.dart';
import 'package:sales_app/feature/products/presentation/manager/cart_cubit/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/functions/show_toast.dart';


class CartCubit extends Cubit<CartState> implements StateStreamable<CartState> {
  CartCubit() : super(CartState([], 0));


  Future<void> fetchCartData() async {
    // Fetch cart data from a repository or any other source
    // For example, you can fetch it from SharedPreferences as shown in your code

    try {
      final preferences = await SharedPreferences.getInstance();
      final cartDataString = preferences.getString('cartData');

      if (cartDataString != null) {
        final cartData = json.decode(cartDataString) as List<dynamic>;

        // Convert the decoded data to a list of CartModel
        final List<CartModel> cartItems =
        cartData.map((data) => CartModel.fromMap(data)).toList();

        // Calculate the total price
        final totalPrice = calculateTotalPrice(cartItems);

        // Emit the state with the fetched data
        emit(CartState(cartItems, totalPrice));
      }
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching cart data: $e');
    }
  }

  void addItemToCart(CartModel item) async {
    final updatedItems = List<CartModel>.from(state.items);

    // Check if the item already exists in the cart
    final existingIndex = updatedItems.indexWhere((cartItem) =>
    cartItem.id == item.id);

    // If the item already exists, you can choose to update its quantity or ignore it
    if (existingIndex != -1) {
      final existingItem = updatedItems[existingIndex];
      // Update the existing item's quantity or perform other required actions
      // Example: existingItem.quantity += item.quantity;

      // Update the total price
      final totalPrice = calculateTotalPrice(updatedItems);
      emit(CartState(updatedItems, totalPrice));

      // Save the updated cart data
      saveCartData(updatedItems);
      return;
    }

    // If the item is not found, add it to the cart
    updatedItems.add(item);

    // Update the total price
    final totalPrice = calculateTotalPrice(updatedItems);
    emit(CartState(updatedItems, totalPrice));

    // Save the updated cart data
    saveCartData(updatedItems);
  }

// Save the updated cart data to persistent storage
  Future<void> saveCartData(List<CartModel> updatedItems) async {
    // You can use local storage, SQLite, or any other storage solution to save the cart data
    // For example, using shared_preferences package for local storage
    // You'll need to modify this based on your chosen storage solution
    // This is just a basic example using shared_preferences

    // Convert the list of CartModel to a list of Map<String, dynamic>
    final List<Map<String, dynamic>> cartData = updatedItems.map((item) =>
        item.toMap()).toList();

    // Save the cart data to local storage
    // Note: Make sure to handle errors appropriately
    // Also, consider using a more robust storage solution for production
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('cartData', json.encode(cartData));
  }


  void clearCart() async {
    // Clear the cart items in the state
    final updatedItems = List<CartModel>.from(state.items);
    updatedItems.clear();

    // Clear the cart data from SharedPreferences
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('cartData');

    // Update the state with the cleared cart
    emit(CartState(updatedItems, 0));
  }


  Future<void> updateAllQuantities(List<int> quantities, BuildContext context) async {
    try {
      final productIds = state.items.map((CartModel product) => product.id).toList();

      await Future.wait(productIds.map((productId) {
        final index = productIds.indexOf(productId);
        final quantity = quantities[index];

        return FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .update({'quantity': FieldValue.increment(-quantity)})
            .then((_) {
          showToast(
            backgroundColor: MyColors.myBlack,
            message:'Update Product Successfully',
          );
        });
      }));
    } catch (e)  {
      showSnackBar(
        context,
        'Error when updating products: ${e.toString()}',
      );
    }
  }


  void removeItemFromCart(CartModel item) {
    final updatedItems = List<CartModel>.from(state.items);
    updatedItems.remove(item);
    final totalPrice = calculateTotalPrice(updatedItems);
    emit(CartState(updatedItems, totalPrice));
  }


  void updateItemQuantity(CartModel item, int newQuantity) {
    final updatedItems = List<CartModel>.from(state.items);
    final index = updatedItems.indexOf(item);

    if (index != -1 && newQuantity <= item.allQuantity) {
      item.quantity = newQuantity;
      updatedItems[index] = item;
    }

    final totalPrice = calculateTotalPrice(updatedItems);

    emit(CartState(updatedItems, totalPrice));
  }


  double calculateTotalPrice(List<CartModel> items) {
    return items.fold(
        0, (total, product) => total + (product.price * product.quantity));
  }


}