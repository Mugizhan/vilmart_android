import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';
import '../bloc/login_bloc/login_state.dart';

class UsernameField extends StatefulWidget {
  const UsernameField({Key? key}) : super(key: key);

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Listen to changes including pasting
    _controller.addListener(() {
      context.read<LoginBloc>().add(
        LoginPhoneChanged(phone: _controller.text),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: const TextStyle(color: Colors.red),
            errorText: state.isValidPhoneNumber ? null : "Enter Valid mail",
            prefixIcon: const Icon(Icons.mail, color: Colors.red),
            filled: true,
            fillColor: Colors.red[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}
