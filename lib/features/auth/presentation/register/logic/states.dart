import 'package:equatable/equatable.dart';

abstract class FormState extends Equatable {
  const FormState();
}

class RegisterState extends Equatable {
  final bool passwordObscure;
  final FormState status;
  const RegisterState({
    this.passwordObscure = true,
    this.status = const FormInitial(),
  });

  RegisterState copyWith({bool? passwordObscure, FormState? status}) {
    return RegisterState(
      passwordObscure: passwordObscure ?? this.passwordObscure,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [passwordObscure, status];
}

class FormInitial extends FormState {
  const FormInitial();
  @override
  List<Object?> get props => [];
}

class FormLoading extends FormState {
  const FormLoading();
  @override
  List<Object?> get props => [];
}

class FormSuccess extends FormState {
  const FormSuccess();
  @override
  List<Object?> get props => [];
}

class FormFailure extends FormState {
  final String errorMessage;
  const FormFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
