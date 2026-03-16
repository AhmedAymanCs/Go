import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/core/constants/string_manager.dart';
import 'package:go/features/auth/data/repository/auth_repository.dart';
import 'package:go/features/auth/presentation/login/logic/states.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super(LoginState());

  void changePasswordVisible() {
    emit(state.copyWith(passwordObscure: !state.passwordObscure));
  }

  void changeRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<void> login({required String email, required String password}) async {
    final bool isValid = validator(email: email, password: password);
    if (isValid) {
      emit(state.copyWith(status: FormLoading()));
      final userCredential = await _authRepository.login(
        email: email,
        password: password,
        rememberMe: state.rememberMe,
      );
      userCredential.fold((r) => emit(LoginState(status: FormFailure(r))), (l) {
        emit(LoginState(status: FormSuccess(l)));
      });
    }
  }

  bool validator({required String email, required String password}) {
    if (email.trim().isEmpty) {
      emit(state.copyWith(status: FormFailure(StringManager.emailHint)));
      return false;
    } else if (password.trim().isEmpty) {
      emit(state.copyWith(status: FormFailure(StringManager.passwordHint)));
      return false;
    } else {
      return true;
    }
  }
}
