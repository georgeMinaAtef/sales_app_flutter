import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../feature/Auth/data/repos/auth_repo_impl.dart';
import '../../feature/Home/data/repos/home_repo_impl.dart';
import '../../feature/Profile/data/repos/edit_profile_repo_impl.dart';
import 'api_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ApiService>(ApiService(Dio()));

  getIt.registerSingleton<AuthRepoImpl>(AuthRepoImpl());

  getIt.registerSingleton<HomeRepoImpl>(HomeRepoImpl());

  getIt.registerSingleton<EditProfileRepoImpl>(EditProfileRepoImpl());

}
