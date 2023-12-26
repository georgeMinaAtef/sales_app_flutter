import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/feature/Profile/presentation/views/profile_view.dart';
import 'package:sales_app/feature/products/presentation/views/cart/cart_view.dart';
import 'package:sales_app/feature/products/presentation/views/home_details_view.dart';
import 'package:sales_app/feature/products/presentation/views/home_view.dart';
import '../../../../../Core/models/user_model.dart';
import '../../../../../Core/utils/constants.dart';
import '../../../data/repos/home_repo_impl.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepoImpl) : super(HomeInitial());

  final HomeRepoImpl homeRepoImpl;

  List<Widget> views = [  ProductsHomeView(),   CartView(), const ProductsView(), const ProfileView()];

  int currentIndex = 0;

  void changeBottomNavBarState(int index) {
    emit(ChangeBottomNavBarLoadingState());

    currentIndex = index;
    emit(ChangeBottomNavBarSuccessState());
  }

  late List<UserModel> usersModel = [];

  Future<void> getUserData() async {
    emit(GetUserDataLoadingState());

    var result = await homeRepoImpl.getUserData();

    result.fold(
      (failure) =>
          emit(GetUserDataFailureState(errorMessage: failure.errMessage)),
      (userModel) {
        user = userModel;
        emit(GetUserDataSuccessState());
      },
    );
  }

  Future<void> getAllUsers() async {
    emit(GetAllUsersLoadingState());
    var result = await homeRepoImpl.getAllUsers();
    result.fold(
      (failure) =>
          emit(GetAllUsersFailureState(errorMessage: failure.errMessage)),
      (usersModel) {
        users = usersModel;
        this.usersModel = usersModel;
        emit(GetAllUsersSuccessState());
      },
    );
  }
}
