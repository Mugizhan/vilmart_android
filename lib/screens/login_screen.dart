import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vilmart_android/bloc/form_bloc/form_submission_status.dart';
import 'package:vilmart_android/bloc/login_bloc/login_bloc.dart';
import 'package:vilmart_android/widgets/loading_screen.dart';
import '../bloc/login_bloc/login_state.dart';
import '../data/repositories/login_repositories.dart';
import '../widgets/login_button.dart';
import '../widgets/userpassword_field.dart';
import '../widgets/userphone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authRepo: context.read<LoginRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async{
            if (state.formStatus is SubmissionSuccess) {
              final successState = state.formStatus as SubmissionSuccess;
              await  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:Row(
                  children: [
                    Icon(Icons.task_alt,color:Colors.white),
                    SizedBox(width: 10),
                    Text(successState.message)
                  ],
                ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
              context.go('/home');
            } else if (state.formStatus is SubmissionFailed) {
              final failedState = state.formStatus as SubmissionFailed;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(

                    content:Row(
                      children: [
                        Icon(Icons.error,color:Colors.white),
                        SizedBox(width: 10),
                        Text(failedState.message)
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior:SnackBarBehavior.floating
                ),

              );
            }
          },
          builder: (context, state) {
            if (state.formStatus is FormSubmitting) {
              return const LoadingScreen();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('Welcome Back',style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red
                                  ),),
                                  Text('Login to your account',style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.015,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      wordSpacing:5
                                  ),),
                                ],
                              ),
                              Image.asset('assets/images/Logo2.png',
                                width: MediaQuery.of(context).size.width * 0.20,
                                height: MediaQuery.of(context).size.height * 0.1, // 7% of screen height
                              )

                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 5% of screen height
                          UsernameField(),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 5% of screen height
                          PasswordField(),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Remember Me',style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),),
                              TextButton(onPressed: (){},
                                child:  Text('Forget Password?',style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),),)
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                          LoginButton(),
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
    );
  }
}

