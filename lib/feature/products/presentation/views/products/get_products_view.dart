import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Core/utils/functions/show_snack_bar.dart';
import 'package:sales_app/core/widgets/custom_loading_widget.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_state.dart';
import 'package:sales_app/feature/products/presentation/views/products/update_product.dart';
import '../../../../../Core/utils/icon_broken.dart';
import '../../../../../core/models/product_model.dart';



class GetProductsView extends StatelessWidget {
  const GetProductsView({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (state is DeleteSuccessStates) {
              // Schedule the showSnackBar after the build is complete
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                ProductsCubit.get(context).getProducts();
                showSnackBar(context, 'Item Deleted Successfully');
              });
            } else if (state is DeleteErrorStates) {
              // Schedule the showSnackBar after the build is complete
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                showSnackBar(context, 'Error When Deleting Item: ${state.error}');
              });
            }

            if (snapshot.hasData) {
              final products = snapshot.data!.docs.map<ProductModel>((productDoc) {
                final productData = productDoc.data() as Map<String, dynamic>;
                return ProductModel(
                  title: productData['title'] ??'',
                  category: productData['category']??'',
                  price: (productData['price'] as num?)?.toDouble().roundToDouble() ?? 0.0,
                  quantity: (productData['quantity'] as num?)?.toInt() ?? 0,
                  image: productData['image'] ??'',
                  uId: productData['uId'] ?? '',
                  description: productData['description']??'',
                );
              }).toList();

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Get Products'),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Description')),
                    ],
                    rows: products.map<DataRow>((product) {
                      return DataRow(
                        cells: [
                          DataCell(Text(product.title)),
                          DataCell(Text('${product.category} ')),
                          DataCell(Text('${product.price} \$')),
                          DataCell(Text('${product.quantity}')),
                          DataCell(Text(product.description,maxLines: 2, overflow: TextOverflow.ellipsis,)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Failed to fetch products');
            } else {
              return const Center();
            }
          },
        );
      },
    );


  }


}
