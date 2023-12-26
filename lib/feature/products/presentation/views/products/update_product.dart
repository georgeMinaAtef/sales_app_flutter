
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/Core/widgets/custom_text_form_field.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_state.dart';
import 'package:sales_app/feature/products/presentation/views/products/get_products_view.dart';

import '../../../../../Core/utils/app_router.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../Auth/presentation/views/widgets/custom_elevated_button.dart';


class UpdateProduct extends StatelessWidget {
  UpdateProduct({super.key,   required this.product});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late ProductModel product ;



  @override
  Widget build(BuildContext context) {
    _nameController.text = product.title;
    _descriptionController.text = product.description;
    _categoryController.text = product.category;
    _priceController.text = product.price.toString();
    _quantityController.text = product.quantity.toString();
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state)
      {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                       height: 260,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: product.image!,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),


                    const Padding(
                      padding: EdgeInsets.only(bottom: 5,top: 15),
                      child: Text('product title ', style: TextStyle(fontSize: 20),),
                    ),

                    CustomTextFormField(
                      controller: _nameController   ,
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Title must not null';
                        }

                      },

                    ),



                    const Padding(
                      padding: EdgeInsets.only(bottom: 5,top: 15),
                      child: Text('product category ', style: TextStyle(fontSize: 20),),
                    ),

                    CustomTextFormField(
                      controller: _categoryController,
                      // hint: product.category,
                      validator: (value){
                        if(value!.isEmpty)
                        {

                          return "Category must not be empty";
                        }

                      },

                    ),



                    const Padding(
                      padding: EdgeInsets.only(bottom: 5,top: 15),
                      child: Text('product price ', style: TextStyle(fontSize: 20),),
                    ),
                    CustomTextFormField(
                      controller: _priceController,
                      // hint:product.price.toString(),
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Price must not null';
                        }

                      },

                    ),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 5,top: 15),
                      child: Text('product quantity ', style: TextStyle(fontSize: 20),),
                    ),
                    CustomTextFormField(
                      controller: _quantityController,
                      // hint: ' ${product.quantity.toString()}',
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return "Quantity must not be empty";
                        }

                      },

                    ),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 5,top: 15),
                      child: Text('product description ', style: TextStyle(fontSize: 20),),
                    ),
                    CustomTextFormField(
                      controller: _descriptionController,
                      // hint: ' ${product.description}',
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return "Description must not be empty";
                        }

                      },

                    ),


                    const SizedBox(height: 40.0),


                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomElevatedButton(
                        text: 'Update Product',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            {

                              ProductsCubit.get(context).updateProduct(
                                title: _nameController.text,
                                category: _categoryController.text,
                                description: _descriptionController.text,
                                quantity: int.parse(_quantityController.text),
                                price: double.parse(_priceController.text),
                                id: product.uId!,
                              );

                              Navigator.of(context).pop();
                              // GoRouter.of(context).pushReplacement(AppRouter.getProductsView);

                            }
                          }
                        }
                      ),
                    ),


                    const SizedBox(height: 16.0),


                    // Expanded(
                    //   child: _buildProductList(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
