import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/core/utils/service_locator.dart';
import 'package:sales_app/feature/products/presentation/manager/cart_cubit/cubit.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:sales_app/feature/products/presentation/views/cart/cart_view.dart';
import 'package:sales_app/feature/products/presentation/views/products/get_products_view.dart';
import 'package:sales_app/feature/products/presentation/views/products/insert_product_view.dart';
import 'package:sales_app/feature/products/presentation/views/products/search_product_view.dart';
import '../../feature/Auth/data/repos/auth_repo_impl.dart';
import '../../feature/Auth/presentation/manager/login_cubit/login_cubit.dart';
import '../../feature/Auth/presentation/manager/register_cubit/register_cubit.dart';
import '../../feature/Auth/presentation/views/login_view.dart';
import '../../feature/Auth/presentation/views/register_view.dart';
import '../../feature/Home/presentation/views/home_view.dart';
import '../../feature/Profile/data/repos/edit_profile_repo_impl.dart';
import '../../feature/Profile/presentation/manager/profile_cubit/profile_cubit.dart';
import '../../feature/Profile/presentation/views/edit_profile_view.dart';
import '../../feature/Splash/presentation/views/splash_view.dart';
import 'constants.dart';

abstract class AppRouter {
  static const kSplashView = '/';
  static const kLoginView = '/loginView';
  static const kRegisterView = '/registerView';
  static const kHomeView = '/homeView';
  static const kAfterSplashView = '/afterSplashView';
  static const kEditProfileView = '/editProfileView';
  static const productsView = '/productsView';
  static const insertProduct = '/insertProduct';
  static const cartView = '/cartView';
  static const getProductsView = '/getProductsView';
  static const searchProductsView = '/searchProductsView';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: kLoginView,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(getIt.get<AuthRepoImpl>()),
          child: const LoginView(),
        ),
      ),


      GoRoute(
        path: searchProductsView,
        builder: (context, state) => BlocProvider(
          create: (context) => ProductsCubit(),
          child:  SearchProductsView(),
        ),
      ),

      GoRoute(
        path: getProductsView,
        builder: (context, state) => BlocProvider(
          create: (context) => ProductsCubit()..getProducts(),
          child:  GetProductsView(),
        ),
      ),


      GoRoute(
        path: cartView,
        builder: (context, state) {
          // Create the CartCubit and let it handle the initial data fetching
          final cartCubit = CartCubit()..fetchCartData();

          return BlocProvider.value(
            value: cartCubit,
            child: CartView(),
          );
        },
      ),


      GoRoute(
        path: kRegisterView,
        builder: (context, state) => BlocProvider(
          create: (context) => RegisterCubit(getIt.get<AuthRepoImpl>()),
          child: const RegisterView(),
        ),
      ),


      GoRoute(
        path: kHomeView,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ProfileCubit(getIt.get<EditProfileRepoImpl>()),
            ),
          ],
          child: const HomeView(),
        ),
      ),


      GoRoute(
        path: insertProduct,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ProductsCubit(),
            ),
          ],
          child: const InsertProduct(),
        ),
      ),



      GoRoute(
        path: kAfterSplashView,
        builder: (context, state) {
          // check if user is logged in or not
          // if logged in go to home view, else go to login view
          if (uId != null && uId!.isNotEmpty) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      ProfileCubit(getIt.get<EditProfileRepoImpl>()),
                ),
              ],
              child: const HomeView(),
            );
          } else {
            return BlocProvider(
              create: (context) => LoginCubit(getIt.get<AuthRepoImpl>()),
              child: const LoginView(),
            );
          }
        },
      ),


      GoRoute(
        path: kEditProfileView,
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileCubit(getIt.get<EditProfileRepoImpl>()),
          child: const EditProfileView(),
        ),
      ),


    ],
  );
}
