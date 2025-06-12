class ChangePasswordDto {
  const ChangePasswordDto({
    required this.currentPassword,
    required this.newPassword,
    required this.newConfirmPassword,
  });

  final String currentPassword;
  final String newPassword;
  final String newConfirmPassword;

  Map<String, dynamic> toJson() => {
        'old_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': newConfirmPassword,
      };
}
