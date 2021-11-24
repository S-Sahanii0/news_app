import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/app_form_field.dart';
import '../../../components/buttons/form_button.dart';

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
            validators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context,
                  errorText: "You must enter the username to continue")
            ]),
          ),
          AppFormField(
            fieldTitle: "Email",
            fieldName: "email",
            hintText: "Email",
            suffixIcon: Icons.mail_outline_outlined,
            textInputAction: TextInputAction.next,
            validators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context,
                  errorText: "You must enter the email to continue"),
              FormBuilderValidators.email(context,
                  errorText: "Please enter a valid email address"),
            ]),
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
            validators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context,
                  errorText: "You must enter the password to continue"),
              FormBuilderValidators.minLength(context, 8,
                  errorText: "Your password is too short")
            ]),
          ),
          SizedBox(
            height: 10.h,
          ),
          FormButton(
            onTap: () {
              widget.onSubmit(SignUpForm._formKey);
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
