import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/app_form_field.dart';
import 'package:news_app/components/buttons/form_button.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        ),
        SizedBox(
          height: 10.h,
        ),
        FormButton(
          onTap: () {},
        ),
        SizedBox(
          height: 15.h,
        ),
      ],
    );
  }
}
