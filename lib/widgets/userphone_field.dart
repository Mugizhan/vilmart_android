import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration:InputDecoration(
        hintText: "Phone Number",
        hintStyle: TextStyle(color: Colors.red),
        prefixIcon: Icon(Icons.person,color: Colors.red),
        filled: true,
        fillColor: Colors.red[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) => context.read<LoginBloc>().add(LoginPhoneChanged(phone:value)),
      keyboardType:TextInputType.phone,
    );
  }
}
