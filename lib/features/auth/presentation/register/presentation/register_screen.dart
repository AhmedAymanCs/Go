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
import 'package:go/features/auth/data/models/register_prams_model.dart';
import 'package:go/features/auth/data/repository/auth_repository.dart';
import 'package:go/features/auth/presentation/register/logic/cubit.dart';
import 'package:go/features/auth/presentation/register/logic/states.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(getIt<AuthRepository>()),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWithText(text: StringManager.subTitleRegisterPage),
                  SizedBox(height: 20.h),
                  //Name field
                  CustomFormField(
                    controller: _nameController,
                    hint: StringManager.nameHint,
                    title: StringManager.name,
                    preicon: Icons.person_outlined,
                  ),
                  SizedBox(height: 15.h),
                  //Email field
                  CustomFormField(
                    controller: _emailController,
                    hint: StringManager.emailHint,
                    title: StringManager.email,
                    preicon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15.h),
                  //phone field
                  CustomFormField(
                    controller: _phoneController,
                    hint: StringManager.phoneHint,
                    title: StringManager.phone,
                    preicon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 15.h),
                  //Password field
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      RegisterCubit cubit = context.read<RegisterCubit>();
                      return CustomFormField(
                        controller: _passwordController,
                        hint: StringManager.passwordHint,
                        title: StringManager.password,
                        preicon: Icons.lock_outlined,
                        obscure: state.passwordObscure,
                        onPressed: cubit.changePasswordVisible,
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  //Confirm Password field
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      return CustomFormField(
                        controller: _confirmPasswordController,
                        hint: StringManager.confirmPasswordHint,
                        title: StringManager.confirmPassword,
                        preicon: Icons.lock_outlined,
                        obscure: state.passwordObscure,
                      );
                    },
                  ),
                  SizedBox(height: 50.h),
                  BlocListener<RegisterCubit, RegisterState>(
                    listener: (context, state) {
                      if (state.status is FormSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.login,
                          (_) => false,
                        );
                      }
                      if (state.status is FormFailure) {
                        final errorMessage =
                            (state.status as FormFailure).errorMessage;
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
                    child: BlocBuilder<RegisterCubit, RegisterState>(
                      buildWhen: (previous, current) {
                        return current.status is FormLoading ||
                            current.status is FormFailure;
                      },
                      builder: (context, state) {
                        RegisterCubit cubit = context.read<RegisterCubit>();
                        if (state.status is FormLoading) {
                          return const CircularProgressIndicator();
                        } else {
                          return CustomButton(
                            text: StringManager.signUp,
                            onPressed: () => cubit.register(
                              RegisterParamsModel(
                                name: _nameController.text,
                                phone: _phoneController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
                              ),
                            ),
                          );
                        }
                      },
                    ),
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
