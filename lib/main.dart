import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go/core/config/firebase_options.dart';
import 'package:go/core/constants/string_manager.dart';
import 'package:go/core/di/service_locator.dart';
import 'package:go/core/router/app_router.dart';
import 'package:go/core/router/routes.dart';
import 'package:go/core/theme/app_theme.dart';
import 'package:go/core/theme/cubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  intiSetupLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (_) => ThemeCubit(getIt<FlutterSecureStorage>()),
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              initialRoute: Routes.splash,
              onGenerateRoute: AppRouter.onGenerateRoute,
              title: StringManager.appName,
            );
          },
        ),
      ),
    );
  }
}
