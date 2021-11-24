import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/buttons/app_button.dart';
import 'package:news_app/components/buttons/app_outlined_button.dart';
import '../../../components/app_form_field.dart';
import '../../../components/buttons/form_button.dart';

class ChangePasswordForm extends StatefulWidget {
  ChangePasswordForm({Key? key, required this.onSubmit}) : super(key: key);
  static final _formKey = GlobalKey<FormBuilderState>();
  final ValueSetter<GlobalKey<FormBuilderState>> onSubmit;

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: ChangePasswordForm._formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          children: [
            AppFormField(
              fieldTitle: "Password",
              fieldName: "password",
              hintText: "Password",
              isObscure: isObscure,
              suffixIcon: Icons.remove_red_eye_outlined,
              textInputAction: TextInputAction.next,
              validators: FormBuilderValidators.required(context,
                  errorText: "You must enter the password to continue"),
            ),
            AppFormField(
              isObscure: isObscure,
              fieldTitle: "Confirm Password",
              fieldName: "confirm",
              hintText: "Confirm Password",
              onTap: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              suffixIcon: Icons.remove_red_eye_outlined,
              textInputAction: TextInputAction.done,
              validators: FormBuilderValidators.required(context,
                  errorText: "You must enter the password again to continue"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppOutlinedButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      buttonText: "Cancel"),
                  AppButton(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onSubmit(ChangePasswordForm._formKey);
                      },
                      buttonText: "Confirm")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
