import 'package:equatable/equatable.dart';
import '../form_bloc/form_submission_status.dart';

class RegisterState extends Equatable {
  final String name;
  final String email;
  final String phoneNumber;
  final int otpNumber;
  final String password;
  final String confirmPassword;
  final String termsAccepted;
  final FormSubmissionStatus formStatus;

  final bool isNameValid;
  final bool isEmailValid;
  final bool isPhoneValid;
  final bool isOtpValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isTermsAccepted;

  const RegisterState({
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.otpNumber=0,
    this.password = '',
    this.confirmPassword = '',
    this.termsAccepted = '',
    this.formStatus = const InitialFormStatus(),

    this.isNameValid = true,
    this.isEmailValid = true,
    this.isPhoneValid = true,
    this.isOtpValid=false,
    this.isPasswordValid = true,
    this.isConfirmPasswordValid = true,
    this.isTermsAccepted = true,
  });


  RegisterState copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    int? otpNumber,
    String? password,
    String? confirmPassword,
    String? termsAccepted,
    FormSubmissionStatus? formStatus,
    bool? isNameValid,
    bool? isEmailValid,
    bool? isPhoneValid,
    bool? isOtpValid,
    bool? isDobValid,
    bool? isStreetValid,
    bool? isStateValid,
    bool? isCountryValid,
    bool? isGenderValid,
    bool? isAboutValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isTermsAccepted,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpNumber: otpNumber??this.otpNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      formStatus: formStatus ?? this.formStatus,

      isNameValid: isNameValid ?? this.isNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isOtpValid: isOtpValid??this.isOtpValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phoneNumber,
    otpNumber,
    password,
    confirmPassword,
    termsAccepted,
    formStatus,
    isNameValid,
    isEmailValid,
    isPhoneValid,
    isPasswordValid,
    isConfirmPasswordValid,
    isTermsAccepted,
  ];
}
