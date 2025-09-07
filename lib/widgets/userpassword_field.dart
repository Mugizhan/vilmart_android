import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';
import '../bloc/login_bloc/login_state.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      context.read<LoginBloc>().add(
        LoginPasswordChanged(password: _controller.text),
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
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: const TextStyle(color: Colors.red),
            errorText: state.isValidPassword ? null : 'Enter Valid Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.red),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            filled: true,
            fillColor: Colors.red[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}
