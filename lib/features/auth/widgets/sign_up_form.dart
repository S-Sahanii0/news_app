import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/app_form_field.dart';
import 'package:news_app/components/buttons/form_button.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key, required this.onSubmit}) : super(key: key);
  static final _formKey = GlobalKey<FormBuilderState>();
  final ValueSetter<GlobalKey<FormBuilderState>> onSubmit;
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: SignUpForm._formKey,
      child: Column(
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
          ),
          SizedBox(
            height: 10.h,
          ),
          FormButton(
            onTap: () {
              widget.onSubmit;
            },
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
