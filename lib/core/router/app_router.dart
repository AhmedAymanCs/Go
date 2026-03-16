import 'package:flutter/material.dart';
import 'package:go/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:go/core/di/service_locator.dart';
import 'package:go/core/router/routes.dart';
import 'package:go/features/auth/presentation/forget_passoword/presentation/forget_password_screen.dart';
import 'package:go/features/auth/presentation/login/presentation/login_screen.dart';
import 'package:go/features/auth/presentation/register/presentation/register_screen.dart';
import 'package:go/features/home/presentation/home_screen.dart';
import 'package:go/features/splash/screens/splash_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) =>
              SplashScreen(secureStorageHelper: getIt<SecureStorageHelper>()),
        );
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case Routes.forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordPage());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomePage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Not Found : ${settings.name}')),
          ),
        );
    }
  }
}
