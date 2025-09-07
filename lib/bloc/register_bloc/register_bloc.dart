import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/register_model/register_model.dart';
import '../../data/repositories/register_repository.dart';
import '../form_bloc/form_submission_status.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;

  RegisterBloc({required this.registerRepository}) : super(const RegisterState()) {
    on<RegisterEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  Future<void> mapEventToState(RegisterEvent event, Emitter<RegisterState> emit) async {
    if (event is NameChanged) {
      emit(state.copyWith(
        name: event.name,
        isNameValid: event.name.isNotEmpty,
        formStatus: FormEditing(),
      ));
    } else if (event is EmailChanged) {
      final isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(event.email);
      emit(state.copyWith(
        email: event.email,
        isEmailValid: isValidEmail,
        formStatus: FormEditing(),
      ));
    } else if (event is PhoneChanged) {
      final isValidPhone = RegExp(r'^\d{10}$').hasMatch(event.phoneNumber);
      emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        isPhoneValid: isValidPhone,
        formStatus: FormEditing(),
      ));
    }
    // Uncomment if OTP is used
    // else if (event is OTPChanged) {
    //   final otp = int.tryParse(event.otpNumber) ?? 0;
    //   emit(state.copyWith(
    //     otpNumber: otp,
    //     isOtpValid: event.otpNumber.length == 4,
    //     formStatus: FormEditing(),
    //   ));
    // }
    else if (event is PasswordChanged) {
      emit(state.copyWith(
        password: event.password,
        isPasswordValid: event.password.length >= 6,
        isConfirmPasswordValid: event.password == state.confirmPassword,
        formStatus: FormEditing(),
      ));
    } else if (event is ConfirmPasswordChanged) {
      emit(state.copyWith(
        confirmPassword: event.confirmPassword,
        isConfirmPasswordValid: state.password == event.confirmPassword,
        formStatus: FormEditing(),
      ));
    } else if (event is ConditionChanged) {
      final isAccepted = event.accepted == 'true';
      emit(state.copyWith(
        termsAccepted: event.accepted,
        isTermsAccepted: isAccepted,
        formStatus: FormEditing(),
      ));
    } else if (event is RegisterSubmit) {
      // Revalidate all fields before submission
      final updatedState = state.copyWith(
        isNameValid: state.name.isNotEmpty,
        isEmailValid: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(state.email),
        isPhoneValid: RegExp(r'^\d{10}$').hasMatch(state.phoneNumber),
        // isOtpValid: state.otpNumber.toString().length == 4,
        isPasswordValid: state.password.length >= 6,
        isConfirmPasswordValid: state.password == state.confirmPassword,
        isTermsAccepted: state.termsAccepted == 'true',
        formStatus: FormSubmitting(),
      );

      emit(updatedState);

      final isValid = state.isNameValid &&
          state.isEmailValid &&
          state.isPhoneValid &&
          // updatedState.isOtpValid &&
          state.isPasswordValid &&
          state.isConfirmPasswordValid &&
          state.isTermsAccepted;

      if (isValid) {
        try {
          final phone = int.tryParse(updatedState.phoneNumber) ?? 0;

          final userData = RegisterModel(
            name: updatedState.name,
            email: updatedState.email,
            phoneNumber: phone,
            password: updatedState.password,
          );

          final response = await registerRepository.storeData(userData);

          emit(updatedState.copyWith(
            formStatus: SubmissionSuccess(message: "Registration Successful"),
          ));
        } catch (e) {
          emit(updatedState.copyWith(
            formStatus: SubmissionFailed("Registration failed: ${e.toString()}"),
          ));
        }
      } else {
        emit(updatedState.copyWith(
          formStatus:SubmissionFailed("Please fill the form correctly"),
        ));
      }
    }
  }
}
