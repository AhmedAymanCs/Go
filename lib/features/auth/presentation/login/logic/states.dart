import 'package:equatable/equatable.dart';
import 'package:go/core/models/user_model.dart';

abstract class FormStatus extends Equatable {
  const FormStatus();
}

class LoginState extends Equatable {
  final bool passwordObscure;
  final bool rememberMe;
  final FormStatus status;

  const LoginState({
    this.passwordObscure = true,
    this.rememberMe = false,
    this.status = const FormInitial(),
  });

  LoginState copyWith({
    bool? passwordObscure,
    bool? rememberMe,
    FormStatus? status,
  }) {
    return LoginState(
      passwordObscure: passwordObscure ?? this.passwordObscure,
      rememberMe: rememberMe ?? this.rememberMe,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [passwordObscure, rememberMe, status];
}

class FormInitial extends FormStatus {
  const FormInitial();

  @override
  List<Object?> get props => [];
}

class FormLoading extends FormStatus {
  const FormLoading();

  @override
  List<Object?> get props => [];
}

class FormSuccess extends FormStatus {
  final UserModel userModel;
  const FormSuccess(this.userModel);
  @override
  List<Object?> get props => [userModel];
}

class FormFailure extends FormStatus {
  final String message;

  const FormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
