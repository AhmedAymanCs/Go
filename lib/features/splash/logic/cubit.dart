import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/core/constants/app_constants.dart';
import 'package:go/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:go/core/models/user_model.dart';
import 'package:go/features/splash/logic/states.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit(this._storage) : super(SplashInitialState());

  final SecureStorageHelper _storage;

  void startSplash() async {
    emit(SplashLoadingState());

    try {
      await Future.delayed(const Duration(seconds: 2));
      await getStoredUserSession();
    } catch (error) {
      emit(SplashLoginState());
    }
  }

  Future<void> getStoredUserSession() async {
    try {
      final String? sessionData = await _storage.getData(
        key: AppConstants.userSession,
      );
      if (sessionData != null) {
        final userModel = UserModel.fromJson(jsonDecode(sessionData));
        emit(SplashAuthenticatedState(userModel));
      } else {
        emit(SplashLoginState());
      }
    } catch (e) {
      emit(SplashLoginState());
    }
  }
}
