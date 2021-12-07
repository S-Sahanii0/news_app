import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/config/theme/app_styles.dart';
import '../../../components/app_form_field.dart';
import '../../../components/buttons/form_button.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key, required this.onSubmit, required this.onForgotPassword})
      : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();
  final ValueSetter<GlobalKey<FormBuilderState>> onSubmit;
  final ValueSetter<GlobalKey<FormBuilderState>> onForgotPassword;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget._formKey,
      child: Column(
        children: [
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
            ]),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => widget.onForgotPassword(widget._formKey),
                child: Text(
                  'Forgot Password?',
                  style: AppStyle.mediumText14.copyWith(color: AppColors.darkBlueShade1),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          FormButton(
            onTap: () {
              widget.onSubmit(widget._formKey);
              Navigator.maybePop(context);
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
