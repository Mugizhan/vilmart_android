import 'package:equatable/equatable.dart';
import '../form_bloc/form_submission_status.dart';

class LoginState extends Equatable {
  final String phone;
  bool get isValidUsername => phone.length == 10;

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  const LoginState({
    this.phone = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? phone,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [phone, password, formStatus];
}
