import 'dart:io';

class RegisterDto {
  const RegisterDto({
    required this.password,
    required this.email,
    required this.phone,
    required this.address,
    required this.firstName,
    required this.lastName,this.file});

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String address;
  final File? file;

}
