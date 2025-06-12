

class SignInDto {
  const SignInDto({
    required this.password,
    required this.email,
    required this.rememberMe,
    required this.deviceId,
    required this.fcmToken,
  });

  final String email;
  final String password;
  final String rememberMe;
  final String fcmToken;
  final String deviceId;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'remember_me': rememberMe,
        'fcm_token': fcmToken,
        'device_id': deviceId,
      };
}
