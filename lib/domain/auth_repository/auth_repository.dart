part of 'repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required APIClient client,
    required this.cacheClient,
    super.cache,
    super.userAuth,
  }) : _client = client;

  final APIClient _client;
  final CacheClient cacheClient;

  @override
  Future<UserModel?> signIn(SignInDto dto) async {
    final userJson = await _client.post(
      handle: AuthEndpoints.login,
      body: dto.toJson(),
    );
    final model = UserModel.fromJson(
      userJson,
    );
    LocalStorageDb.setString('token', userJson['data']['token']);
    _client.setAuthToken(userJson['data']['token']);
    updateUser(model);
    return model;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _client.post(
      handle: AuthEndpoints.forgotPassword,
      body: {
        'email': email,
      },
    );
  }

  @override
  Future<void> signOut() async {
    _client.removeConfigValues();
    updateUser(UserModel.empty);
  }

  @override
  Future<void> register(RegisterDto dto) async {
    final files = dto.file != null
        ? [
            {
              'name': basename(dto.file!.path),
              'path': dto.file!.path,
            }
          ]
        : [];
    await _client.postMultipart(
      handle: AuthEndpoints.register,
      fieldName: 'profile_pic',
      body: {
        'email': dto.email,
        'password': dto.password,
        'first_name': dto.firstName,
        'last_name': dto.lastName,
        'phone': dto.phone,
        'address': dto.address,
        'password_confirmation': dto.password,
      },
      files: files,
    );
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    cacheClient.write(key: 'userData', value: jsonEncode(userModel.toJson()));
  }

  @override
  Future<UserModel?> getUserDetail() async {
    final encodedJson = cacheClient.read<String>(key: 'userData');
    if (encodedJson == null) {
      return null;
    }
    final Map<String, dynamic> decodedJson = jsonDecode(encodedJson);
    if (decodedJson['success'] == false) {
      return null;
    } else {
      final userData = UserModel.fromJson(
        decodedJson,
      );
      final token = LocalStorageDb.getString('token');
      _client.setAuthToken(token);
      return userData;
    }
  }

  @override
  Future<void> changePassword(ChangePasswordDto changePasswordDto) async {
    await _client.post(
      handle: AuthEndpoints.changePassword,
      body: changePasswordDto.toJson(),
    );
  }

  @override
  Future<UserModel?> getUserDetailFromRemote() async {
    final userJson = await _client.get(
      handle: AuthEndpoints.getUserDetail,
    );
    final model = UserModel.fromJson(
      userJson,
    );

    updateUser(model);
    return model;
  }

  @override
  Future<UserModel?> getUser() async {
    bool result = await InternetCheckerClass.checkInternetStatus();
    if (result) {
      return await getUserDetailFromRemote();
    } else {
      return await getUserDetail();
    }
  }
}
