import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:news_app/config/theme/theme.dart';

class AppFormField extends StatelessWidget {
  AppFormField(
      {Key? key,
      required this.fieldTitle,
      required this.fieldName,
      required this.hintText,
      this.isObscure,
      this.onTap,
      this.validators,
      required this.suffixIcon,
      required this.textInputAction})
      : super(key: key);

  final String fieldTitle, fieldName, hintText;
  final IconData suffixIcon;
  final TextInputAction textInputAction;
  FormFieldValidator<String>? validators;
  bool? isObscure;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldTitle,
            style: AppStyle.regularText16
                .copyWith(color: AppColors.darkBlueShade1),
          ),
          FormBuilderTextField(
            validator: validators,
            obscureText: isObscure ?? false,
            name: fieldName,
            textInputAction: textInputAction,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                        color: AppColors.greyShade2, width: 5.0)),
                suffixIcon: GestureDetector(
                  onTap: onTap ?? () {},
                  child: Icon(
                    suffixIcon,
                    color: AppColors.greyShade3,
                    size: 20,
                  ),
                ),
                hintText: hintText,
                hintStyle:
                    AppStyle.lightText12.copyWith(color: AppColors.greyShade1)),
          )
        ],
      ),
    );
  }
}
