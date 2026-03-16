import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/core/constants/string_manager.dart';
import 'package:go/features/auth/data/repository/auth_repository.dart';
import 'package:go/features/auth/presentation/forget_passoword/logic/states.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  final AuthRepository _authRepository;
  ForgetPasswordCubit(this._authRepository)
    : super(ForgetPasswordInitialState());

  Future<void> forgetPassword(String email) async {
    if (!validateEmail(email)) {
      return;
    } else {
      emit(ForgetPasswordLoadingState());
      final userCredential = await _authRepository.sendPasswordResetEmail(
        email: email,
      );
      userCredential.fold(
        (r) => emit(ForgetPasswordErrorState(r)),
        (l) => emit(ForgetPasswordSuccessState()),
      );
    }
  }

  bool validateEmail(String email) {
    if (email.trim().isEmpty) {
      emit(ForgetPasswordErrorState(StringManager.emailHint));
      return false;
    }
    return true;
  }
}
