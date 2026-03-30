import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go/core/constants/app_constants.dart';
import 'package:go/core/services/fcm_service.dart';
import 'package:go/core/services/local_notification_service.dart';
import 'package:go/features/home/data/data_source/data_source.dart';
import 'package:go/features/home/data/repository/repo.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:go/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:go/features/auth/data/data_source/auth_data_source.dart';
import 'package:go/features/auth/data/repository/auth_repository.dart';

final getIt = GetIt.instance;

void intiSetupLocator() {
  _setupSecureStorageServiceLocator();
  _setupAuthRepositoryLocator();
  _setupFirestoreServiceLocator();
  _setupHomeServiceLocator();
  _setupOpenRouteServiceLocator();
  _setupNotificationServiceLocator();
}

void _setupSecureStorageServiceLocator() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
  getIt.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(getIt<FlutterSecureStorage>()),
  );
}

void _setupAuthRepositoryLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
      firestore: getIt<FirebaseFirestore>(),
      secureStorageHelper: getIt<SecureStorageHelper>(),
    ),
  );
}

void _setupFirestoreServiceLocator() {
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
}

void _setupHomeServiceLocator() {
  getIt.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeDataSource>()),
  );
  getIt.registerFactory<HomeDataSource>(
    () => HomeDataSourceImpl(
      nominatim: Nominatim(userAgent: AppConstants.nominatimUserAgent),
      ors: getIt<OpenRouteService>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
}

void _setupOpenRouteServiceLocator() {
  getIt.registerLazySingleton<OpenRouteService>(
    () => OpenRouteService(apiKey: dotenv.env['ORS_API_KEY'] ?? ''),
  );
}

void _setupNotificationServiceLocator() {
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );
  getIt.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(getIt<FlutterLocalNotificationsPlugin>()),
  );
  getIt<LocalNotificationService>().init();

  getIt.registerLazySingleton<FCMService>(
    () => FCMService(getIt<LocalNotificationService>()),
  );
}
