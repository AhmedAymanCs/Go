import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go/core/constants/string_manager.dart';
import 'package:go/core/di/service_locator.dart';
import 'package:go/core/router/routes.dart';
import 'package:go/core/widgets/custom_button.dart';
import 'package:go/core/widgets/cutom_form_field.dart';
import 'package:go/core/widgets/logo_with_text.dart';
import 'package:go/features/auth/data/repository/auth_repository.dart';
import 'package:go/features/auth/presentation/login/logic/cubit.dart';
import 'package:go/features/auth/presentation/login/logic/states.dart';
import 'package:go/features/auth/presentation/login/presentation/shared_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(getIt<AuthRepository>()),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWithText(text: StringManager.subTitleLoginPage),
                  SizedBox(height: 20.h),
                  //Email field
                  CustomFormField(
                    controller: _emailController,
                    hint: StringManager.emailHint,
                    title: StringManager.email,
                    preicon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15.h),
                  //Password field
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      LoginCubit cubit = context.read<LoginCubit>();
                      return CustomFormField(
                        controller: _passwordController,
                        hint: StringManager.passwordHint,
                        title: StringManager.password,
                        preicon: Icons.lock_outlined,
                        obscure: state.passwordObscure,
                        onPressed: cubit.changePasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                      );
                    },
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      LoginCubit cubit = context.read<LoginCubit>();
                      return RememberMeAndForgotPassRow(
                        rememberMeValue: state.rememberMe,
                        checkBoxOnPressed: (value) =>
                            cubit.changeRememberMe(value!),
                        forgotPassOnPressed: () {
                          Navigator.pushNamed(context, Routes.forgetPassword);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state.status is FormSuccess) {
                        final userModel =
                            (state.status as FormSuccess).userModel;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.home,
                          (_) => false,
                          arguments: userModel,
                        );
                      }
                      if (state.status is FormFailure) {
                        final errorMessage =
                            (state.status as FormFailure).message;
                        Fluttertoast.showToast(
                          msg: errorMessage,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                    buildWhen: (previous, current) {
                      return current.status is FormLoading ||
                          current.status is FormFailure;
                    },
                    builder: (context, state) {
                      LoginCubit cubit = context.read<LoginCubit>();
                      if (state.status is FormLoading) {
                        return const CircularProgressIndicator();
                      } else {
                        return CustomButton(
                          text: StringManager.login,
                          onPressed: () => cubit.login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  RegisterRow(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.register);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
