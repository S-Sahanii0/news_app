import 'package:flutter/material.dart';
import 'package:news_app/components/app_form_field.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppFormField(
          fieldTitle: "Username",
          fieldName: "username",
          hintText: "Username",
          suffixIcon: Icons.person_outline_outlined,
          textInputAction: TextInputAction.next,
        ),
        AppFormField(
          fieldTitle: "Email",
          fieldName: "email",
          hintText: "Email",
          suffixIcon: Icons.mail_outline_outlined,
          textInputAction: TextInputAction.next,
        ),
        AppFormField(
          isObscure: isObscure,
          fieldTitle: "Password",
          fieldName: "password",
          hintText: "Password",
          onTap: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
          suffixIcon: Icons.remove_red_eye_outlined,
          textInputAction: TextInputAction.done,
        )
      ],
    );
  }
}
