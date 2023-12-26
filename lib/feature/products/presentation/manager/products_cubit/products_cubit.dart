
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_app/Core/utils/functions/show_snack_bar.dart';
import 'package:sales_app/core/models/product_model.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_state.dart';

import '../../../../../core/utils/functions/show_toast.dart';

class ProductsCubit extends Cubit<ProductsState> {


  ProductsCubit() : super(ProductsInitial());


  static ProductsCubit get(context) => BlocProvider.of(context);


  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  void updateProduct({
    required double price,
    required int quantity,
    required String title,
    required String id,
    required String category,
    required String description,
  }) async {
    try {
      emit(UpdateLoadingStates());
      await FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .update({
        'title': title,
        // 'image': product.image,
        'category': category,
        'description': description,
        'price': price,
        'quantity': quantity,
      }).then((value)
      {
        showToast(
          message: 'Update Product Successfully',
        );
        emit(UpdateSuccessStates());
      });

    } catch (e)
    {
      emit(UpdateErrorStates(error: e.toString()));
      showToast(
        message: 'Error when update product ${e.toString()}',
      );
    }
  }




  void deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete().then((value)
      {
        showToast(
          message: 'Delete Product Successfully',
        );
        emit(DeleteSuccessStates());
      });

    } catch (e) {
      // showToast(message: ' Error When Delete Product ${e.toString()}',);
      emit(DeleteErrorStates(error: e.toString()));
    }
  }




  void searchProductsByName({required String nameProduct}) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('title', isGreaterThanOrEqualTo: nameProduct)
          .get();

      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        emit(SearchLoadingStates());

        return ProductModel(
          uId: doc.id,
          title: data['title'],
          image: data['image'] ,
          category: data['category'],
          description: data['description'],
          price: data['price'].toDouble(),
          quantity: data['quantity'].toInt(),
        );
      }).toList();


      emit(SearchSuccessStates(products));
    } catch (error) {
      emit(SearchErrorStates());
    }
  }




  Future<void> addProduct({required ProductModel productModel}) async {
    String productId = FirebaseFirestore.instance.collection('products').doc().id;
    String imageUrl = await uploadImage(productId, imageFile!);

    try {
      final newProduct = {
        'title': productModel.title,
        'price': productModel.price,
        'description': productModel.description,
        'category': productModel.category,
        'quantity': productModel.quantity,
        'image': imageUrl,
      };

      // Check if a product with the same title already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('title', isEqualTo: productModel.title)
          .where('description', isEqualTo: productModel.description)
          .limit(1)
          .get();


      if (querySnapshot.docs.isEmpty) {
        // No duplicate product found, add the new product
        emit(ProductAddingLoading());
     await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .set(newProduct);
        emit(ProductAddingSuccess());
      } else {
        // Duplicate product found, handle accordingly
        emit(const ProductAddingError('Product already exists.'));
      }
    } catch (e) {
      emit(ProductAddingError(e.toString()));
    }
  }




  Stream<List<ProductModel>> getProducts() async* {
    try {
      emit(ProductLoading());

      var products = await FirebaseFirestore.instance.collection('products').get() ;

      emit(ProductLoadedSuccess(products as List<ProductModel> ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }




  File? imageFile;


  Future<String> uploadImage(String productId, File imageFile) async {
    try {
      // Create a reference to the image location in Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child(
          'product_images/$productId.jpg');

      // Upload the image file to Firebase Storage
      TaskSnapshot snapshot = await storageReference.putFile(imageFile);

      // Get the download URL of the uploaded image
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }





  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {

      imageFile = File(pickedImage.path);
      emit(ProductImagePickedSuccessState());
    }
  }



}
