import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}

class NameChanged extends RegisterEvent {
  final String name;
  const NameChanged({required this.name});
  @override
  List<Object?> get props => [name];
}

class EmailChanged extends RegisterEvent {
  final String email;
  const EmailChanged({required this.email});
  @override
  List<Object?> get props => [email];
}

class PhoneChanged extends RegisterEvent {
  final String phoneNumber;
  const PhoneChanged({required this.phoneNumber});
  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneVerifyClicked extends RegisterEvent {}

class OTPChanged extends RegisterEvent {
  final String otpNumber;
  const OTPChanged({required this.otpNumber});
  @override
  List<Object?> get props => [otpNumber];
}

class PasswordChanged extends RegisterEvent {
  final String password;
  const PasswordChanged({required this.password});
  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  const ConfirmPasswordChanged({required this.confirmPassword});
  @override
  List<Object?> get props => [confirmPassword];
}

class ConditionChanged extends RegisterEvent {
  final String accepted;
  const ConditionChanged({required this.accepted});
  @override
  List<Object?> get props => [accepted];
}


class RegisterSubmit extends RegisterEvent {}
