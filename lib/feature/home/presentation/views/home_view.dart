import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../Core/utils/icon_broken.dart';
import '../manager/home_cubit/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    getUserData();
    getAllUsers();
  }

  getAllUsers() async {
    await BlocProvider.of<HomeCubit>(context).getAllUsers();
  }

  getUserData() async {
    await BlocProvider.of<HomeCubit>(context).getUserData();
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: BlocProvider.of<HomeCubit>(context)
                .views[BlocProvider.of<HomeCubit>(context).currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Category),
                label: 'Details',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Setting),
                label: 'Settings',
              ),
            ],
            currentIndex: BlocProvider.of<HomeCubit>(context).currentIndex,
            onTap: (value) {
              BlocProvider.of<HomeCubit>(context)
                  .changeBottomNavBarState(value);
            },
          ),
        );
      },
    );
  }
}
