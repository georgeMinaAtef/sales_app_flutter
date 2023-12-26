
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sales_app/Core/utils/functions/show_snack_bar.dart';
import 'package:sales_app/Core/utils/my_colors.dart';
import 'package:sales_app/Core/utils/styles.dart';
import 'package:sales_app/core/utils/functions/show_toast.dart';

import '../../manager/cart_cubit/cubit.dart';
import '../../manager/cart_cubit/state.dart';

class CartView extends StatelessWidget {
  CartView({super.key});

  double totalPrice = 0;
  int countHero = 0;
  List<int> quantities = [];

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
                children:[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                               Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Cart",
                                    style: Styles.textStyle20,
                                  ),
                                ),
                              ),
                              BlocConsumer<CartCubit, CartState>(
                                listener: (BuildContext context, CartState state) {  },
                                builder: (context, cartProvider) {
                                  return badges.Badge(
                                    position: badges.BadgePosition.bottomEnd(
                                        bottom: 1, end: 1),
                                    badgeContent: Text(
                                      state.items.length.toString(),
                                    ),
                                    child: IconButton(
                                      // color: Colors.white,
                                      icon: const Icon(Icons.add_shopping_cart),
                                      iconSize: 25,
                                      onPressed: ()
                                      {

                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,

                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 80, top: 20),
                    margin: const EdgeInsets.only(top: 70),
                    decoration:  BoxDecoration(
                        color: MyColors.mySteelBlue.withOpacity(.4),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(

                      children: [

                        if(state.items.isEmpty)
                          Expanded(
                              flex:5,
                              child: Center(
                                  child: Text(
                                    'Cart is empty',
                                    style: Styles.textStyle20
                                  ))),

                        if(state.items.isNotEmpty)
                          Expanded(
                            flex: 5,
                            child: ListView.builder(

                              itemCount: state.items.length,

                              itemBuilder: (context, index) {
                                final product = state.items[index];
                                // final checkoutCubit = context.read<CheckoutCubit>();

                                return  Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 160,
                                          child: ClipRRect(
                                              borderRadius:  BorderRadius.circular(12),
                                              child: Placeholder(child: Image.network(product.image.toString() , fit: BoxFit.fill,))),
                                        ),
                                      ) ,


                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 4),
                                                child: Text('Title: ${product.title}', style: Styles.textStyle20),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8,bottom: 8),
                                                child: Text('Price: ${product.price.toStringAsFixed(2)} \$'),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(top: 8,bottom: 8),
                                                child: Text('All Quantity: ${product.allQuantity} '),
                                              ),


                                              Padding(
                                                padding: const EdgeInsets.only(top: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    const Text('Quantity:  '),

                                                    SizedBox(
                                                      height: 35,
                                                      child: FloatingActionButton(
                                                        heroTag: '${++countHero}',
                                                        onPressed: ()
                                                        {
                                                          final newQuantity = product.quantity - 1;
                                                          if(newQuantity  < 1)
                                                          {
                                                            context.read<CartCubit>().removeItemFromCart(product);
                                                          }
                                                          else
                                                          {
                                                            context
                                                                .read<CartCubit>()
                                                                .updateItemQuantity(product, newQuantity);
                                                            totalPrice = ((product.quantity  ) * product.price);
                                                          }
                                                        },
                                                        child: const Text('-'),
                                                      ),
                                                    ),

                                                    Text('${product.quantity.toInt()}', style: Styles.textStyle20),

                                                    SizedBox(
                                                      height: 35,
                                                      child: FloatingActionButton(
                                                        heroTag: '${++countHero}',
                                                        onPressed: ()
                                                        {
                                                          final newQuantity = product.quantity + 1;
                                                          context
                                                              .read<CartCubit>()
                                                              .updateItemQuantity(product, newQuantity);
                                                          totalPrice = ((product.quantity) * product.price);
                                                        },

                                                        child: const Text('+'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },

                            ),
                          ),


                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<CartCubit>()
                                            .clearCart();
                                      },

                                      child:  Text(
                                        "Clear Cart",
                                        style: Styles.textStyle20,
                                      ),
                                    ),
                                  ],
                                ),

                                const Divider(
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                Row(
                                  children: [
                                    Text(
                                      'Total Price:',
                                      style: Styles.textStyle20
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      ' ${state.totalPrice.toStringAsFixed(2)} \$',

                                      style: Styles.textStyle20
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async
                                    {
                                      final quantities = state.items.map((product) => product.quantity).toList();
                                      await context.read<CartCubit>().updateAllQuantities(quantities,context).then((value)
                                      {
                                        context.read<CartCubit>().clearCart();
                                      });
                                    },

                                    child:  Text('Checkout',
                                        style: Styles.textStyle20),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                ]
            ),
          ),
        );
      },
    );
  }
}

