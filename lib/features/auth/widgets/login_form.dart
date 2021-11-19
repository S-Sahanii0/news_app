import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/app_form_field.dart';
import '../../../components/buttons/form_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.onSubmit}) : super(key: key);
  static final _formKey = GlobalKey<FormBuilderState>();
  final ValueSetter<GlobalKey<FormBuilderState>> onSubmit;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: LoginForm._formKey,
      child: Column(
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
            onTap: () => widget.onSubmit(LoginForm._formKey),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
