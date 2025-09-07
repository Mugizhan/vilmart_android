import 'package:equatable/equatable.dart';
import '../form_bloc/form_submission_status.dart';

class LoginState extends Equatable {
  final String phone;
  final bool isValidPhoneNumber;
  final String password;
  final bool isValidPassword;
  final FormSubmissionStatus formStatus;

  const LoginState({
    this.phone = '',
    this.password = '',
    this.isValidPhoneNumber = true,
    this.isValidPassword = true,
    this.formStatus = const InitialFormStatus(),
  });

  bool get isValid => isValidPhoneNumber && isValidPassword;

  LoginState copyWith({
    String? phone,
    String? password,
    bool? isValidPhoneNumber,
    bool? isValidPassword,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isValidPhoneNumber: isValidPhoneNumber ?? this.isValidPhoneNumber,
      isValidPassword: isValidPassword ?? this.isValidPassword,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [
    phone,
    password,
    isValidPhoneNumber,
    isValidPassword,
    formStatus,
  ];
}
