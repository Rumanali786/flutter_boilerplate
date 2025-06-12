class AuthEndpoints {
  const AuthEndpoints._();

  static const login = '/login';
  static const register = '/register';
  static const updateProfile = '/user/updateProfile';
  static const changePassword = '/user/changePassword';
  static const forgotPassword = '/forgot-password';
  static const support = '/support';
  static const goals = '/user-goals';
  static const getUserDetail = '/user/getInfo';
  static const getAllJuz = '/parts';
  static const userProgress = '/goal/progress';

  static String updateGoal(String userId) => '/user-goals/$userId';
}
