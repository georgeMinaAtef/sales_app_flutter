import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/Core/utils/functions/show_snack_bar.dart';
import 'package:sales_app/Core/utils/icon_broken.dart';
import 'package:sales_app/Core/widgets/custom_text_form_field.dart';
import 'package:sales_app/core/models/cart_model.dart';
import 'package:sales_app/core/widgets/custom_loading_widget.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_state.dart';
import 'package:sales_app/feature/products/presentation/views/products/update_product.dart';

import '../../../../../Core/utils/app_router.dart';
import '../../../../../Core/utils/styles.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/utils/functions/show_toast.dart';
import '../../manager/cart_cubit/cubit.dart';



class SearchProductsView extends StatelessWidget {
  SearchProductsView({super.key});


  final _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: Styles.textStyle20,
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
      
        create: (context) => ProductsCubit(),
      
        child: BlocConsumer<ProductsCubit,ProductsState>(
          listener: (context, state) {},
          builder: (context, state)
          {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: CustomTextFormField(
                                controller: _searchController,
                                onChange: (val) {
                                  val = _searchController.text;
                                  ProductsCubit.get(context)
                                      .searchProductsByName(nameProduct: val);
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Text to get Search';
                                  }
                                  return null;
                                },
                                labelText: 'Search',
                                prefixIcon: const Icon(Icons.search),
                              ),
                            ),
                            Expanded(
                              child: BlocConsumer<ProductsCubit, ProductsState>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  if (state is SearchLoadingStates) {
                                    return const Center(
                                      child: CustomLoadingWidget(),
                                    );
                                  } else if (state is SearchSuccessStates) {
                                    final List<ProductModel> products = state.products
                                        .where((product) =>
                                        product.title
                                            .toLowerCase()
                                            .contains(_searchController.text.toLowerCase()))
                                        .toList();

                                    return GridView.builder(
                                      itemCount: products.length,
                                      gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 3 / 6.5,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 5,
                                      ),
                                      itemBuilder: (context, index) {
                                        final product = products[index];
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              product.image != null
                                                  ? SizedBox(
                                                height: 220,
                                                width: 220,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                  child: Image.network(
                                                    product.image!,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              )
                                                  : const SizedBox(
                                                child: Placeholder(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8),
                                                child: Text('title:  ${product.title} '),
                                              ),
                                              Text(
                                                  'category       :\t\t\t${product.category} '),
                                              Text(
                                                  'price       :\t\t\t${product.price.toDouble().roundToDouble()} \$'),
                                              Text(
                                                  'quantity  :\t\t\t${product.quantity} '),

                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                               children: [
                                                 ElevatedButton(
                                                   onPressed: ()
                                                   {
                                                     Navigator.push(
                                                       context,
                                                       MaterialPageRoute(builder: (context) => UpdateProduct(product: product)),
                                                     );
                                                   },
                                                   child:  const Icon(IconBroken.Edit),
                                                 ),

                                                 ElevatedButton(
                                                   onPressed: ()
                                                   {
                                                     ProductsCubit.get(context).deleteProduct(product.uId!);
                                                     if(state is DeleteErrorStates)
                                                     {
                                                       showSnackBar(context,'Error When Delete Product');
                                                     }
                                                   },
                                                   child:  const Icon(IconBroken.Delete),
                                                 ),
                                               ],
                                             ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else if (state is SearchErrorStates) {
                                    return const Center(
                                      child: Text(
                                          'Error occurred while searching for products.'),
                                    );
                                  } else {
                                    ProductsCubit.get(context)
                                        .searchProductsByName(nameProduct: _searchController.text);
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  showSnackBar(context, 'Failed to fetch products');
                  return const Text('Failed to fetch products');
                } else {
                  return const Center();
                }
              },
            );
          },
        ),
      ),
    );
  }



}
