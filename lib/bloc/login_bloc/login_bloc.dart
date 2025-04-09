import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilmart_android/bloc/form_bloc/form_submission_status.dart';
import 'package:vilmart_android/data/model/login_model/login_model.dart';
import '../../data/repositories/login_repositories.dart';
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
        emit(state.copyWith(phone: event.phone,formStatus:FormEditing()));
      } else if (event is LoginPasswordChanged) {
        emit(state.copyWith(password: event.password,formStatus:FormEditing()));
      } else if (event is LoginSubmitted) {
        emit(state.copyWith(formStatus: FormSubmitting()));

        try {
          final user = LoginModel(phone: state.phone, password: state.password);
          final message = await authRepo.loginUser(user);
          emit(state.copyWith(
              formStatus: SubmissionSuccess(message: message.toString())));
        } catch (e) {
          emit(state.copyWith(formStatus: SubmissionFailed(e.toString())));
        }
      }
    }}