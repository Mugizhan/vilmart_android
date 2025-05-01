import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoginPageLoading extends LoginEvent{}

class LoginPhoneChanged extends LoginEvent {
  final String? phone;
  LoginPhoneChanged({this.phone});
  @override
  List<Object?> get props => [phone];
}

class LoginPasswordChanged extends LoginEvent {
  final String? password;

  LoginPasswordChanged({this.password});

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  @override
  List<Object?> get props => [];
}