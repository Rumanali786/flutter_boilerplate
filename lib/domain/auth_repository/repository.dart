import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import '../../presentation/app/services/internet_checker_service.dart';
import '../../utils/cache_client/cache_client.dart';
import '../../utils/cache_client/local_db.dart';
import '../../utils/helpers/api_client.dart';
import 'config/auth_endpoints.dart';
 import 'dtos/change_password_dto.dart';
import 'dtos/register_dto.dart';
 import 'dtos/sign_in_dto.dart';
 import 'models/user_model.dart';

export 'dtos/dtos.dart';

part 'auth_repository.dart';

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
abstract class AuthRepository {
  /// {@macro authentication_repository}
  AuthRepository({
    CacheClient? cache,
    StreamController<UserModel>? userAuth,
  })  : _cache = cache ?? HiveCacheClient(),
        _userAuth = userAuth ?? StreamController<UserModel>.broadcast();

  final CacheClient _cache;
  final StreamController<UserModel> _userAuth;
  bool isRemember = false;
  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';


  Future<UserModel?> signIn(SignInDto dto);

  Future<void> register(RegisterDto dto);


  Future<void> updateUser(UserModel userModel);

  Future<void> changePassword(ChangePasswordDto changePasswordDto);

  Future<UserModel?> getUserDetail();
  Future<UserModel?> getUserDetailFromRemote();


  Future<UserModel?> getUser();

  Future<void> forgotPassword(String email);

  Future<void> signOut();

  /// disposes the _userAuth stream
  Future<void> dispose() async {
    await _cache.close();
    await _userAuth.close();
  }
}
