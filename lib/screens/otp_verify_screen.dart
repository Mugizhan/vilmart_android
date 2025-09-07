import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form_bloc/form_submission_status.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/register_bloc/register_event.dart';
import '../bloc/register_bloc/register_state.dart';
import '../data/repositories/register_repository.dart';

class OtpVerifyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(registerRepository: context.read<RegisterRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OTP Verification'),
        ),
        body: const _OtpForm(),
      ),
    );
  }
}

class _OtpForm extends StatelessWidget {
  const _OtpForm();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        final status = state.formStatus;
        if (status is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(status.message)),
          );
          Navigator.pop(context); // Or navigate to a success screen
        } else if (status is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred")),
          );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          // Print the phone number for debugging
          print("Phone Number: ${state.phoneNumber}");

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enter OTP sent to +91 ${state.phoneNumber}"),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  onChanged: (otp) {
                    context.read<RegisterBloc>().add(OTPChanged(otpNumber: otp));
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'OTP',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 20),
                state.formStatus is FormSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: state.isOtpValid
                      ? () {
                    context.read<RegisterBloc>().add(RegisterSubmit());
                  }
                      : null,
                  child: const Text("Verify"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
