import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:disoriza/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client;
  const AuthRepositoryImpl({required this.client});

  @override
  Future<Either<Exception, UserModel>> checkSession() async {
    try {
      final user = client.auth.currentSession;
      if (user == null) return Left(Exception('No active session'));

      final uid = user.user.id;
      final userModel = await fetchUserModel(uid: uid);
      if (userModel != null) {
        await _syncEmailIfNeeded(
          uid: uid,
          authEmail: user.user.email,
          dbEmail: userModel.email,
        );
        return Right(userModel);
      }

      return Right(UserModel.fromMap(user.user.toJson()));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<UserModel?> fetchUserModel({required String uid}) async {
    try {
      final user = await client.from('users').select().eq('id', uid).single();
      if (user.isNotEmpty) return UserModel.fromMap(user);
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Syncs email from auth to users table if they differ.
  Future<void> _syncEmailIfNeeded({
    required String uid,
    required String? authEmail,
    required String? dbEmail,
  }) async {
    if (authEmail != null && authEmail != dbEmail) {
      try {
        await client.from('users').update({'email': authEmail}).eq('id', uid);
      } catch (e, st) {
        debugPrint('_syncEmailIfNeeded error: $e\n$st');
      }
    }
  }

  @override
  Future<Either<Exception, UserModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final account = await client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'profile_picture': null},
      );

      final user = account.user;
      if (user == null || user.id.isEmpty) {
        return Left(Exception('Registration failed: user not created'));
      }

      await client.from('users').insert({
        'id': user.id,
        'name': name,
        'email': email,
        'profile_picture': null,
      });

      return Right(UserModel(id: user.id, name: name, email: email));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (session.user == null) return Left(Exception('Error login!'));

      final uid = session.user!.id;
      final userModel = await fetchUserModel(uid: uid);
      if (userModel != null) {
        await _syncEmailIfNeeded(
          uid: uid,
          authEmail: session.user?.email,
          dbEmail: userModel.email,
        );
        return Right(userModel);
      }

      return Right(UserModel.fromMap(session.user!.toJson()));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      final clearedSession = await client.auth.signOut();
      return Right(clearedSession);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> resetPassword({required String email}) async {
    try {
      await client.auth.resetPasswordForEmail(email);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, UserModel>> editProfile({
    required String uid,
    String? name,
    Uint8List? image,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (image != null) {
        final path = '/$uid.png';
        final user = await fetchUserModel(uid: uid);

        if (user?.profilePicture != null) {
          await client.storage.from('user_profile').updateBinary(path, image);
        } else {
          await client.storage.from('user_profile').uploadBinary(path, image);
        }
        final url = client.storage.from('user_profile').getPublicUrl(path);

        updates['profile_picture'] = url;
      }

      final response = await client
          .from('users')
          .update(updates)
          .eq('id', uid)
          .select()
          .single();

      final updatedUser = UserModel.fromMap(response);
      return Right(updatedUser);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> changeEmail({required String email}) async {
    try {
      await client.auth.updateUser(UserAttributes(email: email));
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
