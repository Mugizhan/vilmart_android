import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/form_bloc/form_submission_status.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/register_bloc/register_event.dart';
import '../bloc/register_bloc/register_state.dart';
import '../data/repositories/register_repository.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        registerRepository: context.read<RegisterRepository>(),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:
                Flexible(
                  child: Text(
                    formStatus.message,
                    overflow: TextOverflow.ellipsis,  // Ensures text is truncated if it overflows
                    maxLines: 1,  // Prevents text from wrapping to multiple lines
                  ),
                ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),),

              );
              context.go('/');
            } else if (formStatus is SubmissionFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:Flexible(
                  child: Text(
                    formStatus.message,
                    overflow: TextOverflow.ellipsis,  // Ensures text is truncated if it overflows
                    maxLines: 1,  // Prevents text from wrapping to multiple lines
                  ),
                ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),),
              );
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/RegisterLogo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      'Please enter your details',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.015,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'assets/images/Logo2.png',
                                  width: MediaQuery.of(context).size.width * 0.20,
                                  height: MediaQuery.of(context).size.height * 0.1,
                                ),
                              ],
                            ),
                            const RegistrationForm(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterBloc>().state;
    return SingleChildScrollView(
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height:20),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person,color: Colors.red),
                hintStyle: TextStyle(color: Colors.red),
                hintText: 'Name',
                errorText: state.isNameValid ? null : 'Name is required',
                filled: true,
                fillColor: Colors.red[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => context.read<RegisterBloc>().add(NameChanged(name: value)),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail,color:Colors.red),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.red),
                errorText: state.isEmailValid ? null : 'Enter a valid email',
                filled: true,
                fillColor: Colors.red[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => context.read<RegisterBloc>().add(EmailChanged(email: value)),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone,color:Colors.red),
              //   suffixIcon:   Visibility(
              //     visible: state.isPhoneValid&&state.phoneNumber.isNotEmpty,
              //     child: TextButton(
              //       onPressed: () {
              // context.go('/otp');
              //       },
              //       child: Text("Verify",style: TextStyle(
              //         color: Colors.green
              //       ),),
              //     ),
              //   ),
                hintText: 'Phone Number',
                errorText: state.isPhoneValid ? null : 'Enter a 10-digit phone number',
                filled: true,
                hintStyle: TextStyle(color: Colors.red),
                fillColor: Colors.red[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),

              keyboardType: TextInputType.phone,
              onChanged: (value) => context.read<RegisterBloc>().add(PhoneChanged(phoneNumber: value)),
            ),


            SizedBox(height: 10),
            // Password Field
            TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.red),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                prefixIcon: Icon(Icons.lock,color: Colors.red),
                hintText: 'Password',
                errorText: state.isPasswordValid ? null : 'Password must be at least 6 characters',
                filled: true,
                fillColor: Colors.red[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: !_isPasswordVisible,
              onChanged: (value) =>
                  context.read<RegisterBloc>().add(PasswordChanged(password: value)),
            ),

            SizedBox(height: 10),

// Confirm Password Field
            TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.red),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                prefixIcon: Icon(Icons.lock,color: Colors.red),
                hintText: 'Confirm Password',
                errorText: state.isConfirmPasswordValid ? null : 'Passwords do not match',
                filled: true,
                fillColor: Colors.red[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: !_isConfirmPasswordVisible,
              onChanged: (value) => context
                  .read<RegisterBloc>()
                  .add(ConfirmPasswordChanged(confirmPassword: value)),
            ),

            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: state.termsAccepted == 'true',
                  onChanged: (value) {
                    context.read<RegisterBloc>().add(
                      ConditionChanged(accepted: value == true ? 'true' : 'false'),
                    );
                  },
                ),
                const Text('Accept terms and conditions'),
              ],
            ),
            if (!state.isTermsAccepted)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'You must accept the terms',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.read<RegisterBloc>().add(RegisterSubmit());
                },
                child: Container(
                  child: Text('Register',style:TextStyle(
                    color: Colors.white,
                  )),
                )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                  TextButton(onPressed: (){
                    context.go('/');
                  },
                    child:  Text('Login in',style: TextStyle(
                      color: Colors.indigo,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




