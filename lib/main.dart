
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/feature/products/presentation/manager/cart_cubit/cubit.dart';
import 'package:sales_app/feature/products/presentation/manager/products_cubit/products_cubit.dart';
import 'Core/utils/app_router.dart';
import 'Core/utils/cache_network.dart';
import 'Core/utils/constants.dart';
import 'Core/utils/my_colors.dart';
import 'core/utils/service_locator.dart';
import 'feature/Home/data/repos/home_repo_impl.dart';
import 'feature/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'firebase_options.dart';



void main() async {
  setupServiceLocator();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheNetwork.cacheInitialization();
  uId = await CacheNetwork.getCacheData(key: 'uId');
  if (uId != null) {
    await getIt.get<HomeRepoImpl>().getUserData();
    // await getIt.get<ProductsRepoImpl>();
  }
  runApp(
    // DevicePreview(
    //   builder: (context) => const SocialApp(),
    // ),
    const SocialApp(),
  );
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(getIt.get<HomeRepoImpl>()),
        ),
        BlocProvider(
          create: (context) => ProductsCubit()..getProducts(),
        ),
        BlocProvider(
          create: (context) => CartCubit(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        builder: DevicePreview.appBuilder,
        routerConfig: AppRouter.router,
        theme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white60,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.mySteelBlue,
            ),
          ),
          appBarTheme: const AppBarTheme(

            titleSpacing: 20,
            // iconTheme: IconThemeData(
            //   color: Colors.white,
            // ),
            // titleTextStyle: TextStyle(
            //   color: Colors.white,
            //   fontSize: 20,
            //   fontWeight: FontWeight.bold,
            // ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: MyColors.myDarkCerulean,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: MyColors.myDarkCerulean,
            elevation: 0,
          ),

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: MyColors.myAquamarine,
            elevation: 1,
            backgroundColor: MyColors.myDarkCerulean,
          ),
          scaffoldBackgroundColor: MyColors.myDarkCerulean,
        ),
      ),
    );
  }
}
