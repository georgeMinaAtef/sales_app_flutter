import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Core/utils/functions/show_snack_bar.dart';
import 'package:sales_app/Core/utils/my_colors.dart';
import 'package:sales_app/Core/widgets/custom_text_form_field.dart';
import 'package:sales_app/core/utils/functions/show_toast.dart';
import 'package:sales_app/core/widgets/custom_loading_widget.dart';
import 'package:sales_app/feature/Auth/presentation/views/widgets/custom_elevated_button.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_state.dart';

import '../../../../../Core/utils/icon_broken.dart';
import '../../../../../core/models/product_model.dart';

class InsertProduct extends StatefulWidget {
  const InsertProduct({super.key});

  @override
  State<InsertProduct> createState() => _InsertProductState();
}

class _InsertProductState extends State<InsertProduct> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleProductController = TextEditingController();
  final TextEditingController _categoryProductController = TextEditingController();
  final TextEditingController _priceProductController = TextEditingController();
  final TextEditingController _quantityProductController = TextEditingController();
  final TextEditingController _descriptionProductController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleProductController.dispose();
    _categoryProductController.dispose();
    _priceProductController.dispose();
    _quantityProductController.dispose();
    _descriptionProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Insert Product'),
      ),
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state)
        {

           if (state is ProductAddingSuccess )
          {
            showToast(message:  'Product added successfully!', backgroundColor: MyColors.myBlack);
            _titleProductController.clear();
            _quantityProductController.clear();
            _priceProductController.clear();
            _categoryProductController.clear();
            _descriptionProductController.clear();
            ProductsCubit.get(context).imageFile = null;

          }
          else if (state is ProductAddingError) {
            showSnackBar(context, 'Failed to add product: ${state.error}');

          }

        },
        builder: (context, state)
        {
          ProductsCubit cubit = ProductsCubit.get(context);

          if (state is ProductAddingLoading  || state is ProductLoading)
          {
            return const Center(
              child: CustomLoadingWidget(),
            );
          }
           else
           {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 20),

                      CustomTextFormField(
                        controller: _titleProductController,
                        labelText: 'Title',
                        prefixIcon: const Icon(IconBroken.Category),
                        validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return  'Title Must Equal Null';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _priceProductController,
                        textInputType: TextInputType.number,
                        validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return  'Price Must Equal Null';
                          }
                          return null;
                        },
                        labelText: 'Price',
                        prefixIcon: const Icon(IconBroken.Calendar),
                        // validatorMessage: 'Bio is required',
                      ),  const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _categoryProductController,
                        labelText: 'Category',
                        validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return  'Category Must Equal Null';
                          }
                          return null;
                        },
                        prefixIcon: const Icon(IconBroken.Category),
                        // validatorMessage: 'Bio is required',
                      ),

                      const SizedBox(height: 20),

                      CustomTextFormField(
                        controller: _quantityProductController,
                        validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return  'Quantity Must Equal Null';
                          }
                          return null;
                        },
                        textInputType: TextInputType.number,
                        labelText: 'Quantity',
                        prefixIcon: const Icon(IconBroken.Calendar),
                        // validatorMessage: 'Phone Number is required',
                      ),

                      const SizedBox(height: 20),

                      CustomTextFormField(
                        controller: _descriptionProductController,
                        labelText: 'Description',
                        validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return  'Description Must Equal Null';
                          }
                          return null;
                        },
                        prefixIcon: const Icon(IconBroken.Category),
                        // validatorMessage: 'Phone Number is required',
                      ),

                      const SizedBox(height: 20.0),


                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          text: 'Select Image',
                          onPressed: () async
                          {
                            await cubit.selectImage();
                          },
                        ),
                      ),


                      if (cubit.imageFile != null) ...[
                        const Center(child: SizedBox(height: 8.0)),
                        Image.file(cubit.imageFile!),
                      ],


                      const SizedBox(height: 40.0),



                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          text: 'Insert Random Product',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final Random random = Random();

                              cubit.addProduct(
                                productModel: ProductModel(
                                  description: _descriptionProductController.text,
                                  price: random.nextDouble() * 100, // Generating a random double between 0 and 100
                                  category: _categoryProductController.text,
                                  quantity: random.nextInt(100), // Generating a random integer between 0 and 100
                                  title: _titleProductController.text,
                                  image: cubit.imageFile!.path,
                                  uId: random.toString(),
                                ),
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 20.0),


                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
