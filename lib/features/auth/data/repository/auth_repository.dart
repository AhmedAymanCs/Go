import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go/core/constants/app_constants.dart';
import 'package:go/core/constants/string_manager.dart';
import 'package:go/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:go/core/models/user_model.dart';
import 'package:go/core/utils/typedef.dart';
import 'package:go/features/auth/data/data_source/auth_data_source.dart';
import 'package:go/features/auth/data/models/register_prams_model.dart';

abstract class AuthRepository {
  ServerResponse<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });
  ServerResponse<Unit> register(RegisterParamsModel params);
  ServerResponse<void> sendPasswordResetEmail({required String email});
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final FirebaseFirestore firestore;
  final SecureStorageHelper secureStorageHelper;
  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.firestore,
    required this.secureStorageHelper,
  });

  @override
  ServerResponse<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final userCredential = await authRemoteDataSource.login(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final userDoc = await firestore
            .collection(AppConstants.usersCollectionName)
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final userModel = UserModel.fromJson({
            ...userDoc.data()!,
            'uId': userDoc.id,
          });

          if (rememberMe) {
            String sessionData = jsonEncode(userModel.toJson());
            await secureStorageHelper.saveUserData(sessionData);
          }

          return Right(userModel);
        } else {
          return Left("User data record not found in database");
        }
      }
      return Left("Authentication failed");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return Left(StringManager.userNotFound);
      }
      return Left(e.message ?? 'Something went wrong');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<Unit> register(RegisterParamsModel params) async {
    try {
      await authRemoteDataSource.register(params);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left(StringManager.weekPassword);
      } else if (e.code == 'email-already-in-use') {
        return Left(StringManager.emailAlreadyInUse);
      }
      return Left(e.message ?? 'Authentication Error');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<Unit> sendPasswordResetEmail({required String email}) async {
    try {
      await authRemoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
