  import 'package:flutter_bloc/flutter_bloc.dart';
  import '../../data/model/login_model/login_model.dart';
import '../../data/repositories/login_repositories.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import '../form_bloc/form_submission_status.dart';
import 'login_event.dart';
  import 'login_state.dart';

  class LoginBloc extends Bloc<LoginEvent, LoginState> {
    final LoginRepository authRepo;

    LoginBloc({required this.authRepo}) : super(const LoginState()) {
      on<LoginEvent>((event, emit) async {
        await mapEventToState(event, emit);
      });
    }

    Future<void> mapEventToState(LoginEvent event, Emitter<LoginState> emit) async {
      if (event is LoginPhoneChanged) {
        final isValidPhone = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(event.phone!);
        emit(state.copyWith(
          isValidPhoneNumber: isValidPhone,
          phone: event.phone,
          formStatus: FormEditing(),
        ));
      } else if (event is LoginPasswordChanged) {
        final valid = event.password!.length >= 6;
        emit(state.copyWith(
          isValidPassword: valid,
          password: event.password,
          formStatus: FormEditing(),
        ));
      } else if (event is LoginSubmitted) {
        final isValidPhone = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(state.phone);
        final isValidPassword = state.password.length >= 6;
        final isFormValid = isValidPhone && isValidPassword;

        emit(state.copyWith(
          isValidPhoneNumber: isValidPhone,
          isValidPassword: isValidPassword,
          formStatus: isFormValid ? FormSubmitting() : FormEditing(),
        ));

        if (isFormValid) {
          try {
            final user = LoginModel(phone: state.phone, password: state.password);
            final message = await authRepo.loginUser(user);

            emit(state.copyWith(
              formStatus: SubmissionSuccess(message: "Login successfully"),
            ));
          } catch (e) {
            emit(state.copyWith(
              formStatus: SubmissionFailed(e.toString()),
            ));
          }
        } else {
          emit(state.copyWith(
            formStatus: SubmissionFailed("Enter Valid input"),
          ));
        }
      }
    }
  }
