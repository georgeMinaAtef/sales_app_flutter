import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/utils/app_router.dart';
import '../../../Auth/presentation/views/widgets/custom_elevated_button.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: CustomElevatedButton(
                text: 'Get Products',
                onPressed: () =>
                    GoRouter.of(context).push(AppRouter.getProductsView),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CustomElevatedButton(
                text: 'Insert Products',
                onPressed: () =>
                    GoRouter.of(context).push(AppRouter.insertProduct),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CustomElevatedButton(
                text: 'Search Products',
                onPressed: () =>
                    GoRouter.of(context).push(AppRouter.searchProductsView),
              ),
            ),





          ],
        ),
      ),
    );
  }
}

